/*
===============================================================================
Quality Checks for MySQL
===============================================================================
*/

-- ====================================================================
-- Checking 'silver2.crm_cust_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
SELECT 
    cst_id,
    COUNT(*) 
FROM silver2.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
SELECT 
    cst_key 
FROM silver2.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
SELECT DISTINCT 
    cst_marital_status 
FROM silver2.crm_cust_info;

-- ====================================================================
-- Checking 'silver2.crm_prd_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
SELECT 
    prd_id,
    COUNT(*) 
FROM silver2.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
SELECT 
    prd_nm 
FROM silver2.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Values in Cost
SELECT 
    prd_cost 
FROM silver2.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT 
    prd_line 
FROM silver2.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
SELECT 
    * 
FROM silver2.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'silver2.crm_sales_details'
-- ====================================================================
-- Check for Invalid Dates
SELECT 
    sls_due_dt 
FROM bronze2.crm_sales_details
WHERE sls_due_dt <= 0 
    OR CHAR_LENGTH(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
SELECT 
    * 
FROM silver2.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver2.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking 'silver2.erp_cust_az12'
-- ====================================================================
-- Identify Out-of-Range Dates
SELECT DISTINCT 
    bdate 
FROM silver2.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > CURRENT_DATE();

-- Data Standardization & Consistency
SELECT DISTINCT 
    gen 
FROM silver2.erp_cust_az12;

-- ====================================================================
-- Checking 'silver2.erp_loc_a101'
-- ====================================================================
-- Data Standardization & Consistency
SELECT DISTINCT 
    cntry 
FROM silver2.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking 'silver2.erp_px_cat_g1v2'
-- ====================================================================
-- Check for Unwanted Spaces
SELECT 
    * 
FROM silver2.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT 
    maintenance 
FROM silver2.erp_px_cat_g1v2;
