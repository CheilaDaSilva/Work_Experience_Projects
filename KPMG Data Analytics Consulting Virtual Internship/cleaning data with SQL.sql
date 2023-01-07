/* create database and import datasets */

CREATE DATABASE KPMGData



/* VIEW INITIAL TABLES */

SELECT * FROM KPMGData..Transactions

SELECT * FROM KPMGData..CustomerDemographic

SELECT * FROM KPMGData..CustomerAddress




/* SUMMARY STATISTICS */




/* Number of records */

SELECT COUNT(transaction_id) FROM KPMGData..Transactions
-- 20,000
SELECT COUNT(customer_id) FROM KPMGData..CustomerDemographic
-- 4,000
SELECT COUNT(customer_id) FROM KPMGData..CustomerAddress
-- 3,999


/* distinct customer ids */

SELECT COUNT(DISTINCT(customer_id)) FROM KPMGData..Transactions
-- 3,494
SELECT COUNT(DISTINCT(customer_id)) FROM KPMGData..CustomerDemographic
-- 4,000
SELECT COUNT(DISTINCT(customer_id)) FROM KPMGData..CustomerAddress
-- 3,999


/* Range of customer ids */

SELECT MIN(customer_id) AS min_id, MAX(customer_id) AS max_id FROM KPMGData..Transactions
-- 1 to 5,034
SELECT MIN(customer_id) AS min_id, MAX(customer_id) AS max_id FROM KPMGData..CustomerDemographic
-- 1 to 4,000
SELECT MIN(customer_id) AS min_id, MAX(customer_id) AS max_id FROM KPMGData..CustomerAddress
-- 1 to 4,003
-- will need to filter out null values when joining to remove customer ids that have no address data


-- will be focusing on customers id 1 - 4,000 for consistency




/* CLEANING THE 'TRANSACTIONS' DATASET */




/* transform 'product_first_sold_date' to DATE format */

/* 
note:
Need to convert field's data type from FLOAT to DATE.
Convertion from FLOAT to DATE is not allowed so we do: FLOAT to DATETIME to DATE

In Excel converting a number to date will count the days since 1900-01-01 but in SQL it starts from 1899-12-30
Therefore we need to account for the 2 days difference when converting to date in SQL, since the original data source is from Excel
*/


-- calculate date based on number value

SELECT product_first_sold_date, CONVERT(date, CONVERT(datetime, product_first_sold_date - 2)) AS product_first_sold_date_converted
FROM KPMGData..Transactions

-- create field to store transformation and update table

ALTER TABLE KPMGData..Transactions ADD product_first_sold_date_converted DATE

UPDATE KPMGData..Transactions 
SET product_first_sold_date_converted = CONVERT(date, CONVERT(datetime, product_first_sold_date - 2))

-- view converted date

SELECT transaction_id, product_first_sold_date_converted 
FROM KPMGData..Transactions
ORDER BY transaction_id




/* format 'list_price' to have 'money' like the 'standard_cost' field */

ALTER TABLE KPMGData..Transactions
ALTER COLUMN list_price MONEY




/* CLEANING 'CUSTOMER ADDRESS' DATASET */




/* Fix categorical values in the 'State' field */


-- view categories

SELECT DISTINCT(State) FROM KPMGData..CustomerAddress

-- update values

UPDATE KPMGData..CustomerAddress
SET State = 'VIC' WHERE State = 'Victoria'

UPDATE KPMGData..CustomerAddress
SET State = 'NSW' WHERE State = 'New South Wales'




/* CLEANING 'CUSTOMER DEMOGRAPHICS' DATASET */




/*
note:
in the quality assessment a DOB with year 1843 was detected but it has been imported as NULL in SQL
so there is no need to change anything in DOB field
*/


/* Convert DOB from datetime to date (remove time) */

ALTER TABLE KPMGData..CustomerDemographic
ALTER COLUMN DOB DATE


/* Fix categorical values in the 'Gender' field */


-- view categories

SELECT DISTINCT(gender) FROM KPMGData..CustomerDemographic

-- update values (keep F, M and U)

UPDATE KPMGData..CustomerDemographic
SET gender = 'F' WHERE gender = 'Female' OR gender = 'Femal'

UPDATE KPMGData..CustomerDemographic
SET gender = 'M' WHERE gender = 'Male'


/* remove unecessary 'default' column - it provides no information about customers */

ALTER TABLE KPMGData..CustomerDemographic DROP COLUMN [default]

/* detect deceased customers */

