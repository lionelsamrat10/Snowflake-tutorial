CREATE OR REPLACE DATABASE EXERCISE_DB;

CREATE OR REPLACE TABLE EXERCISE_DB.PUBLIC.CUSTOMER (
    ID INT,
    first_name varchar,
    last_name varchar,
    email varchar,
    age int,
    city varchar
);

-- create stage object
CREATE OR REPLACE STAGE EXERCISE_DB.public.aws_stage
    url='s3://snowflake-assignments-mc/fileformat';

-- List files in stage
LIST @EXERCISE_DB.public.aws_stage;

-- create file format object
CREATE OR REPLACE FILE FORMAT EXERCISE_DB.public.aws_fileformat
TYPE = CSV
FIELD_DELIMITER='|'
SKIP_HEADER=1;

-- Load the data 
COPY INTO EXERCISE_DB.PUBLIC.CUSTOMER
    FROM @aws_stage
      file_format= (FORMAT_NAME=EXERCISE_DB.public.aws_fileformat)

SELECT * FROM EXERCISE_DB.PUBLIC.CUSTOMER;