CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
    
// Stage and file format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    type = csv
    field_delimiter = ','
    skip_header = 1
    
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    
LIST  @MANAGE_DB.external_stages.time_travel_stage;


// Copy data and insert in table
COPY INTO OUR_FIRST_DB.public.customers
FROM @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');


SELECT * FROM OUR_FIRST_DB.public.customers;

-- Create the clone of the Customers table
CREATE TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE
CLONE OUR_FIRST_DB.public.customers;

-- validate the data
SELECT * FROM OUR_FIRST_DB.public.customers_clone;

-- Update the cloned table
UPDATE OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE
SET LAST_NAME = NULL;

SELECT * FROM OUR_FIRST_DB.public.customers_clone; -- Only change in the Cloned table

SELECT * FROM OUR_FIRST_DB.public.customers; -- No change took place in the original table

SHOW TABLES IN OUR_FIRST_DB.PUBLIC;

-- Trying to clone Temporary Tables
CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TEMP_TABLE (id INT)

-- Try cloning to Permanent Table
CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TEMP_TABLE_CLONE
CLONE OUR_FIRST_DB.PUBLIC.TEMP_TABLE;

// Cloning Schema
CREATE TRANSIENT SCHEMA OUR_FIRST_DB.COPIED_SCHEMA
CLONE OUR_FIRST_DB.PUBLIC;

SELECT * FROM COPIED_SCHEMA.CUSTOMERS

-- Cloning Stage objects
CREATE TRANSIENT SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED
CLONE MANAGE_DB.EXTERNAL_STAGES;



// Cloning Database
CREATE TRANSIENT DATABASE OUR_FIRST_DB_COPY
CLONE OUR_FIRST_DB;

DROP DATABASE OUR_FIRST_DB_COPY
DROP SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED
DROP SCHEMA OUR_FIRST_DB.COPIED_SCHEMA
