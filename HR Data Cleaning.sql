CREATE DATABASE projects;

USE projects;

SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

SELECT birthdate FROM hr;

SET sql_safe_updates =0;

UPDATE hr
SET birthdate = CASE
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE
WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- 1. Allow invalid dates (set mode first)
SET sql_mode = 'ALLOW_INVALID_DATES';

-- 2. Update termdate: convert to DATE or set to '0000-00-00'
UPDATE hr
SET termdate = 
  CASE 
    WHEN termdate IS NOT NULL AND termdate != '' THEN DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
    ELSE '0000-00-00'
  END;

-- 3. Alter the column to proper DATE type
ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- 1. Add an 'age' column
ALTER TABLE hr ADD COLUMN age INT;

-- 2. Populate the 'age' column
UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

-- 3. Query the youngest and oldest
SELECT
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age <18;

