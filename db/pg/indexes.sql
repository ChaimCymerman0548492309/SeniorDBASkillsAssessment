-- Task 2: Query Optimization Indexes
-- ==================================

-- 1. Index for foreign key joins between orders and customers
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
-- Justification: Speeds up JOIN operations in customer aggregation queries

-- 2. Index for date-based filtering and sorting
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);
-- Justification: Optimizes time-range queries for reporting and analysis

-- 3. Index for email lookups and uniqueness enforcement
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
-- Justification: Improves customer lookup performance and UNIQUE constraint

-- Drop statements for testing before/after performance
DROP INDEX IF EXISTS idx_orders_customer_id;
DROP INDEX IF EXISTS idx_orders_order_date;
DROP INDEX IF EXISTS idx_customers_email;