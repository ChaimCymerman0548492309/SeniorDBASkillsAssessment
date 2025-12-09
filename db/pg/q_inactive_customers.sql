SELECT c.id, c.name, c.email
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.id
    AND o.order_date >= current_date - INTERVAL '6 months'
WHERE o.id IS NULL;
