# nConnect - Backend & API Development Next Steps

## Current State
The frontend is built with direct Supabase client access. As the platform scales, consider implementing a backend layer.

---

## Recommended Architecture Evolution

### Phase 1: Current (MVP)
```
Flutter App
    ↓ (Direct Supabase Client)
Supabase (DB + Auth)
```

**Pros**: Fast development, low latency, cost-effective
**Cons**: Sensitive logic in frontend, harder to add payment processing, scaling complexity

### Phase 2: Backend Layer (Recommended for Production)
```
Flutter App
    ↓ (HTTP/REST API)
Express/Fastify Backend (Node.js)
    ↓ (Supabase Admin SDK)
Supabase (DB + Auth)
```

**Pros**: Centralized logic, payment integration, audit trail, scalability
**Cons**: Additional infrastructure costs, latency increases slightly

---

## Supabase Edge Functions (Serverless Approach)

**Best Option for Current Setup**: Use Supabase Edge Functions (Deno-based serverless)

### Why Edge Functions?
- Deployed directly in Supabase
- Zero cold start time
- No infrastructure management
- Automatic scaling
- Built-in PostgreSQL connection
- Low cost

### Example Implementation

```typescript
// supabase/functions/create-order/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  // Only accept POST
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 })
  }

  const { 
    customerId, 
    serviceId, 
    packageType, 
    addons 
  } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL'),
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
  )

  try {
    // Get platform fee percentage
    const { data: settings } = await supabase
      .from('platform_settings')
      .select('platform_fee_percentage')
      .limit(1)
      .single()

    const platformFeePercentage = settings?.platform_fee_percentage || 15

    // Get service & package details
    const { data: service } = await supabase
      .from('services')
      .select('id, provider_id, delivery_time_days, max_revisions')
      .eq('id', serviceId)
      .single()

    const { data: package_data } = await supabase
      .from('service_packages')
      .select('price')
      .eq('id', packageType)
      .single()

    // Calculate total
    let basePrice = package_data.price || 0
    
    if (addons && addons.length > 0) {
      const { data: addon_data } = await supabase
        .from('service_addons')
        .select('price')
        .in('id', addons)
      
      basePrice += addon_data.reduce((sum, a) => sum + a.price, 0)
    }

    const platformFee = basePrice * (platformFeePercentage / 100)
    const totalAmount = basePrice + platformFee

    // Create order (transaction begins)
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .insert({
        customer_id: customerId,
        service_id: serviceId,
        professional_id: service.provider_id,
        package_type: packageType,
        base_price: basePrice,
        platform_fee_amount: platformFee,
        total_amount: totalAmount,
        delivery_time_days: service.delivery_time_days,
        max_revisions: service.max_revisions,
        status: 'pending',
        created_at: new Date().toISOString()
      })
      .select()
      .single()

    if (orderError) throw orderError

    // Create escrow payment
    const { error: escrowError } = await supabase
      .from('escrow_payments')
      .insert({
        order_id: order.id,
        customer_id: customerId,
        professional_id: service.provider_id,
        amount: totalAmount,
        platform_fee_amount: platformFee,
        professional_amount: basePrice,
        status: 'held',
        created_at: new Date().toISOString()
      })

    if (escrowError) throw escrowError

    // Log transaction
    const { error: transactionError } = await supabase
      .from('transactions')
      .insert({
        user_id: customerId,
        type: 'order',
        amount: totalAmount,
        status: 'completed',
        description: `Order placed for service ${serviceId}`,
        related_order_id: order.id,
        created_at: new Date().toISOString()
      })

    if (transactionError) throw transactionError

    // Audit log
    await supabase
      .from('audit_logs')
      .insert({
        admin_id: null,
        action: 'ORDER_CREATED',
        table_name: 'orders',
        record_id: order.id,
        changes: { order, escrow: { amount: totalAmount } }
      })

    return new Response(
      JSON.stringify({ 
        success: true, 
        order_id: order.id,
        total_amount: totalAmount
      }),
      { headers: { "Content-Type": "application/json" } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { "Content-Type": "application/json" } }
    )
  }
})
```

