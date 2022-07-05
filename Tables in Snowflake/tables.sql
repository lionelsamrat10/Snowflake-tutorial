-- Permanent Table
CREATE OR REPLACE DATABASE PDB;

CREATE OR REPLACE TABLE PDB.public.customers (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
  
CREATE OR REPLACE TABLE PDB.public.helper (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
    
-- Stage and file format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    type = csv
    field_delimiter = ','
    skip_header = 1
    
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    
LIST  @MANAGE_DB.external_stages.time_travel_stage;


// Copy data and insert in table
COPY INTO PDB.public.helper
FROM @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');




SELECT * FROM PDB.public.customers;

INSERT INTO PDB.public.customers
SELECT
t1.ID
,t1.FIRST_NAME	
,t1.LAST_NAME	
,t1.EMAIL	
,t1.GENDER	
,t1.JOB
,t1.PHONE
 FROM PDB.public.helper t1
CROSS JOIN (SELECT * FROM PDB.public.helper) t2
CROSS JOIN (SELECT TOP 100 * FROM PDB.public.helper) t3;




// Show table and validate
SHOW TABLES;







// Permanent tables

USE OUR_FIRST_DB

CREATE OR REPLACE TABLE customers (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
  
CREATE OR REPLACE DATABASE PDB;

SHOW DATABASES;

SHOW TABLES;



// View table metrics (takes a bit to appear)
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS


SELECT 	ID, 
       	TABLE_NAME, 
		TABLE_SCHEMA,
        TABLE_CATALOG,
		ACTIVE_BYTES / (1024*1024*1024) AS ACTIVE_STORAGE_USED_GB,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB,
		FAILSAFE_BYTES / (1024*1024*1024) AS FAILSAFE_STORAGE_USED_GB,
        IS_TRANSIENT,
        DELETED,
        TABLE_CREATED,
        TABLE_DROPPED,
        TABLE_ENTERED_FAILSAFE
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
--WHERE TABLE_CATALOG ='PDB'
WHERE TABLE_DROPPED is not null
ORDER BY FAILSAFE_BYTES DESC;


-- Transient tables
CREATE OR REPLACE DATABASE TDB;

CREATE OR REPLACE TRANSIENT TABLE TDB.public.customers_transient (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);

INSERT INTO TDB.public.customers_transient
SELECT t1.* FROM PDB.public.customers t1
CROSS JOIN (SELECT * FROM OUR_FIRST_DB.public.customers) t2

SHOW TABLES;



// Query storage

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS


SELECT 	ID, 
       	TABLE_NAME, 
		TABLE_SCHEMA,
        TABLE_CATALOG,
		ACTIVE_BYTES,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB,
		FAILSAFE_BYTES / (1024*1024*1024) AS FAILSAFE_STORAGE_USED_GB,
        IS_TRANSIENT,
        DELETED,
        TABLE_CREATED,
        TABLE_DROPPED,
        TABLE_ENTERED_FAILSAFE
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE TABLE_CATALOG ='TDB'
ORDER BY TABLE_CREATED DESC;

// Set retention time to 0

ALTER TABLE TDB.public.customers_transient
SET DATA_RETENTION_TIME_IN_DAYS  = 0

DROP TABLE TDB.public.customers_transient;

UNDROP TABLE TDB.public.customers_transient;

SHOW TABLES;


// Creating transient schema and then table 

CREATE OR REPLACE TRANSIENT SCHEMA TRANSIENT_SCHEMA;

SHOW SCHEMAS;

CREATE OR REPLACE TABLE TDB.TRANSIENT_SCHEMA.new_table (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
  

ALTER TABLE TDB.TRANSIENT_SCHEMA.new_table
SET DATA_RETENTION_TIME_IN_DAYS  = 2

SHOW TABLES;

-- Temporary Tables
USE DATABASE PDB;

// Create permanent table 

CREATE OR REPLACE TABLE PDB.public.customers (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);


INSERT INTO PDB.public.customers
SELECT t1.* FROM OUR_FIRST_DB.public.customers t1



SELECT * FROM PDB.public.customers


// Create temporary table (with the same name)
CREATE OR REPLACE TEMPORARY TABLE PDB.public.customers (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);


// Validate temporary table is the active table
SELECT * FROM PDB.public.customers;

// Create second temporary table (with a new name)
CREATE OR REPLACE TEMPORARY TABLE PDB.public.temp_table (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);

// Insert data in the new table
INSERT INTO PDB.public.temp_table
SELECT * FROM PDB.public.customers

SELECT * FROM PDB.public.temp_table

SHOW TABLES;


