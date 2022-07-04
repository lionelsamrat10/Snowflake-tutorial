-- Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
  );

-- Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;

-- Create storage integration object

create or replace storage integration s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::771874824822:role/snowflake-access-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://snowflakes3bucket123-samrat/csv/', 's3://snowflakes3bucket123-samrat/json/', 's3://snowflakes3bucket123-samrat/csv/snowpipe')
   COMMENT = 'This is my first Integration Object' 
   
-- See storage integration properties to fetch external_id so we can update it in S3
DESC integration s3_int;

-- Create stage object with integration object & file format object
CREATE OR REPLACE stage MANAGE_DB.external_stages.csv_folder
    URL = 's3://snowflakes3bucket123-samrat/csv/snowpipe'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat

-- List the files in the stage area
LIST @MANAGE_DB.external_stages.csv_folder

-- Create a Schema for keeping the pipes
-- Create schema to keep things organized
CREATE OR REPLACE SCHEMA MANAGE_DB.pipes

-- Define pipe
CREATE OR REPLACE pipe MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees
FROM @MANAGE_DB.external_stages.csv_folder  

-- Describe pipe
DESC pipe employee_pipe
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.employees    


-- Handling errors


-- Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.employees   

ALTER PIPE employee_pipe refresh
 
-- Validate pipe is actually working
SELECT SYSTEM$PIPE_STATUS('employee_pipe')

-- Snowpipe error message
SELECT * FROM TABLE(VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'MANAGE_DB.pipes.employee_pipe',
    START_TIME => DATEADD(HOUR,-2,CURRENT_TIMESTAMP())))

-- COPY command history from table to see error massage

SELECT * FROM TABLE (INFORMATION_SCHEMA.COPY_HISTORY(
   table_name  =>  'OUR_FIRST_DB.PUBLIC.EMPLOYEES',
   START_TIME =>DATEADD(HOUR,-2,CURRENT_TIMESTAMP())))
   
-- Manage pipes -- 

DESC pipe MANAGE_DB.pipes.employee_pipe;

SHOW PIPES;

SHOW PIPES like '%employee%'

SHOW PIPES in database MANAGE_DB

SHOW PIPES in schema MANAGE_DB.pipes

SHOW PIPES like '%employee%' in Database MANAGE_DB



-- Changing pipe (alter stage or file format) --

-- Preparation table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees2 (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
  )


-- Pause pipe
ALTER PIPE MANAGE_DB.pipes.employee_pipe SET PIPE_EXECUTION_PAUSED = true
 
 
-- Verify pipe is paused and has pendingFileCount 0 
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe') 
 
-- Recreate the pipe to change the COPY statement in the definition
CREATE OR REPLACE pipe MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees2
FROM @MANAGE_DB.external_stages.csv_folder  

ALTER PIPE  MANAGE_DB.pipes.employee_pipe refresh

-- List files in stage
LIST @MANAGE_DB.external_stages.csv_folder  

SELECT * FROM OUR_FIRST_DB.PUBLIC.employees2

-- Reload files manually that where aleady in the bucket
COPY INTO OUR_FIRST_DB.PUBLIC.employees2
FROM @MANAGE_DB.external_stages.csv_folder  


-- Resume pipe
ALTER PIPE MANAGE_DB.pipes.employee_pipe SET PIPE_EXECUTION_PAUSED = false

-- Verify pipe is running again
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe') 
