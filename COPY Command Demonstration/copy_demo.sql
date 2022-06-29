-- Creating ORDERS Table

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

SELECT * FROM "OUR_FIRST_DB"."PUBLIC"."ORDERS";

-- First Copy Command
COPY INTO "OUR_FIRST_DB"."PUBLIC"."ORDERS"
    FROM @aws_stage
    file_format = (type = csv field_delimiter = ',' skip_header = 1); 
    
-- Copy command with fully qualified stage object

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1); --Not working because there is multiple file in our extarnal staging area
    
-- We can list the files in the staging area
LIST @MANAGE_DB.external_stages.aws_stage;

-- Now we have to mention the specific file

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails.csv');

-- Copy command with pattern for file names

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';
