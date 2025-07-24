-- Bill Sloth Business Database Initialization
-- Creates all necessary tables for VRBO, partnerships, and analytics

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- VRBO Properties and Bookings
CREATE TABLE IF NOT EXISTS properties (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    property_id TEXT UNIQUE NOT NULL,
    property_name TEXT NOT NULL,
    address TEXT,
    city TEXT,
    state TEXT,
    country TEXT DEFAULT 'US',
    property_type TEXT,
    bedrooms INTEGER,
    bathrooms INTEGER,
    max_guests INTEGER,
    base_price DECIMAL(10,2),
    cleaning_fee DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id TEXT UNIQUE NOT NULL,
    property_id TEXT NOT NULL,
    guest_name TEXT NOT NULL,
    guest_email TEXT,
    guest_phone TEXT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    num_guests INTEGER,
    total_amount DECIMAL(10,2),
    commission_amount DECIMAL(10,2),
    booking_status TEXT DEFAULT 'confirmed',
    booking_source TEXT DEFAULT 'vrbo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Guest Communications
CREATE TABLE IF NOT EXISTS guest_communications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id TEXT NOT NULL,
    communication_type TEXT NOT NULL,
    message_subject TEXT,
    message_body TEXT,
    sent_at TIMESTAMP,
    delivery_status TEXT DEFAULT 'pending',
    guest_response TEXT,
    response_received_at TIMESTAMP,
    template_used TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Business Partnerships
CREATE TABLE IF NOT EXISTS partnerships (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    partner_name TEXT NOT NULL,
    partnership_type TEXT NOT NULL,
    contact_name TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    partnership_status TEXT DEFAULT 'active',
    commission_rate DECIMAL(5,4),
    contract_start_date DATE,
    contract_end_date DATE,
    total_revenue DECIMAL(10,2) DEFAULT 0,
    total_commission DECIMAL(10,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS partnership_deals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    deal_id TEXT UNIQUE NOT NULL,
    partnership_id INTEGER NOT NULL,
    deal_name TEXT NOT NULL,
    deal_description TEXT,
    deal_value DECIMAL(10,2),
    commission_amount DECIMAL(10,2),
    deal_status TEXT DEFAULT 'pending',
    deal_stage TEXT DEFAULT 'prospecting',
    expected_close_date DATE,
    actual_close_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partnership_id) REFERENCES partnerships(id)
);

-- Campaign Tracking
CREATE TABLE IF NOT EXISTS campaigns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    campaign_id TEXT UNIQUE NOT NULL,
    partnership_id INTEGER,
    campaign_name TEXT NOT NULL,
    campaign_type TEXT,
    campaign_description TEXT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2),
    actual_spend DECIMAL(10,2),
    revenue_generated DECIMAL(10,2),
    commission_earned DECIMAL(10,2),
    performance_metrics TEXT, -- JSON
    campaign_status TEXT DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partnership_id) REFERENCES partnerships(id)
);

