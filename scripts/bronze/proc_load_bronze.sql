/*
================================================================================
Stored Procedure: Load Bronze Layer
================================================================================
Script Purpose:
  This procedure loads data from source csv files into bronze schema.
  It truncates the tables before using bulk insert to load the data.
Parameters:
  This procedure has no parameters and has no return value. 
Example:
  EXEC bronze.load_bronze
================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @batch_start DATETIME;
	DECLARE @start_time DATETIME;
	DECLARE @end_time DATETIME;
	DECLARE @batch_end DATETIME;
	BEGIN TRY
		SET @batch_start = GETDATE();
		PRINT '========================================';
		PRINT 'Loading Bronze Layer';
		PRINT '========================================';

		PRINT '----------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '----------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM '\\has.com\NS\Profiles$\S.Nassiri\Documents\SQL Server Management Studio 21\Queries\Local\My Data Warehouse\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(ms, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '----------------------------------------'
		--SELECT * FROM bronze.crm_cust_info
		--SELECT COUNT(*) FROM bronze.crm_cust_info
	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM '\\has.com\NS\Profiles$\S.Nassiri\Documents\SQL Server Management Studio 21\Queries\Local\My Data Warehouse\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(ms, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '----------------------------------------'
		--SELECT * FROM bronze.crm_prd_info
		--SELECT COUNT(*) FROM bronze.crm_prd_info

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM '\\has.com\NS\Profiles$\S.Nassiri\Documents\SQL Server Management Studio 21\Queries\Local\My Data Warehouse\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(ms, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '----------------------------------------'
		--SELECT * FROM bronze.crm_sales_details
		--SELECT COUNT(*) FROM bronze.crm_sales_details

		PRINT '----------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '----------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM '\\has.com\NS\Profiles$\S.Nassiri\Documents\SQL Server Management Studio 21\Queries\Local\My Data Warehouse\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(ms, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '----------------------------------------'
		--SELECT * FROM bronze.erp_cust_az12
		--SELECT COUNT(*) FROM bronze.erp_cust_az12
	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM '\\has.com\NS\Profiles$\S.Nassiri\Documents\SQL Server Management Studio 21\Queries\Local\My Data Warehouse\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(ms, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '----------------------------------------'
		--SELECT * FROM bronze.erp_loc_a101
		--SELECT COUNT(*) FROM bronze.erp_loc_a101

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM '\\has.com\NS\Profiles$\S.Nassiri\Documents\SQL Server Management Studio 21\Queries\Local\My Data Warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		--SELECT * FROM bronze.erp_px_cat_g1v2
		--SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(ms, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '----------------------------------------' 
		SET @batch_end = GETDATE();
		PRINT '========================================';
		PRINT 'Loading Bronze Layer is Completed'
		PRINT '		- Total Load Duration: ' + CAST( DATEDIFF(ms, @batch_start, @batch_end) AS NVARCHAR) + ' milliseconds' 
		PRINT '========================================';

	END TRY
	BEGIN CATCH
		PRINT '========================================';
		PRINT 'Error Occured During Loading Bronze Layer';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '========================================';
	END CATCH
END;
