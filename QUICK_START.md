# nConnect - Quick Start & Testing Guide

## Prerequisites
- Flutter SDK installed
- Supabase account with project created
- Chrome browser for web testing

## Project Setup

### 1. Clone & Install Dependencies
```bash
cd c:\xampp\htdocs\nconnect
flutter pub get
dart pub run build_runner build --delete-conflicting-outputs
```

### 2. Supabase Configuration
- **URL**: https://kkvtntjktvfarcidgggx.supabase.co
- **Anon Key**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
- Location: `lib/main.dart` (lines 26-29)

### 3. Initialize Database
1. Go to Supabase Dashboard → SQL Editor
2. Create new query
3. Copy entire contents of `MARKETPLACE_SCHEMA.sql`
4. Execute (creates all 13 tables with RLS policies)

### 4. Run Application
```bash
flutter run -d chrome
```

---

## Testing Scenarios

### Scenario 1: Registration & Role Selection

**Test Case 1.1: Customer Registration**
1. Launch app → Click "Get Started"
2. Click "Register" tab
3. Fill form:
   - Full Name: "John Doe"
   - Email: "john@test.com"
   - Phone: "555-1234"
   - Password: "test123"
   - Role: "Customer" (select from dropdown)
4. Click "Register"
5. ✅ Expected: Success message + auto-switch to Login tab
6. Login with john@test.com / test123
7. ✅ Expected: Redirected to `/customer-dashboard`

**Test Case 1.2: Professional Registration**
1. Similar flow but select "Professional" role
2. ✅ Expected: Login → Redirected to `/professional-dashboard`

**Test Case 1.3: Dual Role Creation**
1. Register Bob as Customer
2. In role-selection screen, switch to Professional
3. ✅ Expected: Professional dashboard loads without re-login

---

### Scenario 2: Service Browsing (Customer)

**Setup**: Create test professional with services first
1. Register Alice as Professional
2. Add sample services to database manually:
   ```sql
   INSERT INTO categories (name, description) VALUES ('Web Design', 'Website creation');
   INSERT INTO services (provider_id, category_id, title, description, delivery_time_days, max_revisions, status)
   VALUES ('alice_uid', 'category_uuid', 'Website Design', 'Professional website creation', 5, 2, 'active');
   ```

