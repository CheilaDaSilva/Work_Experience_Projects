/* CLEANED AND COMPLETE DATASETS */




SELECT * FROM KPMGData..Transactions
WHERE brand IS NOT NULL AND online_order IS NOT NULL
AND customer_id BETWEEN 1 AND 4000


SELECT * FROM KPMGData..CustomerDemographic
WHERE last_name IS NOT NULL AND DOB IS NOT NULL
AND deceased_indicator = 'N'
-- already contains only customers 1 to 4,000 and removed deceased customers


SELECT * FROM KPMGData..CustomerAddress
WHERE customer_id BETWEEN 1 AND 4000
-- need to remove null addressed when joining due to missing customer addressed within the range 1 - 4,000




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


-- view merged tables
SELECT * FROM KPMG_Join_Datasets
ORDER BY transaction_id




/* RFM ANALYSIS */




/* CALCULATING RECENCY, FREQUENCY AND MONETARY VALUES */



