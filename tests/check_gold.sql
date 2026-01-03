/*
================================================================================
Gold Layer Quality Check
================================================================================
Final quality checks used after creating views
================================================================================


================================================================================
Customer Dimension View
================================================================================
*/
-- Checking uniqueness of customer key

SELECT
	customer_key,
	COUNT(*) AS key_count
FROM
	gold.dim_customers
GROUP BY
	customer_key
HAVING
	COUNT(*) > 1;

/*
================================================================================
Product Dimension View
================================================================================
*/
-- Checking uniqueness of product key
SELECT
	product_key,
	COUNT(*) AS key_count
FROM
	gold.dim_products
GROUP BY
	product_key
HAVING
	COUNT(*) > 1;
/*
================================================================================
Fact Sales
================================================================================
*/
-- Checking foreign key consistency for fact view
SELECT
	*
FROM
	gold.fact_sales f
LEFT JOIN 
	gold.dim_customers c
	ON c.customer_key = f.customer_key
LEFT JOIN
	gold.dim_products p
	ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
