/*
=====================================
Loading Bronze Layer
=====================================
Script Purpose:
	Create a stored procedure that loads data from the source systems 
	into the bronze layer using TRUNCATE & INSERT

Parameters:
	@start_time: start time of the process of loading the table.
	@end_time: end time of the process of loading the table.
	@batch_start: start time of the process of loading the whole layer.
	@batch_end: end time of the process of loading the whole layer.

Using example:
	EXEC load_bronze
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME

		PRINT('=================================');
		PRINT('Loading Bronze Layer...');
		PRINT('=================================');

		PRINT('----------------------------');
		PRINT('Loading CRM Tables');
		PRINT('----------------------------');

		PRINT('>> Truncating Table bronze.crm_cust_info');

		SET @batch_start = GETDATE();
		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT('>> Creating Table bronze.crm_cust_info');
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\DWH Project\Baraa version\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);

		SET @end_time = GETDATE();

		PRINT('Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds');
		PRINT('------------')

		PRINT('>> Truncating Table bronze.crm_prd_info');

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT('>> Creating Table bronze.crm_prd_info');
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\DWH Project\Baraa version\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT('Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds');
		PRINT('------------')

		PRINT('>> Truncating Table bronze.crm_sales_details');

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT('>> Creating Table bronze.crm_sales_details');
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\DWH Project\Baraa version\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT('Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds');
		PRINT('------------')

		PRINT('----------------------------')
		PRINT('Loading ERP Tables')
		PRINT('----------------------------')

		PRINT('>> Truncating Table bronze.erp_CUST_AZ12')

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_CUST_AZ12

		PRINT('>> Creating Table bronze.erp_CUST_AZ12')
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'D:\DWH Project\Baraa version\datasets\source_erp\CUST_AZ12.CSV'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT('Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds');
		PRINT('------------')

		PRINT('>> Truncating Table bronze.erp_LOC_A101')

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_LOC_A101

		PRINT('>> Creating Table bronze.erp_LOC_A101')
		BULK INSERT bronze.erp_LOC_A101
		FROM 'D:\DWH Project\Baraa version\datasets\source_erp\LOC_A101.CSV'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT('Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds');
		PRINT('------------')

		PRINT('>> Truncating Table bronze.erp_PX_CAT_G1V2')

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2

		PRINT('>> Creating Table bronze.erp_PX_CAT_G1V2')
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'D:\DWH Project\Baraa version\datasets\source_erp\PX_CAT_G1V2.CSV'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		SET @batch_end = GETDATE();

		PRINT('Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds');
		PRINT('------------')
		PRINT('Batch Duration: ' + CAST(DATEDIFF(SECOND, @batch_start, @batch_end) AS NVARCHAR) + ' Seconds');
	END TRY
	BEGIN CATCH
		PRINT('Error occured!');
		PRINT('Error: ' + ERROR_MESSAGE());
		PRINT('Error Line: ' + ERROR_LINE());
		PRINT('Error Number: ' + ERROR_NUMBER());
	END CATCH
END

