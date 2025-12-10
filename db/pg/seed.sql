BEGIN;

-- Clear existing data
TRUNCATE orders, customers RESTART IDENTITY;

-- Set fixed seed for deterministic results
SELECT setseed(0.42);

DO $$
DECLARE
    seed_scale text := COALESCE(current_setting('app.seed_scale', TRUE), 'small');
    cust_count int;
    order_count int;
BEGIN
    -- Set scale parameters
    IF seed_scale = 'large' THEN
        cust_count := 5000;
        order_count := 300000;
    ELSE
        cust_count := 300;
        order_count := 5000;
    END IF;

    -- Insert customers
    INSERT INTO customers(name, email, created_at)
    SELECT
        'Customer ' || i,
        'customer' || i || '@example.com',
        now() - (random() * 365)::int * INTERVAL '1 day'
    FROM generate_series(1, cust_count) i;

    -- Insert orders with realistic distribution (15% heavy buyers)
    INSERT INTO orders(customer_id, order_date, total_amount)
    SELECT
        CASE 
            WHEN random() < 0.15 THEN floor(random() * 50)::int + 1
            ELSE floor(random() * cust_count)::int + 1
        END,
        (now() - (random() * 180)::int * INTERVAL '1 day')::date,
        round((random() * 300 + 20)::numeric, 2)
    FROM generate_series(1, order_count);

END $$;

COMMIT;