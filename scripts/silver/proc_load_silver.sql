/*
Script Purpose:
	This script creates a procedure that is used to load
	silver layer by truncating tables and then inserting
	data into them.
Usage example:
	EXEC load_silver;
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME
	BEGIN TRY
		PRINT('==========================')
		PRINT('Loading silver layer...')
		PRINT('==========================')
		
		PRINT('--------------------------')
		PRINT('Loading crm tables...')
		PRINT('--------------------------')

		PRINT('>> Loading silver.crm_cust_info')
		SET @batch_start = GETDATE();
		SET @start_time = GETDATE();

		TRUNCATE TABLE silver.crm_cust_info;
		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE UPPER(TRIM(cst_marital_status))
				WHEN 'M' THEN 'Married'
				WHEN 'S' THEN 'Single'
				ELSE 'n/a'
			END cst_marital_status,
			CASE UPPER(TRIM(cst_gndr))
				WHEN 'M' THEN 'Male'
				WHEN 'F' THEN 'Female'
				ELSE 'n/a'
			END cst_gndr,
			cst_create_date
		FROM (
			SELECT
				*,
				ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS id_flag
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t WHERE id_flag = 1

		SET @end_time = GETDATE();
		PRINT('Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds')
		PRINT('---------------')

		PRINT('>> Loading silver.crm_prd_info')
		SET @start_time = GETDATE();

		TRUNCATE TABLE silver.crm_prd_info;
		INSERT INTO silver.crm_prd_info (
			prd_id,
			prd_cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'M' THEN 'Mountain'
				WHEN 'T' THEN 'Touring'
				ELSE 'n/a'
			END prd_line,
			prd_start_dt,
			DATEADD(DAY, -1, LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
		FROM bronze.crm_prd_info;

		SET @end_time = GETDATE();
		PRINT('Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds')
		PRINT('---------------')

		PRINT('>> Loading silver.crm_sales_details')
		SET @start_time = GETDATE();

		TRUNCATE TABLE silver.crm_sales_details;
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price)

		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
			END sls_order_dt,
			CASE 
				WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END sls_ship_dt,
			CASE 
				WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END sls_due_dt,
			CASE
				WHEN sls_sales IS NULL OR
					 sls_sales <= 0 OR
					 sls_sales != sls_quantity * sls_price THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END sls_sales,
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <= 0THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price
			END sls_price
		FROM bronze.crm_sales_details;

		SET @end_time = GETDATE();
		PRINT('Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds')
		PRINT('---------------')

		PRINT('--------------------------')
		PRINT('Loading erp tables...')
		PRINT('--------------------------')

		PRINT('>> Loading silver.erp_CUST_AZ12')
		SET @start_time = GETDATE();

		TRUNCATE TABLE silver.erp_CUST_AZ12
		INSERT INTO silver.erp_CUST_AZ12 (
			CID,
			BDATE,
			AGE,
			GEN)
		SELECT 
			CASE 
				WHEN CID LIKE 'NAS%' THEN SUBSTRING(TRIM(CID), 4, LEN(CID))
				ELSE CID
			END CID,
			CASE
				WHEN BDATE < '1900-01-01' OR BDATE > '2026-01-01' THEN NULL
				ELSE BDATE
			END BDATE,
			DATEDIFF(YEAR, BDATE, CAST(GETDATE() AS DATE)) AS AGE,
			CASE 
				WHEN GEN = UPPER(TRIM('M')) OR GEN = UPPER(TRIM('MALE')) THEN 'Male'
				WHEN GEN = UPPER(TRIM('F')) OR GEN = UPPER(TRIM('FEMALE')) THEN 'Female'
				ELSE 'n/a'
			END GEN
		FROM bronze.erp_CUST_AZ12;

		SET @end_time = GETDATE();
		PRINT('Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds')
		PRINT('---------------')

		PRINT('>> Loading silver.erp_LOC_A101')
		SET @start_time = GETDATE();

		TRUNCATE TABLE silver.erp_LOC_A101
		INSERT INTO silver.erp_LOC_A101(
			CID,
			CNTRY)

		SELECT 
			REPLACE(CID, '-', '') AS CID,
			CASE
				WHEN CNTRY = 'US' OR CNTRY = 'USA' OR CNTRY = 'United States' THEN 'United States'
				WHEN CNTRY = 'DE' OR CNTRY = 'Germany' THEN 'Germany'
				WHEN CNTRY IS NULL OR CNTRY = '' THEN 'n/a'
				ELSE CNTRY
			END CNTRY
		FROM bronze.erp_LOC_A101;

		SET @end_time = GETDATE();
		PRINT('Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds')
		PRINT('---------------')

		PRINT('>> Loading silver.erp_PX_CAT_G1V2')
		SET @start_time = GETDATE();

		TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
		INSERT INTO silver.erp_PX_CAT_G1V2 (
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE)
		SELECT  
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		FROM bronze.erp_PX_CAT_G1V2;

		SET @end_time = GETDATE();
		PRINT('Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds')
		PRINT('---------------')
	END TRY
	BEGIN CATCH
		PRINT('Error occured!');
		PRINT('Error message: ' + ERROR_MESSAGE());
		PRINT('Error line: ' + ERROR_LINE());
		PRINT('Error number: ' + ERROR_NUMBER());
	END CATCH

	SET @batch_end = GETDATE();
	PRINT('Batch Duration: ' + CAST(DATEDIFF(SECOND, @batch_start, @batch_end) AS VARCHAR) + ' Seconds')
	PRINT('---------------')
END