**Test Case 2.1: Browse Services**
1. Login as Bob (Customer)
2. View customer dashboard
3. ✅ Expected: Service cards display (if any exist)
4. ✅ Expected: Alice's services visible, BUT Bob's own services hidden (if he's also professional)

**Test Case 2.2: Filter by Category**
1. Click category filter chip
2. ✅ Expected: Services list updates dynamically

**Test Case 2.3: View Service Details**
1. Click on a service card
2. ✅ Expected: Navigate to service details screen
3. ✅ Expected: See: Title, description, rating, delivery time, revisions
4. ✅ Expected: Package selection (if packages exist)
5. ✅ Expected: Add-ons selection (if add-ons exist)
6. ✅ Expected: Price calculator showing total

---

### Scenario 3: Order Placement & Escrow

**Setup**: Alice has service with 3 packages
```sql
INSERT INTO service_packages (service_id, package_type, price, description)
VALUES 
  ('service_uuid', 'Basic', 50.00, 'Basic website'),
  ('service_uuid', 'Standard', 100.00, 'Standard + Features'),
  ('service_uuid', 'Premium', 200.00, 'Premium + Support');
```

**Test Case 3.1: Place Order**
1. Login as Bob (Customer)
2. Navigate to Alice's service
3. Select "Standard" package ($100)
4. Add-ons: None for now
5. Click "Place Order"
6. ✅ Expected: Success message
7. ✅ Expected: Order created in database
8. ✅ Expected: Escrow payment with status='held'
9. ✅ Expected: Transaction logged
10. ✅ Expected: Calculate: base=$100, fee=$15 (15%), total=$115

**Verify in Supabase**:
```sql
SELECT * FROM orders WHERE customer_id = 'bob_uid' ORDER BY created_at DESC LIMIT 1;
SELECT * FROM escrow_payments WHERE order_id = (above_order_id);
SELECT * FROM transactions WHERE user_id = 'bob_uid' ORDER BY created_at DESC LIMIT 1;
```

---

### Scenario 4: Role Switching

**Setup**: Charlie is both Professional and Customer

**Test Case 4.1: Switch to Professional**
1. Login as Charlie
2. If logged in as Customer, see "↔️" switch role button
3. Click switch role button
4. ✅ Expected: Role-selection screen
5. Select "Professional"
6. ✅ Expected: Database updated
7. ✅ Expected: Navigate to professional-dashboard
8. ✅ Expected: NO re-login required

**Test Case 4.2: Switch Back to Customer**
1. In professional-dashboard, click "↔️" button
2. Select "Customer"
3. ✅ Expected: Navigate to customer-dashboard

---

### Scenario 5: Authentication & Security

**Test Case 5.1: Invalid Credentials**
1. Try login with wrong password
2. ✅ Expected: Error message "Invalid login credentials"

**Test Case 5.2: Logout**
1. Click logout button (anywhere)
2. ✅ Expected: Redirect to login screen
3. ✅ Expected: Previous screens not accessible via back button

**Test Case 5.3: Session Persistence**
1. Close and reopen browser
2. ✅ Expected: Return to appropriate dashboard (not login)

---

### Scenario 6: Hive Local Caching

**Test Case 6.1: Offline Browsing**
1. Browse services while online (caches in Hive)
2. Disconnect from internet
3. ✅ Expected: Can still view cached services
4. Click on service details
5. ✅ Expected: Shows cached data

**Test Case 6.2: Cache Sync**
1. Go back online
2. Services should update from latest Supabase data

---

## Admin Features (Future Implementation)

### Mock Admin Testing
1. Manually update database:
   ```sql
   UPDATE users SET primary_role = 'Admin' WHERE uid = 'test_admin_uid';
   ```
2. Login as admin
3. ✅ Expected: Redirect to `/admin` dashboard
4. Feature not yet implemented but routing works

---

## Database Verification Queries

### Check User Roles
```sql
SELECT uid, full_name, email, primary_role FROM users ORDER BY created_at DESC;
```

### Check Active Services
```sql
SELECT s.id, s.title, u.full_name as provider, c.name as category, s.status
FROM services s
JOIN users u ON s.provider_id = u.uid
JOIN categories c ON s.category_id = c.id
WHERE s.status = 'active';
```

### Check Orders & Escrow
```sql
SELECT 
  o.id,
  u1.full_name as customer,
  u2.full_name as professional,
  o.total_amount,
  ep.status as escrow_status,
  o.status as order_status
FROM orders o
JOIN users u1 ON o.customer_id = u1.uid
JOIN users u2 ON o.professional_id = u2.uid
LEFT JOIN escrow_payments ep ON o.id = ep.order_id
ORDER BY o.created_at DESC;
```

### Check Platform Fee Configuration
```sql
SELECT * FROM platform_settings LIMIT 1;
```

---

## Common Issues & Fixes

### Issue: "services not found" error
**Cause**: Database tables not created
**Fix**: Run MARKETPLACE_SCHEMA.sql in Supabase

### Issue: Blank services list on customer dashboard
**Cause**: No active services or no categories
**Fix**: 
```sql
-- Add test category
INSERT INTO categories (name, description) VALUES ('Test', 'Test Category');

-- Add test service
INSERT INTO services (provider_id, category_id, title, description, delivery_time_days, max_revisions)
VALUES ('professional_uid', 'category_uuid', 'Test Service', 'Test', 5, 2);
```

### Issue: Login redirects to wrong dashboard
**Cause**: `primary_role` field not set correctly
**Fix**:
```sql
UPDATE users SET primary_role = 'Customer' WHERE uid = 'user_uid';
```

### Issue: Hive adapter not generated
**Cause**: build_runner didn't run properly
**Fix**:
```bash
flutter clean
flutter pub get
dart pub run build_runner build --delete-conflicting-outputs
```

---

## Performance Tuning

### Database Indexes
Already created in schema:
- `idx_services_provider` - for professional's services
- `idx_orders_customer` - for customer's orders
- `idx_escrow_orders` - for escrow lookups
- `idx_transactions_user` - for transaction history

### Pagination (To Implement)
Currently fetching all services. Recommend:
```dart
// Add limit and offset
.select('...', { from: 0, to: 50 })
// Implement pagination UI
```

### Caching Strategy
- Cache services locally after first fetch
- Implement background sync for updates
- Consider Riverpod or Provider for state management

---

## Next Steps

1. ✅ **Database Schema**: Complete
2. ✅ **Authentication**: Complete
3. ✅ **Customer Dashboard**: Complete
4. ✅ **Service Details & Ordering**: Complete
5. ⏳ **Professional Dashboard**: Needs service management UI
6. ⏳ **Order Management**: Accept/reject workflows
7. ⏳ **Task Submission**: File upload for deliverables
8. ⏳ **Admin Dashboard**: Approval workflows
9. ⏳ **Payment Integration**: Stripe/PayPal
10. ⏳ **Reviews & Ratings**: Implemented in schema, UI pending

---

## Support & Resources

- **Supabase Docs**: https://supabase.com/docs
- **Flutter Docs**: https://flutter.dev/docs
- **Hive Docs**: https://docs.hivedb.dev
- **Project Source**: `lib/` directory
- **Database Schema**: `MARKETPLACE_SCHEMA.sql`
- **Full Guide**: `IMPLEMENTATION_GUIDE.md`

