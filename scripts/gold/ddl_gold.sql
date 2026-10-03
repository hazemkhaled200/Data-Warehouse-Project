/*
Script Purpose:
	This script creates views of the gold layer
*/

-- View | dim_customer
IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
	DROP VIEW gold.dim_customer;
GO
CREATE VIEW gold.dim_customer AS
(
	SELECT
		ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS firstname,
		ci.cst_lastname AS lastname,
		lc.CNTRY AS country,
		az.BDATE AS birthdate,
		az.AGE AS age,
		ci.cst_marital_status AS marital_status,
		CASE
			WHEN ci.cst_gndr = 'n/a' THEN ISNULL(az.GEN, 'n/a')
			ELSE ci.cst_gndr
		END gender,
		cst_create_date AS create_date
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_LOC_A101 lc
		ON ci.cst_key = lc.CID
	LEFT JOIN silver.erp_CUST_AZ12 az
		ON ci.cst_key = az.CID
)

GO

-- View | dim_product
IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
	DROP VIEW gold.dim_product;
GO
CREATE VIEW gold.dim_product AS
(
	SELECT
		ROW_NUMBER() OVER(ORDER BY prd_start_dt, prd_id) AS product_key,
		pd.prd_id AS product_id,
		pd.prd_key AS product_number,
		pd.prd_nm AS product_name,
		pd.prd_cat_id AS category_id,
		ct.CAT AS category,
		ct.SUBCAT AS sub_category,
		pd.prd_line AS product_line,
		pd.prd_cost AS cost,
		ct.MAINTENANCE AS maintenance,
		pd.prd_start_dt start_date
		--pd.prd_end_dt end_date
	FROM silver.crm_prd_info pd
	LEFT JOIN silver.erp_PX_CAT_G1V2 ct
		ON pd.prd_cat_id = ct.ID
	WHERE prd_end_dt IS NULL -- Filter Historical Data.
)

GO

-- View | fact_sales
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
(
	SELECT
		sd.sls_ord_num AS order_number,
		dp.product_key AS product_key,
		dc.customer_key AS customer_key,
		sls_order_dt AS order_date,
		sls_ship_dt AS ship_date,
		sls_due_dt AS due_date, 
		sls_sales AS sales,
		sls_quantity AS quantity,
		sls_price AS price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_product dp
		ON sd.sls_prd_key = dp.product_number
	LEFT JOIN gold.dim_customer dc
		ON sd.sls_cust_id = dc.customer_id
)
