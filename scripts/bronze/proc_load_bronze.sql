TRUNCATE TABLE crm_cust_info;

LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/cust_info.csv"
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

TRUNCATE TABLE crm_prd_info;

LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/prd_info.csv"
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

TRUNCATE TABLE crm_sales_details;

LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/sales_details.csv"
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

TRUNCATE TABLE erp_cust_az12;

LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/CUST_AZ12.csv"
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

TRUNCATE TABLE erp_loc_a101;

LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/LOC_A101.csv"
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

TRUNCATE TABLE erp_px_cat_g1v2;

LOAD DATA INFILE 
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/PX_CAT_G1V2.csv"
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
