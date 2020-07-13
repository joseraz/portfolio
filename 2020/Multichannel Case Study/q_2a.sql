/* This is for Part 1*/

/* Getting total contacts per months*/
SELECT month, contact_type, SUM(contact_count)
FROM (
	SELECT cust_id,
		EXTRACT(YEAR FROM contact_date) AS year,
		EXTRACT(MONTH FROM contact_date) AS month,
		contact_type,
		COUNT(contact_type) AS contact_count
	FROM contacts
	GROUP BY cust_id,
			EXTRACT(YEAR FROM contact_date),
			EXTRACT(MONTH FROM contact_date),
			contact_type) as t1
GROUP BY month, contact_type
/* Getting number of contacts per year month with response*/
SELECT *
FROM
(SELECT cust_id,
	EXTRACT(YEAR FROM contact_date) AS year,
	EXTRACT(MONTH FROM contact_date) AS month,
	contact_type,
	COUNT(contact_type) AS contact_count
FROM contacts
GROUP BY cust_id, EXTRACT(YEAR FROM contact_date), EXTRACT(MONTH FROM contact_date), contact_type) AS t1
LEFT JOIN (
	SELECT cust_id,
	EXTRACT(YEAR FROM order_date) AS year,
	EXTRACT(MONTH FROM order_date) AS month,
	COUNT(order_num) AS orders_count
	FROM orders
	GROUP BY cust_id, EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) AS t2
USING(cust_id, year, month)
WHERE orders_count IS NOT NULL

/* This is for Part 2*/
/* There are a lot of purchases as gifts*/
SELECT year, measure, SUM(purchase)
FROM customers
WHERE purchase > 0
GROUP BY year, measure
LIMIT 20
/* Percentage of gifts and contacts counts to check correlation*/
SELECT cust_id,
		year,
		month,
		total_amount::numeric,
		gift_amount::numeric,
		contact_count,
		ROUND(gift_amount/total_amount*100) AS perc_gift
FROM (
SELECT cust_id,
	EXTRACT(YEAR FROM order_date) AS year,
	EXTRACT(MONTH FROM order_date) AS month,
	SUM(amount) AS total_amount
FROM lines
GROUP BY cust_id, EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) AS t1
LEFT JOIN (
	SELECT cust_id,
	EXTRACT(YEAR FROM order_date) AS year,
	EXTRACT(MONTH FROM order_date) AS month,
	SUM(amount) AS gift_amount
	FROM lines
	WHERE gift = 'Y'
	GROUP BY cust_id, EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) AS t2
USING (cust_id, year, month)
LEFT JOIN (
	SELECT cust_id,
		EXTRACT(YEAR FROM contact_date) AS year,
		EXTRACT(MONTH FROM contact_date) AS month,
		COUNT(contact_type) AS contact_count
	FROM contacts
	GROUP BY cust_id,
		EXTRACT(YEAR FROM contact_date),
		EXTRACT(MONTH FROM contact_date)) as t3
USING(cust_id, year, month)
