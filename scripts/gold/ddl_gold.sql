-- =============================================================================
-- Create Dimension: gold2.dim_customers
-- =============================================================================
DROP VIEW IF EXISTS gold2.dim_customers;

CREATE VIEW gold2.dim_customers AS (
SELECT 
	ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS fisrt_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  -- CRM is the primary source for gender
        ELSE COALESCE(ca.gen, 'n/a')  -- Fallback to ERP data
	END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver2.crm_cust_info AS ci
LEFT JOIN silver2.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver2.erp_loc_a101 AS la
ON ci.cst_key = la.cid
);

-- =============================================================================
-- Create Dimension: gold2.dim_products
-- =============================================================================
DROP VIEW IF EXISTS gold2.dim_products;

CREATE VIEW dim_products AS (
SELECT 
	ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key, 
    -- Foreign key
	pi.prd_id AS product_id,
    pi.prd_key AS product_number,
	pi.prd_nm AS product_name,
    pi.cat_id AS category_id,
	cg.cat AS category,
	cg.subcat AS subcategory,
	cg.maintenance,
	pi.prd_line AS product_line,
    pi.prd_cost AS product_cost,
    pi.prd_start_dt AS product_start_date
FROM silver2.crm_prd_info AS pi
LEFT JOIN silver2.erp_px_cat_g1v2 AS cg
ON pi.cat_id = cg.id
WHERE pi.prd_end_dt IS NULL -- Filter out all historical data
);

-- =============================================================================
-- Create Fact Table: gold2.fact_sales
-- =============================================================================
DROP VIEW IF EXISTS gold2.fact_sales;

CREATE VIEW fact_sales AS (
SELECT 
	sd.sls_ord_num AS order_number,
    dp.product_key AS product_key,
    dc.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS ship_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver2.crm_sales_details AS sd
LEFT JOIN gold2.dim_customers AS dc
ON sd.sls_cust_id = dc.customer_id
LEFT JOIN gold2.dim_products AS dp
ON sd.sls_prd_key = dp.product_number
);
