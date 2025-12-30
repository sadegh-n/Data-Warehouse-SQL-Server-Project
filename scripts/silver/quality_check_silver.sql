/*
================================================================================
Silver Layer Quality Check
================================================================================
Final quality checks used after cleaning data
================================================================================


========================================
CRM Customer Info Table
========================================
*/
-- Checking Nulls and Duplicates in Primary Key
-- Expected: No Result
SELECT
	cst_id,
	COUNT(*)
FROM
	silver.crm_cust_info
GROUP BY
	cst_id
HAVING 
	COUNT(*) > 1 OR cst_id IS NULL

-- Checking unexpected whitespace in names
-- Expected: No result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname <> TRIM(cst_lastname)

-- Checking if categorical values are easy to understand
-- Expectation: Distinct and easy to understand names
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info

-- Final check
SELECT * FROM silver.crm_cust_info

/*
========================================
CRM Product Info Table
========================================
*/
-- Checking Negative and Null prices
-- Expectation: No result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Checking categorical values
-- Expectation: Easy to understand values
SELECT DISTINCT prd_line FROM silver.crm_prd_info

-- Checking to see if start and end dates make sense
-- Expectation: No result
SELECT * FROM silver.crm_prd_info WHERE prd_end_dt < prd_start_dt

SELECT * FROM silver.crm_prd_info

/*
========================================
CRM Sales Details Table
========================================
*/
-- Checking


