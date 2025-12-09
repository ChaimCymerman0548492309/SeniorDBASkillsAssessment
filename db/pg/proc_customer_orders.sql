CREATE OR REPLACE FUNCTION get_customer_orders(p_customer_id BIGINT)
RETURNS TABLE (
    order_id BIGINT,
    order_date DATE,
    total_amount NUMERIC(12,2),
    total_spent NUMERIC(12,2)
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM customers WHERE id = p_customer_id) THEN
        RAISE EXCEPTION 'customer % not found', p_customer_id;
    END IF;

    RETURN QUERY
    WITH tot AS (
        SELECT SUM(total_amount) AS t
        FROM orders
        WHERE customer_id = p_customer_id
    )
    SELECT o.id, o.order_date, o.total_amount, tot.t
    FROM orders o CROSS JOIN tot
    WHERE o.customer_id = p_customer_id
    ORDER BY o.order_date DESC, o.id DESC;
END;
$$ LANGUAGE plpgsql;