-- Revenue Tracking
CREATE TABLE IF NOT EXISTS revenue_records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_id TEXT UNIQUE NOT NULL,
    revenue_source TEXT NOT NULL, -- 'vrbo', 'partnership', 'other'
    amount DECIMAL(10,2) NOT NULL,
    transaction_date DATE NOT NULL,
    description TEXT,
    property_id TEXT,
    partnership_id INTEGER,
    campaign_id TEXT,
    payment_method TEXT,
    tax_category TEXT,
    is_recurring BOOLEAN DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (partnership_id) REFERENCES partnerships(id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- Expenses Tracking
CREATE TABLE IF NOT EXISTS expenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    expense_id TEXT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    expense_date DATE NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    vendor TEXT,
    property_id TEXT,
    receipt_path TEXT,
    is_tax_deductible BOOLEAN DEFAULT 0,
    tax_category TEXT,
    payment_method TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Business Goals and KPIs
CREATE TABLE IF NOT EXISTS business_goals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    goal_id TEXT UNIQUE NOT NULL,
    goal_name TEXT NOT NULL,
    goal_type TEXT NOT NULL, -- 'revenue', 'bookings', 'partnerships'
    target_value DECIMAL(10,2),
    current_value DECIMAL(10,2) DEFAULT 0,
    target_date DATE,
    goal_status TEXT DEFAULT 'active',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Analytics and Performance Metrics
CREATE TABLE IF NOT EXISTS performance_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    metric_date DATE NOT NULL,
    metric_type TEXT NOT NULL,
    metric_name TEXT NOT NULL,
    metric_value DECIMAL(10,4),
    additional_data TEXT, -- JSON
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Property Performance (Daily Snapshots)
CREATE TABLE IF NOT EXISTS property_performance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    property_id TEXT NOT NULL,
    performance_date DATE NOT NULL,
    occupancy_rate DECIMAL(5,4),
    average_daily_rate DECIMAL(10,2),
    revenue_per_available_night DECIMAL(10,2),
    total_revenue DECIMAL(10,2),
    total_bookings INTEGER DEFAULT 0,
    guest_rating DECIMAL(3,2),
    review_count INTEGER DEFAULT 0,
    cancellation_rate DECIMAL(5,4),
    lead_time_days INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Email Automation and Templates
CREATE TABLE IF NOT EXISTS email_templates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    template_id TEXT UNIQUE NOT NULL,
    template_name TEXT NOT NULL,
    template_type TEXT NOT NULL, -- 'guest', 'partnership', 'business'
    subject_line TEXT,
    email_body TEXT,
    variables TEXT, -- JSON
    usage_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS email_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recipient_email TEXT NOT NULL,
    recipient_name TEXT,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    template_id TEXT,
    priority INTEGER DEFAULT 5,
    scheduled_time TIMESTAMP,
    sent_time TIMESTAMP,
    delivery_status TEXT DEFAULT 'pending',
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (template_id) REFERENCES email_templates(template_id)
);

