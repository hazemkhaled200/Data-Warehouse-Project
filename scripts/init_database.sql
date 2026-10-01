/*
======================================
Create Database and Schemas
======================================
Script Purpose:
	This script is for creating the database 'Datawarehouse'
	and creating 'bronze', 'silver ', and 'gold' schemas
WARNING:
	This code will delete the 'Datawarehouse' database if it exists 
	and then will create it as an empty database.
*/

USE master;
GO

-- Check existence of the database Datawarehouse and recreate it.
IF DB_ID('Datawarehouse') IS NOT NULL
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Datawarehouse;
END
GO

-- Creating database Datawarehouse.
CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;  
GO

-- Creating Schemas.
CREATE SCHEMA bronze; 
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
