-- SQL Retali Sales Analysis --

CREATE DATABASE project_1;

CREATE TABLE retali_sales 
(	transactions_id	INT PRIMARY KEY,
	sale_date DATE NULL,
    sale_time TIME,	
    customer_id INT,
    gender VARCHAR(7),
	age INT NULL,
	category VARCHAR(20),
    quantiy	INT NULL,
    price_per_unit FLOAT NULL,	
    cogs FLOAT NULL,
    total_sale FLOAT NULL
);


SELECT * FROM retali_sales;

-- Data Exploration

-- How many sales we have?

SELECT 
	COUNT(*) as total_sales
FROM retali_sales;


-- How many unique customers we have?

SELECT 
	COUNT(DISTINCT customer_id)
FROM retali_sales
ORDER BY  customer_id;

-- How many unique categories we have?

SELECT 
	COUNT(DISTINCT category)
FROM retali_sales
ORDER BY  customer_id;


-- Data Analysis

-- 1) Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT 
	*
FROM retali_sales
WHERE sale_date = "2022-11-05";

-- 2) Write a SQL query to retrieve all transactions where the category is 'Clothing'
--    and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retali_sales
WHERE category = "clothing"
AND   quantiy >= 4
AND   monthname(sale_date) = "November"
AND   year(sale_date) = "2022";


-- 3) Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
	category,
    SUM(total_sale) as total_sales,
    COUNT(*) as total_orders
FROM retali_sales
GROUP BY category;


-- 4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT 
 ROUND(AVG(age),0) as avg_age
 FROM retali_sales
 WHERE category = "beauty";
 

 -- 5) Write a SQL query to find all transactions where the total_sale is greater than 1000.:
 
 SELECT 
	* 
FROM retali_sales
WHERE total_sale > 1000;


-- 6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT
	category,
	gender,
    COUNT(*) as total_transaction
FROM retali_sales
GROUP BY gender, category
ORDER BY category;


-- 7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
	year, month, avg_sale
FROM (
SELECT 
	year(sale_date) AS year,
    monthname(sale_date) AS month,
    ROUND(AVG(total_sale),0) AS avg_sale,
    DENSE_RANK() OVER(PARTITION BY year(sale_date) ORDER BY AVG(total_sale) DESC) as rnk
FROM retali_sales
GROUP BY year(sale_date),monthname(sale_date)
ORDER BY year
)subquery
WHERE rnk = 1;

 
-- 8) *Write a SQL query to find the top 5 customers based on the highest total sales
    
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retali_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5 OFFSET 0;


-- 9) Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
	category,
    COUNT(DISTINCT customer_id) AS customers
FROM retali_sales
GROUP BY category;

SELECT * FROM retali_sales;
-- 10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

SELECT 
	shift,
    COUNT(*) AS total_orders
FROM 
(
	SELECT 
		*,
		CASE
			WHEN HOUR(sale_time) < 12 THEN "Morning"
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
			ELSE "Evening"
		END as shift
	FROM retali_sales
) subquerry
GROUP BY shift;

-- End of project