-- System Configuration and Settings
CREATE TABLE IF NOT EXISTS system_config (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    config_key TEXT UNIQUE NOT NULL,
    config_value TEXT,
    config_type TEXT DEFAULT 'string',
    description TEXT,
    is_sensitive BOOLEAN DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Log
CREATE TABLE IF NOT EXISTS audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    action TEXT NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    old_values TEXT, -- JSON
    new_values TEXT, -- JSON
    user_id TEXT,
    ip_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_check_in_date ON bookings(check_in_date);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(booking_status);

CREATE INDEX IF NOT EXISTS idx_revenue_source ON revenue_records(revenue_source);
CREATE INDEX IF NOT EXISTS idx_revenue_date ON revenue_records(transaction_date);
CREATE INDEX IF NOT EXISTS idx_revenue_property ON revenue_records(property_id);

CREATE INDEX IF NOT EXISTS idx_partnership_deals_status ON partnership_deals(deal_status);
CREATE INDEX IF NOT EXISTS idx_partnership_deals_stage ON partnership_deals(deal_stage);

CREATE INDEX IF NOT EXISTS idx_performance_date ON performance_metrics(metric_date);
CREATE INDEX IF NOT EXISTS idx_performance_type ON performance_metrics(metric_type);

CREATE INDEX IF NOT EXISTS idx_property_performance_date ON property_performance(performance_date);
CREATE INDEX IF NOT EXISTS idx_property_performance_property ON property_performance(property_id);

CREATE INDEX IF NOT EXISTS idx_email_queue_status ON email_queue(delivery_status);
CREATE INDEX IF NOT EXISTS idx_email_queue_scheduled ON email_queue(scheduled_time);

-- Insert default configuration values
INSERT OR IGNORE INTO system_config (config_key, config_value, description) VALUES
('business_name', 'Bill Sloth Enterprises', 'Primary business name'),
('default_timezone', 'America/New_York', 'Default timezone for the business'),
('vrbo_commission_rate', '0.08', 'Default VRBO commission rate'),
('email_from_address', 'noreply@billsloth.com', 'Default email from address'),
('backup_retention_days', '365', 'Number of days to retain backup data'),
('performance_tracking_enabled', '1', 'Enable performance metrics tracking'),
('email_automation_enabled', '1', 'Enable automated email communications'),
('analytics_retention_days', '1095', 'Number of days to retain analytics data');

-- Insert sample email templates
INSERT OR IGNORE INTO email_templates (template_id, template_name, template_type, subject_line, email_body, variables) VALUES
('welcome_guest', 'Welcome Guest Message', 'guest', 
'Welcome to {property_name} - Your Key Details Inside! 🏡',
'Hi {guest_name},\n\nWelcome to {property_name}! We''re thrilled you''ve chosen our place for your adventure.\n\n🔑 CHECK-IN DETAILS:\n• Check-in: {check_in_date} after {check_in_time}\n• Address: {property_address}\n• Access Code: {access_code}\n• WiFi: {wifi_name} / Password: {wifi_password}\n\nLooking forward to hosting you!\n{host_name}',
'["guest_name", "property_name", "check_in_date", "check_in_time", "property_address", "access_code", "wifi_name", "wifi_password", "host_name"]'),

('partnership_outreach', 'Initial Partnership Outreach', 'partnership',
'Partnership Opportunity - {company_name} x {your_brand}',
'Hi {contact_name},\n\nI hope this email finds you well! I''m {your_name}, and I work with {your_brand} in the {your_niche} space.\n\n🎯 WHY I''M REACHING OUT:\nI''ve been following {company_name} and am impressed by {specific_compliment}. I believe there''s a natural synergy between our audiences.\n\nI''d love to explore how we might work together. Are you available for a brief call this week to discuss?\n\nBest regards,\n{your_name}',
'["contact_name", "company_name", "your_brand", "your_name", "your_niche", "specific_compliment"]'),

('monthly_report', 'Monthly Business Report', 'business',
'{month} {year} Business Report - {business_name}',
'Hi {recipient_name},\n\nHere''s your monthly business summary for {month} {year}:\n\n📊 FINANCIAL HIGHLIGHTS:\n• Total Revenue: ${total_revenue}\n• VRBO Income: ${vrbo_income}\n• Partnership Income: ${partnership_income}\n\n🏠 VRBO PERFORMANCE:\n• Total Bookings: {total_bookings}\n• Occupancy Rate: {occupancy_rate}%\n• Average Daily Rate: ${average_daily_rate}\n\nDetailed analytics dashboard: {dashboard_link}\n\n{business_name}\nGenerated automatically by Bill Sloth Business Intelligence',
'["recipient_name", "month", "year", "business_name", "total_revenue", "vrbo_income", "partnership_income", "total_bookings", "occupancy_rate", "average_daily_rate", "dashboard_link"]');

-- Create views for common queries
CREATE VIEW IF NOT EXISTS property_revenue_summary AS
SELECT 
    p.property_id,
    p.property_name,
    COUNT(b.id) as total_bookings,
    SUM(b.total_amount) as total_revenue,
    AVG(b.total_amount) as average_booking_value,
    MAX(b.check_in_date) as last_booking_date
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
WHERE b.booking_status = 'confirmed'
GROUP BY p.property_id, p.property_name;

CREATE VIEW IF NOT EXISTS partnership_performance_summary AS
SELECT 
    p.partner_name,
    p.partnership_type,
    COUNT(pd.id) as total_deals,
    SUM(pd.deal_value) as total_deal_value,
    SUM(pd.commission_amount) as total_commission,
    AVG(pd.commission_amount) as average_commission,
    MAX(pd.actual_close_date) as last_deal_date
FROM partnerships p
LEFT JOIN partnership_deals pd ON p.id = pd.partnership_id
WHERE pd.deal_status = 'won'
GROUP BY p.id, p.partner_name, p.partnership_type;

CREATE VIEW IF NOT EXISTS monthly_revenue_summary AS
SELECT 
    strftime('%Y-%m', transaction_date) as month,
    revenue_source,
    SUM(amount) as total_revenue,
    COUNT(*) as transaction_count,
    AVG(amount) as average_transaction
FROM revenue_records
GROUP BY strftime('%Y-%m', transaction_date), revenue_source
ORDER BY month DESC, revenue_source;

-- Commit the transaction
COMMIT;

-- Log successful initialization
INSERT INTO audit_log (table_name, record_id, action, new_values, user_id) 
VALUES ('system_config', 'init', 'SYSTEM_INIT', '{"message": "Database initialized successfully"}', 'system');