### Deploy Edge Function
```bash
# Install Supabase CLI
npm install -g supabase

# Deploy function
supabase functions deploy create-order
```

### Call from Flutter
```dart
Future<void> _placeOrderViaFunction(Map<String, dynamic> orderData) async {
  final response = await Supabase.instance.client.functions.invoke(
    'create-order',
    body: orderData,
  );

  if (response.status == 200) {
    final result = response.data;
    print('Order created: ${result['order_id']}');
  }
}
```

---

## Additional Edge Functions to Implement

### 1. approve-escrow (Admin Only)
```
POST /functions/v1/approve-escrow
Body: { escrow_id, admin_id, notes }
Response: { success, escaped_id, professional_amount_released }
```

### 2. request-withdrawal (Professional)
```
POST /functions/v1/request-withdrawal
Body: { professional_id, amount }
Response: { success, withdrawal_id, status }
```

### 3. approve-withdrawal (Admin)
```
POST /functions/v1/approve-withdrawal
Body: { withdrawal_id, admin_id }
Response: { success, transaction_id, payout_status }
```

### 4. submit-task (Professional)
```
POST /functions/v1/submit-task
Body: { order_id, description, attachments }
Response: { success, task_id }
```

### 5. request-revision (Customer)
```
POST /functions/v1/request-revision
Body: { order_id, revision_notes }
Response: { success, revised_order_id }
```

### 6. confirm-order (Customer)
```
POST /functions/v1/confirm-order
Body: { order_id, satisfaction_rating }
Response: { success, escrow_ready_for_approval }
```

---

## Payment Processing Integration

### Current State
Escrow created but no actual payment capture. The `escrow_payments` table holds the "theoretical" payment.

### Integration with Stripe (Recommended)

#### Step 1: Create Payment Intent (Edge Function)
```typescript
// supabase/functions/create-payment-intent/index.ts
import Stripe from "https://esm.sh/stripe@13.0.0?target=deno"

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY'))

serve(async (req) => {
  const { order_id, amount, customer_email } = await req.json()

  const paymentIntent = await stripe.paymentIntents.create({
    amount: Math.round(amount * 100), // Convert to cents
    currency: 'usd',
    metadata: { order_id },
    receipt_email: customer_email
  })

  return new Response(JSON.stringify({
    client_secret: paymentIntent.client_secret,
    intent_id: paymentIntent.id
  }))
})
```

#### Step 2: Confirm Payment in Flutter
```dart
Future<bool> _confirmPayment(String clientSecret, String orderId) async {
  try {
    final result = await Stripe.instance.confirmPaymentIntent(
      paymentIntentClientSecret: clientSecret,
    );

    if (result.status == PaymentIntentsStatus.Succeeded) {
      // Payment successful - update escrow status
      await Supabase.instance.client
        .from('escrow_payments')
        .update({'status': 'captured'})
        .eq('order_id', orderId);

      return true;
    }
  } catch (e) {
    print('Payment failed: $e');
    return false;
  }
}
```

---

## Database Functions (Advanced)

For complex operations, create PostgreSQL functions:

