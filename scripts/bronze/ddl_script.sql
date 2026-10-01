/*
=============================
Create Tables
=============================
Script Purpose:
	This script creates tables within the bronze layer
	after checking that they don't exist.
WARNING:
	This script drops all the tables and recreates them, and this
	may cause data loss.
*/

PRINT('==========================================')
PRINT('Creating Tables Into The Bronze Layer...')
PRINT('==========================================')


PRINT('------------------------------------------')
PRINT('>> Truncating Table bronze.crm_cust_info')
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

GO

PRINT('>> Creating Table bronze.crm_cust_info')
PRINT('------------------------------------------')
CREATE TABLE bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table bronze.crm_prd_info')
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;

GO

PRINT('>> Creating Table bronze.crm_prd_info')
PRINT('------------------------------------------')
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table bronze.crm_sales_details')
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;

GO

PRINT('>> Creating Table bronze.crm_sales_details')
PRINT('------------------------------------------')
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT, 
	sls_quantity INT,
	sls_price INT
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table bronze.erp_CUST_AZ12')
IF OBJECT_ID('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_CUST_AZ12;

GO

PRINT('>> Creating Table bronze.erp_CUST_AZ12')
PRINT('------------------------------------------')
CREATE TABLE bronze.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50)
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table bronze.erp_LOC_A101')
IF OBJECT_ID('bronze.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_LOC_A101;

GO

PRINT('>> Creating Table bronze.erp_LOC_A101')
PRINT('------------------------------------------')
CREATE TABLE bronze.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table bronze.erp_PX_CAT_G1V2')
IF OBJECT_ID('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_PX_CAT_G1V2;

GO

PRINT('>> Creating Table bronze.erp_PX_CAT_G1V2')
PRINT('------------------------------------------')
CREATE TABLE bronze.erp_PX_CAT_G1V2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
)
