WITH months AS (
    SELECT date_trunc('month', current_date) - (i||' months')::interval AS month
    FROM generate_series(0,5) i
),
rev AS (
    SELECT date_trunc('month', order_date) AS month, SUM(total_amount) AS revenue
    FROM orders
    WHERE order_date >= current_date - INTERVAL '6 months'
    GROUP BY 1
)
SELECT m.month,
       COALESCE(r.revenue,0) AS revenue,
       (COALESCE(r.revenue,0) - LAG(COALESCE(r.revenue,0)) OVER (ORDER BY m.month))
       / NULLIF(LAG(COALESCE(r.revenue,0)) OVER (ORDER BY m.month),0) AS growth_pct
FROM months m
LEFT JOIN rev r USING (month)
ORDER BY m.month;