```sql
-- Calculate platform fee
CREATE OR REPLACE FUNCTION calculate_platform_fee(
  p_base_price DECIMAL,
  p_order_id UUID
) RETURNS TABLE (
  platform_fee DECIMAL,
  professional_amount DECIMAL,
  total DECIMAL
) AS $$
DECLARE
  v_fee_percentage DECIMAL;
BEGIN
  SELECT platform_fee_percentage INTO v_fee_percentage
  FROM platform_settings LIMIT 1;
  
  RETURN QUERY SELECT
    p_base_price * (v_fee_percentage / 100),
    p_base_price,
    p_base_price * (1 + v_fee_percentage / 100);
END;
$$ LANGUAGE plpgsql;

-- Release escrow (Admin only)
CREATE OR REPLACE FUNCTION release_escrow_payment(
  p_escrow_id UUID,
  p_admin_id UUID
) RETURNS TABLE (
  success BOOLEAN,
  professional_wallet_updated DECIMAL
) AS $$
DECLARE
  v_professional_amount DECIMAL;
  v_professional_id UUID;
BEGIN
  -- Get escrow details
  SELECT ep.professional_amount, ep.professional_id INTO v_professional_amount, v_professional_id
  FROM escrow_payments ep
  WHERE ep.id = p_escrow_id;

  -- Update escrow status
  UPDATE escrow_payments
  SET status = 'released', released_at = NOW()
  WHERE id = p_escrow_id;

  -- Add to professional wallet
  UPDATE users
  SET wallet_balance = wallet_balance + v_professional_amount
  WHERE uid = v_professional_id;

  RETURN QUERY SELECT true, v_professional_amount;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## API Documentation (Future REST API)

### Base URL
```
https://api.nconnect.com/v1
```

### Authentication
```
Authorization: Bearer <JWT_TOKEN>
```

### Endpoints

#### Orders
```
POST   /orders                      Create order (calls edge function)
GET    /orders/:id                  Get order details
PATCH  /orders/:id/status           Update order status
GET    /customers/:id/orders        List customer's orders
GET    /professionals/:id/orders    List professional's orders
```

#### Escrow Payments
```
GET    /escrow/:id                  Get escrow payment
PATCH  /escrow/:id/approve          Admin approve release
PATCH  /escrow/:id/refund           Refund to customer
```

#### Withdrawals
```
POST   /withdrawals                 Create withdrawal request
GET    /withdrawals/:id             Get withdrawal
PATCH  /withdrawals/:id/approve     Admin approve
PATCH  /withdrawals/:id/reject      Admin reject
```

#### Services
```
POST   /services                    Create service
PATCH  /services/:id                Update service
DELETE /services/:id                Delete service
GET    /services                    List all active services
GET    /services/:id                Get service details
```

---

## Deployment Recommendations

### Development
- Run against `staging` Supabase project
- Test edge functions locally: `supabase functions serve`
- Use development Stripe keys

### Production
- Separate `production` Supabase project
- Use production Stripe keys
- Enable Supabase audit logs
- Set up automated backups
- Configure monitoring & alerts
- Rate limiting on edge functions

---

## Performance Optimization

### Database Queries
```sql
-- Indexes already in schema, add more as needed
CREATE INDEX idx_escrow_status ON escrow_payments(status);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_withdrawals_status ON withdrawal_requests(status);
```

### Edge Function Optimization
- Use connection pooling
- Cache platform_settings (update frequency: rarely)
- Batch operations where possible
- Return minimal JSON

### Frontend Caching
- Cache service list locally
- Invalidate on updates
- Use Hive for offline support
- Implement request debouncing

---

## Security Considerations

### Edge Function Security
- ✅ Validate all inputs (type & length)
- ✅ Check user role/permissions
- ✅ Use SQL parameterized queries (Supabase SDK does this)
- ✅ Rate limit sensitive endpoints
- ✅ Log all financial transactions
- ✅ Use HTTPS only
- ✅ Implement request signing for critical operations

### Payment Security
- ✅ Never log card details
- ✅ Use Stripe for PCI compliance
- ✅ Verify webhook signatures
- ✅ Implement idempotency keys
- ✅ Audit payment failures

---

## Monitoring & Observability

### Supabase Built-In
- Real-time API logs
- Query performance metrics
- User growth analytics

### Third-Party (Optional)
- Sentry for error tracking
- DataDog for performance monitoring
- Logtail for log aggregation

---

## Roadmap

| Phase | Timeframe | Tasks |
|-------|-----------|-------|
| Phase 1 (Current) | Complete | Frontend MVP, database schema, auth |
| Phase 2 | 2-3 weeks | Edge functions, escrow logic, admin UI |
| Phase 3 | 3-4 weeks | Payment integration (Stripe), withdrawal workflow |
| Phase 4 | 2-3 weeks | Real-time features, file uploads, notifications |
| Phase 5 | Ongoing | Scaling, optimization, new features |

---

## Conclusion

The current implementation is **ready for beta testing**. The backend can evolve from direct Supabase access to a more sophisticated architecture as needed, using Supabase Edge Functions as an intermediate layer before full backend migration.

**Recommended next step**: Implement Supabase Edge Functions for critical workflows (order creation, escrow approval) while keeping simple read operations client-side.

