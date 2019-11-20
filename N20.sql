WITH order_info AS ( 
SELECT *,
	c.customer_id as c_customer_id,
	o.customer_id as o_customer_id, 
	od.unit_price*od.quantity*(1-od.discount) as total
FROM orders as o 
	JOIN order_details as od ON o.order_id = od.order_id
	JOIN products as p ON od.product_id = p.product_id
	JOIN customers as c ON o.customer_id = c.customer_id
),
customer_totals as ( 
SELECT 
	c_customer_id,
	country,
	sum(total) as total
FROM order_info
GROUP BY c_customer_id, country 
),
previous amount as (SELECT *,
	Lead(total, 1) OVER(PARTITION BY country ORDER BY total desc) as previous,
    total - previous as difference
FROM customer_totals
),
SELECT *, 