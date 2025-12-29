/*
========================================

Initializing Database and it's Schemas

========================================
This Script initializes a new database called 'DataWarehouse'. If the database is already created, it is dropped and recreated.
This warehouse will follow the medallion architecture, so three schemas are set up: 'bronze', 'silver', and 'gold'.

WARNING:
	Running this script will remove all data if 'DataWarehouse' already exists. Make sure to have a backup of the data before 
	using this script.
*/

USE master;
GO
-- Creating Data Warehouse and drop if already exsists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Creating Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
