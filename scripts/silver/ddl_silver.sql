/*
=============================
Create Tables
=============================
Script Purpose:
	This script creates tables within the silver layer
	after checking that they don't exist.
WARNING:
	This script drops all the tables and recreates them, and this
	may cause data loss.
*/

PRINT('==========================================')
PRINT('Creating Tables Into The Silver Layer...')
PRINT('==========================================')


PRINT('------------------------------------------')
PRINT('>> Truncating Table silver.crm_cust_info')
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;

GO

PRINT('>> Creating Table silver.crm_cust_info')
PRINT('------------------------------------------')
CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME DEFAULT GETDATE()
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table silver.crm_prd_info')
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;

GO

PRINT('>> Creating Table silver.crm_prd_info')
PRINT('------------------------------------------')
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	prd_cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME DEFAULT GETDATE()
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table silver.crm_sales_details')
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;

GO

PRINT('>> Creating Table silver.crm_sales_details')
PRINT('------------------------------------------')
CREATE TABLE silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT, 
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME DEFAULT GETDATE()
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table silver.erp_CUST_AZ12')
IF OBJECT_ID('silver.erp_CUST_AZ12', 'U') IS NOT NULL
	DROP TABLE silver.erp_CUST_AZ12;

GO

PRINT('>> Creating Table silver.erp_CUST_AZ12')
PRINT('------------------------------------------')
CREATE TABLE silver.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE DATE,
	AGE INT,
	GEN NVARCHAR(50),
	dwh_create_date DATETIME DEFAULT GETDATE()
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table silver.erp_LOC_A101')
IF OBJECT_ID('silver.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE silver.erp_LOC_A101;

GO

PRINT('>> Creating Table silver.erp_LOC_A101')
PRINT('------------------------------------------')
CREATE TABLE silver.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50),
	dwh_create_date DATETIME DEFAULT GETDATE()
)
GO

PRINT('------------------------------------------')
PRINT('>> Truncating Table silver.erp_PX_CAT_G1V2')
IF OBJECT_ID('silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE silver.erp_PX_CAT_G1V2;

GO

PRINT('>> Creating Table silver.erp_PX_CAT_G1V2')
PRINT('------------------------------------------')
CREATE TABLE silver.erp_PX_CAT_G1V2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date DATETIME DEFAULT GETDATE()
)
