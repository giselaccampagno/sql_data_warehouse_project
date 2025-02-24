/* 
Truncating & Loading CRM Tables
*/

TRUNCATE TABLE crm_cust_info;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv"
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading crm_cust_info Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;


TRUNCATE TABLE crm_prd_info;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv"
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(prd_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, @prd_end_dt)  -- Use a temporal variable @prd_end_dt
SET prd_end_dt = NULLIF(@prd_end_dt, '');  -- Transforme empty values to NULL
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading crm_prd_info Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

TRUNCATE TABLE crm_sales_details;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv"
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'  
IGNORE 1 LINES
(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, @sls_sales, sls_quantity, @sls_price)  -- Use temporal variables
SET sls_price = NULLIF(@sls_price, ''),
	sls_sales = NULLIF(@sls_sales, '');
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading crm_sales_details Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

/* 
Truncating & Loading CRM Tables
*/

TRUNCATE TABLE erp_cust_az12;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv"
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading erp_cust_az12 Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

TRUNCATE TABLE erp_loc_a101;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv"
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading erp_loc_a101 Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;

TRUNCATE TABLE erp_px_cat_g1v2;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv"
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(
    "Truncating & Loading erp_px_cat_g1v2 Table\n >> Load Duration: ", 
    CAST(TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS CHAR), 
    " seconds\n"
) AS Output;
