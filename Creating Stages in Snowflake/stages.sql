-- Database to manage stage objects, fileformats etc.
CREATE OR REPLACE DATABASE MANAGE_DB;

-- Create a Schema
CREATE OR REPLACE SCHEMA external_stages;

-- Creating an external stage
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url = 's3://bucketsnowflakes3'
    credentials = (aws_key_id = 'ABCD_DUMMY_ID' aws_secret_key = '1234abcd_key');

-- Description of the external stage
DESC STAGE MANAGE_DB.external_stages.aws_stage;

-- Alter the external stage
ALTER STAGE aws_stage
    SET credentials = (aws_key_id = 'XYZ_DUMMY_ID' aws_secret_key = '987xyz');
    
-- Publicly available Staging area
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url = 's3://bucketsnowflakes3';
    
-- List files in stage
LIST @aws_stage;