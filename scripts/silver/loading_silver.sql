-- Loading crm_cust_info Table

TRUNCATE TABLE crm_cust_info;

SET @start_time = NOW();
INSERT INTO silver2.crm_cust_info
(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
SELECT 
	cst_id, 
    cst_key, 
    TRIM(cst_firstname) AS cst_firstname, 
    TRIM(cst_lastname) AS cst_lastname, 
	CASE  
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		ELSE 'n/a'
	END AS cst_marital_status,     -- Normalize marital status values to readable format
    CASE  
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr,     -- Normalize gender values to readable format
    cst_create_date
FROM
(SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze2.crm_cust_info) AS t
WHERE t.flag_last = 1; -- Select more recent record per customer
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading crm_cust_info Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

-- Loading crm_prd_info Table

TRUNCATE TABLE crm_prd_info;

SET @start_time = NOW();
INSERT INTO silver2.crm_prd_info
(prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
SELECT 
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- cat_id column filled with info from prd_key column
	SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, 
    prd_nm,
    prd_cost,
    CASE 
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other sales'
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
	END AS prd_line, -- Normalize prd_line values to readable format
    prd_start_dt,
    LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt - 1) AS prd_end_dt
	-- Correct end date
FROM bronze2.crm_prd_info
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading crm_prod_info Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

-- Loading crm_sales_details Table

TRUNCATE TABLE crm_sales_details;

SET @start_time = NOW();
INSERT INTO silver2.crm_sales_details (
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  sls_order_dt,
  sls_ship_dt,
  sls_due_dt,
  sls_sales,
  sls_quantity,
  sls_price
)
SELECT 
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  CAST(NULLIF(sls_order_dt, '0') AS DATE) AS sls_order_dt,
  CAST(NULLIF(sls_ship_dt, '0') AS DATE) AS sls_ship_dt,
  CAST(NULLIF(sls_due_dt, '0') AS DATE) AS sls_due_dt,
  CASE 
    WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
    THEN sls_quantity * ABS(sls_price)
    ELSE sls_sales
  END AS sls_sales,
  sls_quantity,
  CASE
    WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / IFNULL(sls_quantity, 0)
    ELSE sls_price
  END AS sls_price
FROM bronze2.crm_sales_details;
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading crm_sales_details Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

-- Loading erp_cust_az12 Table

TRUNCATE TABLE erp_cust_az12;

SET @start_time = NOW();
INSERT INTO silver2.erp_cust_az12
(cid, bdate, gen)
SELECT 
	SUBSTRING(cid, 4, LENGTH(cid)) AS cid, 
    CASE 
		WHEN bdate > NOW() OR bdate < '1925-01-01'
        THEN NULL
		ELSE bdate
    END AS bdate, -- Converting invalid birthdates to NULL
    CASE
		WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) = 'MALE'
        THEN 'Male'
        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) = 'FEMALE'
        THEN 'Female'
		ELSE 'n/a'
	END	AS gen
	/* 
    Removing carriage return (CHAR(13)) and newline (CHAR(10)) characters.
	Removing leading and trailing spaces from the cleaned gen value.
	Converting the cleaned value to uppercase to ensure case insensitivity.
    */
FROM bronze2.erp_cust_az12;
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading erp_cust_az12 Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

-- Loading erp_loc_a101 Table

TRUNCATE TABLE erp_loc_a101;

SET @start_time = NOW();
INSERT INTO silver2.erp_loc_a101
(cid, cntry)
SELECT 
	REPLACE(cid, '-', '') AS cid,
	CASE
		WHEN UPPER(TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''))) IN ('US', 'USA') THEN 'United States'
		WHEN UPPER(TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''))) = 'DE' THEN 'Germany'
		WHEN TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), '')) = '' THEN 'n/a' -- Handling empty strings explicitly
		WHEN UPPER(TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''))) IS NULL THEN 'n/a'
		ELSE TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), '')) -- Trim to remove any extra spaces
	END AS cntry
/* 
	Removing carriage return (CHAR(13)) and newline (CHAR(10)) characters.
	Removing leading and trailing spaces from the cleaned gen value.
	Converting the cleaned value to uppercase to ensure case insensitivity.
*/    
FROM bronze2.erp_loc_a101;
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading erp_loc_a101 Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

-- Loading px_cat_g1v2 Table

TRUNCATE TABLE erp_px_cat_g1v2;

SET @start_time = NOW();
INSERT INTO silver2.erp_px_cat_g1v2
(id, cat, subcat, maintenance)
SELECT 
	id,
    cat,
    subcat,
    TRIM(REPLACE(REPLACE(maintenance, CHAR(13), ''), CHAR(10), '')) as maintenance
/* 
	Removing carriage return (CHAR(13)) and newline (CHAR(10)) characters.
	Removing leading and trailing spaces from the cleaned gen value.
*/
FROM bronze2.erp_px_cat_g1v2;
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading erp_px_cat_g1v2 Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