SELECT * FROM KPMGData..CustomerDemographic
WHERE deceased_indicator = 'Y'
-- 2 customers so we will filter out later on




/* ENSURING COMPLETENESS OF DATA */




/* investigating occurrence of NULL values */


/* 
CustomerDemographic table: 
Columns with NULL values: 'last name'; 'DOB'; 'job title'; tenure
*/


-- For'job title' - substitute NULL values by 'n/a'; same notation was already being used in the 'job industry' field

-- update field

UPDATE KPMGData..CustomerDemographic 
SET job_title = 'n/a' WHERE job_title IS NULL

-- view job titles

SELECT DISTINCT(job_title) FROM KPMGData..CustomerDemographic 


-- Looking at customers with no last_name

SELECT COUNT(customer_id) FROM KPMGData..CustomerDemographic
WHERE last_name IS NULL
-- 3.13% of records without last_name

SELECT first_name, COUNT(customer_id) as occurrences FROM KPMGData..CustomerDemographic
WHERE last_name IS NULL
GROUP BY first_name
having COUNT(customer_id) > 1
-- there are 2 first_names (with no last_name) that have duplicates so it could affect segmentation
-- for completeness, customers with missing last_names will be filtered out

-- Looking at customers with no date of birth details

SELECT COUNT(customer_id) FROM KPMGData..CustomerDemographic
WHERE DOB IS NULL
-- 88 records with no date of birth - filter out for completeness

-- Looking at customers with no 'tenure' field values

SELECT * FROM KPMGData..CustomerDemographic
WHERE tenure IS NULL
-- tenure is null when DOB is also null so it will be filtered out along with the null DOBs


-- Filtering out all NULL values from Customer Demographics
SELECT * FROM KPMGData..CustomerDemographic
WHERE last_name IS NOT NULL AND DOB IS NOT NULL
 



/* 
Transactions table:
Columns with NULL values: 'online order'; 'brand'; 'product line'; 'product class'; 'product size'; 'standard cost'; 'product first sold date'	

Only when 'brand' is missing do other fields regarding product details are NULL (apart from 'list_price') 
*/


-- Looking at transactions with no 'brand' information

SELECT * FROM KPMGData..Transactions
WHERE brand IS NOT NULL
-- table does not show null values, apart from 'online order', when the 'brand' field has values

SELECT * FROM KPMGData..Transactions
WHERE brand IS NULL
-- all product details appear as NULL values 
-- it accounts for 0.985% of total records - small percentage so we filter out for completeness


-- Looking at transactions with NULL 'online order' field

SELECT * FROM KPMGData..Transactions
WHERE online_order IS NULL
-- 1.80% of total records - filter out for completeness 


-- Filtering out all NULL values from the Transactions table
SELECT * FROM KPMGData..Transactions
WHERE brand IS NOT NULL AND online_order IS NOT NULL




/* Filtered datasets with only customer 1-4,000 for consistency */


SELECT * FROM KPMGData..Transactions
WHERE brand IS NOT NULL AND online_order IS NOT NULL
AND customer_id BETWEEN 1 AND 4000

SELECT * FROM KPMGData..CustomerDemographic
WHERE last_name IS NOT NULL AND DOB IS NOT NULL
AND deceased_indicator = 'N'
-- already contains only customers 1 to 4,000 and removed deceased customers

SELECT * FROM KPMGData..CustomerAddress
WHERE customer_id BETWEEN 1 AND 4000




/* customers 1 to 4,000 with no address information */

SELECT * FROM KPMGData..CustomerDemographic
WHERE customer_id NOT IN
(SELECT distinct(customer_id) FROM KPMGData..CustomerAddress)
-- when joining tables we will filter these out by removing NULL addresses




/* ADDING SOME EXTRA FIELDS FOR INSIGHTS */




/* ADD FULL NAME FIELD TO 'CUSTOMER DEMOGRAPHICS' DATASET */


-- create column 'full name'
ALTER TABLE KPMGData..CustomerDemographic
ADD full_name VARCHAR(150)

-- concatenate first_name and last_name
SELECT first_name, last_name, CONCAT(first_name,' ', last_name) as full_name_test FROM KPMGData..CustomerDemographic

-- update table
UPDATE KPMGData..CustomerDemographic
SET full_name = CONCAT(first_name,' ', last_name)

-- view table
SELECT customer_id, first_name, last_name, full_name FROM KPMGData..CustomerDemographic
ORDER BY customer_id




