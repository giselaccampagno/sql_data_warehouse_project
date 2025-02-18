-- Loading crm_cust_info Table

INSERT INTO silver.crm_cust_info (
cst_id, cst_key, cst_firstname, cst_lastname, 
cst_marital_status, cst_gndr, cst_create_date)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE 
	WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
	WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
END AS cst_marital_status, -- Normalize marital status to readable format
CASE 
	WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
    ELSE 'N/A'
END AS cst_gndr, -- Normalize gender values to readable format
cst_create_date 
FROM (
	SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL) AS t
    WHERE flag_last=1; -- Select the most recent record per cuatomer 

-- Loading crm_prd_info Table

INSERT INTO silver.crm_prd_info (
prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
SELECT  
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,  
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,  
    TRIM(prd_nm) AS prd_nm,  
    prd_cost,
    CASE UPPER(TRIM(prd_line))  
        WHEN 'S' THEN 'Sport'  
        WHEN 'M' THEN 'Mountain'  
        WHEN 'T' THEN 'Touring' 
        WHEN 'R' THEN 'Road'
        ELSE 'N/A'  
    END AS prd_line,
    prd_start_dt,
    LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt - 1) prd_end_dt
FROM bronze.crm_prd_info;

-- Loading crm_sales_details Table

INSERT INTO silver.crm_sales_details (
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
FROM bronze.crm_sales_details;

-- Loading erp_cust_az12 Table

INSERT INTO silver.erp_cust_az12 (
	cid,
    bdate, 
    gen
)
	SELECT 
		SUBSTRING(cid, 4, LENGTH(cid)),
		CASE WHEN bdate > NOW() THEN NULL
			ELSE bdate
		END AS bdate,
		CASE 
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			ELSE 'N/A'
		END AS gen
	FROM bronze.erp_cust_az12;
