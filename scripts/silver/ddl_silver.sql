DROP DATABASE IF EXISTS silver;

CREATE DATABASE silver;

USE silver;

CREATE TABLE `crm_cust_info` (
  `cst_id` int DEFAULT NULL,
  `cst_key` varchar(50) DEFAULT NULL,
  `cst_firstname` varchar(50) DEFAULT NULL,
  `cst_lastname` varchar(50) DEFAULT NULL,
  `cst_marital_status` varchar(50) DEFAULT NULL,
  `cst_gndr` varchar(50) DEFAULT NULL,
  `cst_create_date` date DEFAULT NULL,
  `dwh_create_date` datetime DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `crm_prd_info` (
  `prd_id` int DEFAULT NULL,
  `prd_key` varchar(50) DEFAULT NULL,
  `prd_nm` varchar(50) DEFAULT NULL,
  `prd_cost` int DEFAULT NULL,
  `prd_line` varchar(50) DEFAULT NULL,
  `prd_start_dt` date DEFAULT NULL,
  `prd_end_dt` date DEFAULT NULL,
  `dwh_create_date` datetime DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `crm_sales_details` (
  `sls_ord_num` varchar(50) DEFAULT NULL,
  `sls_prd_key` varchar(50) DEFAULT NULL,
  `sls_cust_id` int DEFAULT NULL,
  `sls_order_dt` int DEFAULT NULL,
  `sls_ship_dt` int DEFAULT NULL,
  `sls_due_dt` int DEFAULT NULL,
  `sls_sales` int DEFAULT NULL,
  `sls_quantity` int DEFAULT NULL,
  `sls_price` int DEFAULT NULL,
  `dwh_create_date` datetime DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `erp_cust_az12` (
  `cid` varchar(50) DEFAULT NULL,
  `bdate` date DEFAULT NULL,
  `gen` varchar(50) DEFAULT NULL,
  `dwh_create_date` datetime DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `erp_loc_a101` (
  `cid` varchar(50) DEFAULT NULL,
  `cntry` varchar(50) DEFAULT NULL,
  `dwh_create_date` datetime DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `erp_px_cat_g1v2` (
  `id` varchar(50) DEFAULT NULL,
  `cat` varchar(50) DEFAULT NULL,
  `subcat` varchar(50) DEFAULT NULL,
  `maintenance` varchar(50) DEFAULT NULL,
  `dwh_create_date` datetime DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