/* ADD AGE FIELD TO 'CUSTOMER DEMOGRAPHICS' DATASET */


-- create column 'age'

ALTER TABLE KPMGData..CustomerDemographic
ADD age INT

-- calculate 'age' based on 'DOB' using SQL Date functions
-- The function divides by 365.25 to allow for leap years and uses the FLOOR function to make sure the function returns an integer.

SELECT customer_id, DOB, FLOOR(DATEDIFF(DAY, DOB, GETDATE())/365.25) AS age
FROM KPMGData..CustomerDemographic
ORDER BY customer_id

-- update table

UPDATE KPMGData..CustomerDemographic
SET age = FLOOR(DATEDIFF(DAY, DOB, GETDATE())/365.25)

-- view table

SELECT customer_id, first_name, last_name, DOB, age FROM KPMGData..CustomerDemographic
WHERE last_name IS NOT NULL AND DOB IS NOT NULL




/* ADD AGE GROUP FIELD TO 'CUSTOMER DEMOGRAPHICS' DATASET */


-- create column 'age group'
ALTER TABLE KPMGData..CustomerDemographic
ADD age_group VARCHAR(10)

-- obtain age group
SELECT customer_id, age
, CAST(
	CASE WHEN age IS NULL THEN NULL
	     WHEN age < 30 THEN '< 30'
		 WHEN age >= 30 AND age < 40 THEN '30 - 39'
		 WHEN age >= 30 AND age < 40 THEN '30 - 39'
		 WHEN age >= 40 AND age < 50 THEN '40 - 49'
		 WHEN age >= 50 AND age < 60 THEN '50 - 59'
		 WHEN age >= 60 AND age < 69 THEN '60 - 69'
			ELSE '> 69'
	END AS varchar
) AS age_group_test
FROM KPMGData..CustomerDemographic

-- update table
UPDATE KPMGData..CustomerDemographic 
SET age_group = 
(
CASE WHEN age IS NULL THEN NULL
	 WHEN age < 30 THEN '< 30'
	 WHEN age >= 30 AND age < 40 THEN '30 - 39'
	 WHEN age >= 30 AND age < 40 THEN '30 - 39'
	 WHEN age >= 40 AND age < 50 THEN '40 - 49'
	 WHEN age >= 50 AND age < 60 THEN '50 - 59'
	 WHEN age >= 60 AND age < 69 THEN '60 - 69'
   	 ELSE '> 69'
END
) 

-- view table
SELECT customer_id, age, age_group FROM KPMGData..CustomerDemographic




/* ADD PROFIT FIELD TO 'TRANSACTIONS' DATASET */


-- create column 'profit'
ALTER TABLE KPMGData..Transactions
ADD profit MONEY

-- calculate profit
SELECT list_price, standard_cost, (list_price - standard_cost) as profit
FROM KPMGData..Transactions
order by transaction_id

-- update table
UPDATE KPMGData..Transactions
SET profit = (list_price - standard_cost)

-- view table
SELECT transaction_id, list_price, standard_cost, profit FROM KPMGData..Transactions
ORDER BY transaction_id




/* JOIN TABLES */





/* create view to store the joint - with quality issues fixed and null values filtered */

DROP VIEW IF EXISTS KPMG_Join_Datasets 

CREATE VIEW KPMG_Join_Datasets 
AS 
SELECT
t.transaction_id ,t.product_id ,t.customer_id ,t.online_order ,t.order_status ,t.brand ,t.product_line
,t.product_class ,t.product_size ,t.list_price ,t.standard_cost ,t.profit
,t.product_first_sold_date_converted AS product_first_sold_date
,d.full_name ,d.gender ,d.past_3_years_bike_related_purchases ,d.age ,d.age_group
,d.job_title ,d.job_industry_category
,a.address ,a.postcode ,a.state ,a.country ,a.property_valuation
FROM KPMGData..Transactions t
	JOIN KPMGData..CustomerDemographic d ON t.customer_id = d.customer_id
	JOIN KPMGData..CustomerAddress a ON d.customer_id = a.customer_id
WHERE 
t.brand IS NOT NULL 
AND t.online_order IS NOT NULL
AND t.customer_id BETWEEN 1 AND 4000
AND d.last_name IS NOT NULL 
AND d.DOB IS NOT NULL
AND d.deceased_indicator != 'Y'
AND a.address IS NOT NULL --to remove customers with no address information

-- view joint table
SELECT * FROM KPMG_Join_Datasets
ORDER BY transaction_id
