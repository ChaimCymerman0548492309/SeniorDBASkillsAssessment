WITH recent AS (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM orders
    WHERE order_date >= current_date - INTERVAL '90 days'
    GROUP BY customer_id
)
SELECT c.id, c.name, r.total_spent
FROM recent r
JOIN customers c ON c.id = r.customer_id
ORDER BY r.total_spent DESC
LIMIT 3;
