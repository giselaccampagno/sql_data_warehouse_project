SELECT "-------------------";
SELECT "Loading CRM Tables";
SELECT "--------------------";

SELECT "Truncating & Loading crm_cust_info Tables";
SELECT "------------------------------------------";

TRUNCATE TABLE crm_cust_info;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/cust_info.csv"
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(">> Load Duration: ", TIMESTAMPDIFF(SECOND, @start_time, @end_time));
SELECT "--------------------------------------------------------------------------";

SELECT "Truncating & Loading crm_prd_info Tables";
SELECT "------------------------------------------";

TRUNCATE TABLE crm_prd_info;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/prd_info.csv"
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
TRUNCATE TABLE crm_sales_details;
SET @end_time = NOW();

SELECT CONCAT(">> Load Duration: ", TIMESTAMPDIFF(SECOND, @start_time, @end_time));
SELECT "---------------------------------------------------------------------------";

SELECT "Truncating & Loading crm_sales_details Tables";
SELECT "------------------------------------------";

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/sales_details.csv"
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(">> Load Duration: ", TIMESTAMPDIFF(SECOND, @start_time, @end_time));
SELECT "--------------------------------------------------------------------------";

SELECT "-------------------";
SELECT "Loading ERP Tables";
SELECT "--------------------";

SELECT "Truncating & Loading erp_cust_az12 Tables";
SELECT "-----------------------------------------";

TRUNCATE TABLE erp_cust_az12;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/CUST_AZ12.csv"
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(">> Load Duration: ", TIMESTAMPDIFF(SECOND, @start_time, @end_time));
SELECT "-------------------------------------------------------------------------";

SELECT "Truncating & Loading erp_loc_a101 Tables";
SELECT "------------------------------------------";

TRUNCATE TABLE erp_loc_a101;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/LOC_A101.csv"
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(">> Load Duration: ", TIMESTAMPDIFF(SECOND, @start_time, @end_time));
SELECT "-------------------------------------------------------------------------";

SELECT "Truncating & Loading erp_px_cat_g1v2 Tables";
SELECT "------------------------------------------";

TRUNCATE TABLE erp_px_cat_g1v2;

SET @start_time = NOW();
LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/PX_CAT_G1V2.csv"
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET @end_time = NOW();

SELECT CONCAT(">> Load Duration: ", TIMESTAMPDIFF(SECOND, @start_time, @end_time));
SELECT "---------------------------------------------------------------------------";




