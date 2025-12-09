-- מאיץ חיבור customer_id בדוחות
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);

-- מאיץ חישובי תאריכים (top3, growth, inactive)
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);

-- מאיץ GROUP BY על email
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);




DROP INDEX IF EXISTS idx_orders_customer_id;
DROP INDEX IF EXISTS idx_orders_order_date;
DROP INDEX IF EXISTS idx_customers_email;