--Time Travel
// Setting up table

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string)
    

-- Create a file_format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    type = csv
    field_delimiter = ','
    skip_header = 1

-- Create a stage
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    


LIST @MANAGE_DB.external_stages.time_travel_stage



COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv')


SELECT * FROM OUR_FIRST_DB.public.test

// Use-case: Update data (by mistake)

UPDATE OUR_FIRST_DB.public.test
SET FIRST_NAME = 'Joyen' 



// // // Using time travel: Method 1 - 2 minutes back
SELECT * FROM OUR_FIRST_DB.public.test at (OFFSET => -60*3.0)








// // // Using time travel: Method 2 - before timestamp
SELECT * FROM OUR_FIRST_DB.public.test before (timestamp => '2022-07-05 07:54:11.516'::timestamp)


-- Setting up table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);

COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');


SELECT * FROM OUR_FIRST_DB.public.test;


2022-07-05 07:54:11.516 +0000

-- Setting up UTC time for convenience


ALTER SESSION SET TIMEZONE ='UTC'
SELECT DATEADD(DAY, 1, CURRENT_TIMESTAMP)



UPDATE OUR_FIRST_DB.public.test
SET Job = 'Data Scientist'


SELECT * FROM OUR_FIRST_DB.public.test;

SELECT * FROM OUR_FIRST_DB.public.test before (timestamp => '2021-04-16 07:30:47.145'::timestamp)








// // // Using time travel: Method 3 - before Query ID

// Preparing table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Phone string,
  Job string)

COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv')


SELECT * FROM OUR_FIRST_DB.public.test


// Altering table (by mistake)
UPDATE OUR_FIRST_DB.public.test
SET EMAIL = null



SELECT * FROM OUR_FIRST_DB.public.test

SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01a5607f-0004-2569-0016-360700010452')


-- RESTORING DATA --
// Setting up table

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
    

COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');

SELECT * FROM OUR_FIRST_DB.public.test;

// Use-case: Update data (by mistake)


UPDATE OUR_FIRST_DB.public.test
SET LAST_NAME = 'Tyson';


UPDATE OUR_FIRST_DB.public.test
SET JOB = 'Data Analyst';

SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01a56090-0004-254e-0016-3607000150a6')



// // // Bad method

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01a56090-0004-2569-0016-3607000105aa')


SELECT * FROM OUR_FIRST_DB.public.test


CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01a56090-0004-254e-0016-3607000150a6')





// // // Good method -- Using a backup Table

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test_backup as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01a56097-0004-254e-0016-3607000150d6')

TRUNCATE OUR_FIRST_DB.public.test

INSERT INTO OUR_FIRST_DB.public.test
SELECT * FROM OUR_FIRST_DB.public.test_backup



SELECT * FROM OUR_FIRST_DB.public.test 

