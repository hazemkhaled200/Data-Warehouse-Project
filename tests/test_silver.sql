/*
Script Purpose:
	This script tests the data correctness of 
	the silver layer by checking whether the cleaning
	is done correctly or not.
*/

/*
----------------------------------
-- Tests on silver.crm_cust_info
----------------------------------
*/

SELECT * FROM bronze.crm_cust_info;

-- Check for nulls and duplicates in cst_id.
-- Expectation: No Result.
SELECT 
	cst_id, 
	COUNT(*) Dups
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(cst_id) > 1 OR cst_id IS NULL;

-- Check the foreign key
SELECT TOP 10 cst_id, cst_key FROM bronze.crm_cust_info;
SELECT TOP 10 CID FROM bronze.erp_CUST_AZ12;
SELECT TOP 10 sls_cust_id FROM bronze.crm_sales_details;



-- Check for unwanted spaces.
-- Expectation: No Results.
SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check the unique values.
SELECT DISTINCT cst_marital_status FROM bronze.crm_cust_info;
SELECT DISTINCT cst_gndr FROM bronze.crm_cust_info;

-- Check the table silver.crm_cust_info
SELECT * FROM silver.crm_cust_info;
SELECT COUNT(*) FROM silver.crm_cust_info;

/*
----------------------------------
-- Tests on silver.crm_prd_info
----------------------------------
*/

SELECT * FROM bronze.crm_prd_info;

-- Check for nulls and duplicates in cst_id.
-- Expectation: No Result.
SELECT 
	prd_id, 
	COUNT(*) Dups
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(prd_id) > 1 OR prd_id IS NULL;

-- Check the foreign key
SELECT TOP 10 prd_key FROM bronze.crm_prd_info;
SELECT TOP 10 sls_prd_key FROM bronze.crm_sales_details;
SELECT TOP 10 ID FROM bronze.erp_PX_CAT_G1V2;

-- Check for unwanted spaces
-- Expectation: No Result
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for nulls & negative values.
-- Expectation: No Result.
SELECT
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Check for unique values
SELECT DISTINCT prd_line FROM bronze.crm_prd_info

-- Check for wrong dates.
SELECT 
	prd_id,
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- Check silver.crm_prd_info
SELECT * FROM silver.crm_prd_info
SELECT COUNT(*) FROM silver.crm_prd_info


/*
----------------------------------
-- Tests on silver.crm_sales_details
----------------------------------
*/

SELECT * FROM bronze.crm_sales_details;

-- Check for unwanted spaces
-- Expectation: No Result
SELECT
	sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key);

-- Check for date values.
-- Expectation: No Results.
SELECT 
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 OR 
	LEN(sls_order_dt) != 8 
	OR sls_order_dt > 20500101 
	OR sls_order_dt < 19000101

-- Check for invalid calculations.
-- Expectation: No Results.
SELECT 
	sls_sales,
	sls_quantity, 
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales <= 0 OR sls_sales != sls_quantity * sls_price OR sls_sales IS NULL

SELECT * FROM silver.crm_sales_details;
SELECT COUNT(*) FROM silver.crm_sales_details;

/*
----------------------------------
-- Tests on silver.erp_CUST_AZ12
----------------------------------
*/

SELECT * FROM bronze.erp_CUST_AZ12;

-- Check the health of the foreign key
SELECT 
	*
FROM silver.erp_CUST_AZ12
WHERE CID NOT IN (SELECT cst_key FROM silver.crm_cust_info)

-- Check for invalid dates
SELECT
	*
FROM silver.erp_CUST_AZ12
WHERE BDATE < '1900-01-01' OR BDATE > '2026-01-01';

-- Check the unique values.
SELECT DISTINCT
	GEN
FROM silver.erp_CUST_AZ12;

SELECT * FROM silver.erp_CUST_AZ12;
SELECT COUNT(*) FROM silver.erp_CUST_AZ12;

/*
----------------------------------
-- Tests on silver.erp_LOC_A101
----------------------------------
*/

SELECT * FROM bronze.erp_LOC_A101;

-- Check the health of the foreign key
SELECT 
	*
FROM silver.erp_LOC_A101
WHERE CID NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

-- Check the unique values.
SELECT DISTINCT
	CNTRY
FROM silver.erp_LOC_A101;

/*
----------------------------------
-- Tests on silver.erp_LOC_A101
----------------------------------
*/
SELECT * FROM bronze.erp_PX_CAT_G1V2;

-- Check the health of the foreign key
SELECT 
	*
FROM silver.erp_PX_CAT_G1V2
WHERE ID NOT IN (SELECT DISTINCT prd_cat_id FROM silver.crm_prd_info)

-- Check the unique values.
SELECT DISTINCT
	MAINTENANCE
FROM silver.erp_PX_CAT_G1V2;



