CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype,
   ....
);
/* Query for average amount spent*/
SELECT scf_code, ROUND(AVG(purchase),2) AS average_spend
FROM customers
WHERE scf_code IS NOT NULL
AND purchase > 0
GROUP BY scf_code
ORDER BY average_spend DESC
LIMIT 5


/* Basic query*/
SELECT channel, year, SUM(purchase) AS sum_purchases
FROM customers
WHERE season != 'P'
GROUP BY channel, year

/* Changing the date column*/
#To change the date column
ALTER TABLE contacts
ALTER COlUMN contact_date TYPE date USING to_date(contact_date::text, 'YYYYMMDD');
