/* Getting the Total Order and average amount per year*/
SELECT *
FROM (
	SELECT EXTRACT(YEAR FROM order_date) AS year,
	COUNT(order_num) AS total_orders
	FROM orders
	WHERE order_method = 'I'
	GROUP BY year) as t1
LEFT JOIN (
	SELECT EXTRACT(YEAR FROM lines.order_date) AS year,
	ROUND(AVG(amount::numeric), 2) AS avg_amount
	FROM lines
	LEFT JOIN orders
	USING(order_num)
	WHERE order_method = 'I'
	GROUP BY year) as t2
USING(year)
