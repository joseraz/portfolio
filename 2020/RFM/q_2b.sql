/* Creating RFM table*/
  CREATE TABLE rfm AS(
  SELECT cust_id,
         NTILE(5) OVER (ORDER BY last_order_date) AS recency,
         NTILE(5) OVER (ORDER BY count_order) AS frequency,
         NTILE(5) OVER (ORDER BY avg_amount) AS monetary
  FROM (
  	SELECT cust_id,
  		   MAX(order_date) AS last_order_date,
  		   COUNT(*) AS count_order,
  		   AVG(amount::numeric) AS avg_amount
  	FROM lines
  	GROUP BY cust_id) AS table_1)

/* For joining responses and contacts with rfm*/
SELECT rfm_segment,
	SUM(contacted) AS total_contacts,
	SUM(response) AS total_response,
	ROUND(SUM(response)/SUM(contacted),2) AS response_rate
FROM (
	SELECT cust_id, COUNT(*) AS contacted
	FROM contacts
	GROUP BY cust_id) AS t1
LEFT JOIN (
	SELECT cust_id, COUNT(*) AS response
	FROM orders
	WHERE order_date >= '2005-01-01'
	GROUP BY cust_id) AS t2
USING(cust_id)
LEFT JOIN (
	SELECT cust_id, CONCAT(recency, frequency, monetary) AS rfm_segment
	FROM rfm) AS t3
USING(cust_id)
GROUP BY rfm_segment

/* Calculating response rate and ROI*/
SELECT *,
		total_response *30 AS profit,
		total_contacts *1 AS cost,
		ROUND((total_response *30 - total_contacts*1)/total_contacts*1, 2) AS roi
FROM rfm_rr
WHERE response_rate IS NOT NULL
ORDER BY response_rate DESC
