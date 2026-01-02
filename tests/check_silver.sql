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
    COUNT(*) > 1
    OR cst_id IS NULL

-- Checking unexpected whitespace in names
-- Expected: No result
SELECT
    cst_firstname
FROM
    silver.crm_cust_info
WHERE
    cst_firstname <> TRIM(cst_firstname)

SELECT
    cst_lastname
FROM
    silver.crm_cust_info
WHERE
    cst_lastname <> TRIM(cst_lastname)

-- Checking if categorical values are easy to understand
-- Expectation: Distinct and easy to understand names
SELECT DISTINCT
    cst_gndr
FROM
    silver.crm_cust_info

-- Final check
SELECT
    *
FROM
    silver.crm_cust_info

/*
========================================
CRM Product Info Table
========================================
*/
-- Checking Negative and Null prices
-- Expectation: No result
SELECT
    prd_cost
FROM
    silver.crm_prd_info
WHERE
    prd_cost < 0
    OR prd_cost IS NULL

-- Checking categorical values
-- Expectation: Easy to understand values
SELECT DISTINCT
    prd_line
FROM
    silver.crm_prd_info

-- Checking to see if start and end dates make sense
-- Expectation: No result
SELECT
    *
FROM
    silver.crm_prd_info
WHERE
    prd_end_dt < prd_start_dt

-- Final Check
SELECT
    *
FROM
    silver.crm_prd_info

/*
========================================
CRM Sales Details Table
========================================
*/
-- Checking Invalid Dates
-- Expectation: No result

SELECT
    sls_order_dt
FROM
    silver.crm_sales_details
WHERE
    sls_order_dt > '2050/01/01'
    OR sls_order_dt < '1900/01/01'

SELECT
    sls_ship_dt
FROM
    silver.crm_sales_details
WHERE
    sls_ship_dt > '2050/01/01'
    OR sls_ship_dt < '1900/01/01'

SELECT
    sls_due_dt
FROM
    silver.crm_sales_details
WHERE
    sls_due_dt > '2050/01/01'
    OR sls_due_dt < '1900/01/01'

-- Checking Invalid Shipping/Due Dates
-- Expectation: No result

SELECT
    *
FROM
    silver.crm_sales_details
WHERE
    sls_order_dt > sls_ship_dt
    OR sls_order_dt > sls_due_dt

-- Checking Business Rules of Sales/Price/Quantity
-- Expectation: No result

SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM
    silver.crm_sales_details
WHERE
    sls_sales <> sls_quantity * sls_price
    OR sls_sales IS NULL
    OR sls_sales <= 0
    OR sls_quantity IS NULL
    OR sls_quantity <= 0
    OR sls_price IS NULL
    OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price

-- Final Check
SELECT
    *
FROM
    silver.crm_sales_details

/*
========================================
ERP Customer Table
========================================
*/
-- Checking Table Keys
SELECT 
    cid,
    bdate,
    gen
FROM
    bronze.erp_cust_az12
WHERE
    cid LIKE '%AW00011000'
SELECT 
    cst_key
FROM
    silver.crm_cust_info

-- Checking cid Transformation
SELECT
    cid,
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
         ELSE cid
    END AS cid,
    bdate,
    gen
FROM
    silver.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
         ELSE cid 
      END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

-- Checking Invalid Dates
SELECT DISTINCT
    bdate
FROM
    silver.erp_cust_az12
WHERE 
    bdate < '1924-01-01'
    OR bdate > GETDATE()
-- Checking Gender Consistency
SELECT DISTINCT
    gen
FROM
    silver.erp_cust_az12

/*
========================================
ERP Location Table
========================================
*/
-- Checking cid
SELECT
    REPLACE(cid, '-', '') cid,
    cntry
FROM
    silver.erp_loc_a101
WHERE
    REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info)
-- Country Standardization
SELECT DISTINCT
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(cntry)
	END AS cntry
FROM 
    silver.erp_loc_a101
ORDER BY
    cntry

SELECT 
    *
FROM
    silver.erp_loc_a101
/*
========================================
ERP Category Table
========================================
*/
-- Checking Whitespace
SELECT
    *
FROM
    silver.erp_px_cat_g1v2
WHERE
    cat <> TRIM(cat)
    OR subcat <> TRIM(subcat)
    OR maintenance <> TRIM(maintenance)

-- Checking Data Consistency
SELECT DISTINCT
    cat
FROM
    silver.erp_px_cat_g1v2
SELECT DISTINCT
    subcat
FROM
    silver.erp_px_cat_g1v2
SELECT DISTINCT
    maintenance
FROM
    silver.erp_px_cat_g1v2

-- Final Check
SELECT
    *
FROM
    silver.erp_px_cat_g1v2
