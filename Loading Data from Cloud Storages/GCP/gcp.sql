-- create integration object that contains the access information
CREATE STORAGE INTEGRATION gcp_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://bucket/path', 'gcs://bucket/path2');

  
-- Describe integration object to provide access
DESC STORAGE integration gcp_integration;

-- Create a file format object
CREATE OR REPLACE file format demo_db.public.fileformat_gcp
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 0;

-- Create stage object
CREATE OR REPLACE STAGE demo_db.public.stage_gcp
    STORAGE_INTEGRATION = gcp_integration
    URL = 'gcs://snowflakebucketgcp'
    FILE_FORMAT = fileformat_gcp;

---- Query files & Load data ----

--query files
SELECT 
$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,
$12,$13,$14,$15,$16,$17,$18,$19,$20
FROM @demo_db.public.stage_gcp;


create or replace table happiness (
    country_name varchar,
    regional_indicator varchar,
    ladder_score number(4,3),
    standard_error number(4,3),
    upperwhisker number(4,3),
    lowerwhisker number(4,3),
    logged_gdp number(5,3),
    social_support number(4,3),
    healthy_life_expectancy number(5,3),
    freedom_to_make_life_choices number(4,3),
    generosity number(4,3),
    perceptions_of_corruption number(4,3),
    ladder_score_in_dystopia number(4,3),
    explained_by_log_gpd_per_capita number(4,3),
    explained_by_social_support number(4,3),
    explained_by_healthy_life_expectancy number(4,3),
    explained_by_freedom_to_make_life_choices number(4,3),
    explained_by_generosity number(4,3),
    explained_by_perceptions_of_corruption number(4,3),
    dystopia_residual number (4,3));
    
    
COPY INTO HAPPINESS
FROM @demo_db.public.stage_gcp;

SELECT * FROM HAPPINESS;

-- Unload data
------- Unload data -----
USE ROLE ACCOUNTADMIN;
USE DATABASE DEMO_DB;


-- create integration object that contains the access information
CREATE STORAGE INTEGRATION gcp_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://snowflakebucketgcp', 'gcs://snowflakebucketgcpjson');
  
  
-- create file format
create or replace file format demo_db.public.fileformat_gcp
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1;

-- create stage object
create or replace stage demo_db.public.stage_gcp
    STORAGE_INTEGRATION = gcp_integration
    URL = 'gcs://snowflakebucketgcp/csv_happiness'
    FILE_FORMAT = fileformat_gcp
   -- compression = gzip | auto
    ;


ALTER STORAGE INTEGRATION gcp_integration
SET  storage_allowed_locations=('gcs://snowflakebucketgcp', 'gcs://snowflakebucketgcpjson')

SELECT * FROM HAPPINESS;

COPY INTO @stage_gcp
FROM
HAPPINESS;