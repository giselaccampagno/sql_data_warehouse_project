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
