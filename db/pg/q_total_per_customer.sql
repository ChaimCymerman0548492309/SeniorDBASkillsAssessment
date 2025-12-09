SELECT c.id, c.name, c.email,
       COALESCE(SUM(o.total_amount),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id
ORDER BY total_spent DESC;
