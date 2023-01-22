-- after cleaning data with sql (https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/cleaning%20data%20with%20SQL.sql)



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

-- IMPORTANT: I am calculating age as of the 10 jan 2018 just to better reflect the age of the customers during the time period of transaction history
-- The function divides by 365.25 to allow for leap years and uses the FLOOR function to make sure the function returns an integer.

SELECT customer_id, DOB, FLOOR(DATEDIFF(DAY, DOB, '2018-01-10')/365.25) AS age
FROM KPMGData..CustomerDemographic
ORDER BY customer_id

-- update table

UPDATE KPMGData..CustomerDemographic
SET age = FLOOR(DATEDIFF(DAY, DOB, '2018-01-10')/365.25)

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
	     WHEN age < 20 THEN '<20'
		 WHEN age >= 20 AND age < 30 THEN '20s'
		 WHEN age >= 30 AND age < 40 THEN '30s' 
		 WHEN age >= 40 AND age < 50 THEN '40s'
		 WHEN age >= 50 AND age < 60 THEN '50s'
		 WHEN age >= 60 AND age < 69 THEN '60s'
			ELSE '> 69'
	END AS varchar
) AS age_group_test
FROM KPMGData..CustomerDemographic

-- update table
UPDATE KPMGData..CustomerDemographic 
SET age_group = 
(
	CASE WHEN age IS NULL THEN NULL
	     WHEN age < 20 THEN '<20'
		 WHEN age >= 20 AND age < 30 THEN '20s'
		 WHEN age >= 30 AND age < 40 THEN '30s' 
		 WHEN age >= 40 AND age < 50 THEN '40s'
		 WHEN age >= 50 AND age < 60 THEN '50s'
		 WHEN age >= 60 AND age < 69 THEN '60s'
			ELSE '> 69'
END
) 

-- view table
SELECT customer_id, age, age_group FROM KPMGData..CustomerDemographic
ORDER BY customer_id





/* ADD 'FULL NAME', 'AGE' AND 'AGE GROUP' TO 'NEW CUSTOMER LIST' DATASET - FOR LATER COMPARISON OF DISTRIBUTIONS etc */



-- create columns
ALTER TABLE KPMGData..NewCustomerList
ADD full_name VARCHAR(200), age INT, age_group VARCHAR(10)

-- use same formulas/calculations as above

-- update table

UPDATE KPMGData..NewCustomerList
SET full_name = CONCAT(first_name,' ', last_name)

UPDATE KPMGData..NewCustomerList
SET age = FLOOR(DATEDIFF(DAY, DOB, '2018-01-10')/365.25)

UPDATE KPMGData..NewCustomerList
SET age_group = 
(
	CASE WHEN age IS NULL THEN NULL
	     WHEN age < 20 THEN '<20'
		 WHEN age >= 20 AND age < 30 THEN '20s'
		 WHEN age >= 30 AND age < 40 THEN '30s' 
		 WHEN age >= 40 AND age < 50 THEN '40s'
		 WHEN age >= 50 AND age < 60 THEN '50s'
		 WHEN age >= 60 AND age < 69 THEN '60s'
			ELSE '> 69'
END
) 

-- view table
SELECT first_name, last_name, full_name, age, age_group FROM KPMGData..NewCustomerList




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




/* ADD THE NUMBER OF DAYS SINCE THE 'TRANSACTIONS' TABLE */
-- will need it later for the RFM analysis 

-- create column to store value
ALTER TABLE KPMGData..Transactions
ADD days_since_transaction INT

-- calculate field
-- consider since 2017-12-30 as its the last day of transaction history
SELECT transaction_date,
DATEDIFF(DAY, transaction_date, '2017-12-30') as days_since_purchase
FROM KPMGData..Transactions
group by transaction_date
order by transaction_date desc

-- update table
UPDATE KPMGData..Transactions
SET days_since_transaction = FLOOR(DATEDIFF(DAY, transaction_date, '2017-12-30'))

-- view data
SELECT customer_id, transaction_id, transaction_date, days_since_transaction
FROM KPMGData..Transactions
ORDER BY transaction_date desc



