-- =============================================
-- NCONNECT SERVICE MARKETPLACE DATABASE SCHEMA
-- =============================================

-- Users Table (Already exists, adding fields)
ALTER TABLE users ADD COLUMN IF NOT EXISTS account_type TEXT; -- 'professional', 'customer', or 'both'
ALTER TABLE users ADD COLUMN IF NOT EXISTS wallet_balance DECIMAL(15, 2) DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_suspended BOOLEAN DEFAULT FALSE;

-- Categories Table (Admin managed)
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    icon_url TEXT,
    created_by UUID REFERENCES users(uid) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Services Table
CREATE TABLE IF NOT EXISTS services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    title TEXT NOT NULL,
    description TEXT,
    delivery_time_days INT NOT NULL,
    max_revisions INT DEFAULT 2,
    status TEXT DEFAULT 'active', -- 'active', 'paused', 'archived'
    rating_avg DECIMAL(3, 2) DEFAULT 0,
    total_orders INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Service Packages (Basic/Standard/Premium)
CREATE TABLE IF NOT EXISTS service_packages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_id UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    package_type TEXT NOT NULL, -- 'Basic', 'Standard', 'Premium'
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    features JSONB, -- Array of features for this package
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Service Add-ons
CREATE TABLE IF NOT EXISTS service_addons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_id UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES services(id) ON DELETE RESTRICT,
    service_package_id UUID NOT NULL REFERENCES service_packages(id) ON DELETE RESTRICT,
    addon_ids UUID[] DEFAULT ARRAY[]::UUID[],
    status TEXT DEFAULT 'pending', -- 'pending', 'accepted', 'in_progress', 'submitted', 'confirmed', 'completed', 'cancelled'
    base_price DECIMAL(10, 2) NOT NULL,
    addon_total DECIMAL(10, 2) DEFAULT 0,
    platform_fee DECIMAL(10, 2),
    total_amount DECIMAL(10, 2) NOT NULL,
    delivery_deadline TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Escrow Payments Table
CREATE TABLE IF NOT EXISTS escrow_payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    status TEXT DEFAULT 'held', -- 'held', 'released', 'refunded'
    released_by UUID REFERENCES users(uid) ON DELETE SET NULL,
    released_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    transaction_type TEXT NOT NULL, -- 'payment', 'earnings', 'withdrawal', 'refund'
    amount DECIMAL(10, 2) NOT NULL,
    description TEXT,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    status TEXT DEFAULT 'completed', -- 'pending', 'completed', 'failed'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Withdrawal Requests Table
CREATE TABLE IF NOT EXISTS withdrawal_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    professional_id UUID NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    status TEXT DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'processed'
    approved_by UUID REFERENCES users(uid) ON DELETE SET NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Task Submissions Table
CREATE TABLE IF NOT EXISTS task_submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    submitted_by UUID NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    description TEXT,
    files_urls TEXT[], -- Array of file URLs
    submission_number INT DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reviews Table
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    reviewer_id UUID NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    reviewed_user_id UUID NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Platform Settings Table
CREATE TABLE IF NOT EXISTS platform_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    setting_key TEXT UNIQUE NOT NULL,
    setting_value TEXT NOT NULL,
    updated_by UUID REFERENCES users(uid),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Audit Trail Table
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_id UUID NOT NULL REFERENCES users(uid) ON DELETE SET NULL,
    action TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id UUID,
    changes JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================

-- Enable RLS
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE escrow_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE withdrawal_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Services: Professionals can CRUD their own, customers can view active
CREATE POLICY "Services: Professionals can manage their own" ON services 
    FOR ALL USING (auth.uid()::text = provider_id::text);

CREATE POLICY "Services: Active services visible to all" ON services 
    FOR SELECT USING (status = 'active');

-- Orders: Participants can view, customer can insert
CREATE POLICY "Orders: Users can view their orders" ON orders 
    FOR SELECT USING (auth.uid()::text = customer_id::text OR auth.uid()::text IN (SELECT provider_id::text FROM services WHERE id = service_id));

CREATE POLICY "Orders: Customers can create orders" ON orders 
    FOR INSERT WITH CHECK (auth.uid()::text = customer_id::text);

CREATE POLICY "Orders: Providers can update their orders" ON orders 
    FOR UPDATE USING (auth.uid()::text IN (SELECT provider_id::text FROM services WHERE id = service_id));

-- Escrow: Escrow table is admin-controlled via backend
CREATE POLICY "Escrow: Admin and involved parties can view" ON escrow_payments 
    FOR SELECT USING (
        auth.uid()::text IN (SELECT customer_id::text FROM orders WHERE id = order_id)
        OR auth.uid()::text IN (SELECT provider_id::text FROM services WHERE id IN (SELECT service_id FROM orders WHERE id = order_id))
        OR EXISTS(SELECT 1 FROM users WHERE uid = auth.uid() AND primary_role = 'Admin')
    );

-- Transactions: Users can view their own
CREATE POLICY "Transactions: Users can view their own" ON transactions 
    FOR SELECT USING (auth.uid()::text = user_id::text);

-- Withdrawal: Professionals can view their own
CREATE POLICY "Withdrawals: Professionals can view their own" ON withdrawal_requests 
    FOR SELECT USING (auth.uid()::text = professional_id::text);

CREATE POLICY "Withdrawals: Professionals can create requests" ON withdrawal_requests 
    FOR INSERT WITH CHECK (auth.uid()::text = professional_id::text);

-- Reviews: Anyone can view, users can create for their completed orders
CREATE POLICY "Reviews: Anyone can view" ON reviews FOR SELECT USING (true);

CREATE POLICY "Reviews: Users can create reviews for their orders" ON reviews 
    FOR INSERT WITH CHECK (auth.uid()::text = reviewer_id::text);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

CREATE INDEX idx_services_provider_id ON services(provider_id);
CREATE INDEX idx_services_category_id ON services(category_id);
CREATE INDEX idx_services_status ON services(status);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_service_id ON orders(service_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_escrow_order_id ON escrow_payments(order_id);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_withdrawal_professional_id ON withdrawal_requests(professional_id);
CREATE INDEX idx_withdrawal_status ON withdrawal_requests(status);
CREATE INDEX idx_reviews_service_id ON reviews(service_id);

-- =============================================
-- INITIALIZE PLATFORM SETTINGS
-- =============================================

INSERT INTO platform_settings (setting_key, setting_value) 
VALUES ('platform_fee_percentage', '15') 
ON CONFLICT (setting_key) DO UPDATE SET setting_value = '15';
