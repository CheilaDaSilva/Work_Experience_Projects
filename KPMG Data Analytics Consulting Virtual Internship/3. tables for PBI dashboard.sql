/* TABLE: TRANSACTION HISTORY FOR CURRENT CUSTOMERS */

/* complete transaction history merged with customer demographic and address information */



-- DROP VIEW IF EXISTS TransactionHistoryCurrentCustomers

CREATE VIEW TransactionHistoryCurrentCustomers
AS
SELECT
t.transaction_id ,t.product_id ,t.customer_id , t.transaction_date, t.days_since_transaction, t.online_order ,t.order_status ,t.brand ,t.product_line
,t.product_class ,t.product_size ,t.list_price ,t.standard_cost ,t.profit
,t.product_first_sold_date_converted AS product_first_sold_date
,d.full_name ,d.gender ,d.past_3_years_bike_related_purchases ,d.age ,d.age_group
,d.job_title ,d.job_industry_category, d.wealth_segment, d.owns_car, d.tenure
,a.address ,a.postcode ,a.state ,a.country ,a.property_valuation
FROM KPMGData..Transactions t
	JOIN KPMGData..CustomerDemographic d ON t.customer_id = d.customer_id
	JOIN KPMGData..CustomerAddress a ON d.customer_id = a.customer_id
WHERE 
-- filter out transactions columns with no information
t.brand IS NOT NULL 
AND t.online_order IS NOT NULL
AND t.customer_id BETWEEN 1 AND 4000
-- remove deceased customers
AND d.deceased_indicator != 'Y' 


-- Summary Statistics ---- total transactions: 19,408; total customers: 3,486; range of ids: 1 - 3,500
SELECT COUNT(DISTINCT(transaction_id)) as total_transactions, COUNT(DISTINCT(customer_id)) as total_customers 
, MIN(customer_id) as min_id, MAX(customer_id) as max_id FROM TransactionHistoryCurrentCustomers


-- view and extract table
SELECT * FROM TransactionHistoryCurrentCustomers
ORDER BY transaction_id






/* TABLE: ALL CUSTOMERS (NEW & CURRENT) */

/* appending the the new customer list dataset to current customers demographics and address dataset for simplify process of comparison */



-- create column in CustomerDemographic and NewCustomerList to store the type of customer (new or current)

ALTER TABLE KPMGData..CustomerDemographic
ADD customer_type VARCHAR(25)

-- all in the dataset are 'current' customers
UPDATE KPMGData..CustomerDemographic
SET customer_type = 'current'


ALTER TABLE KPMGData..NewCustomerList
ADD customer_type VARCHAR(25)

-- all in the dataset are 'new' customers
UPDATE KPMGData..NewCustomerList
SET customer_type = 'new'



-- I will use customer_id to relate the tables, as it is unique to each customer
-- current customers have ids 1 to 4,000 (due to restrictions applied) hence I assign new customers to have id's from 4,001 forward

ALTER TABLE KPMGData..NewCustomerList
ADD customer_id INT IDENTITY(4001,1)

-- view tables 

SELECT customer_id, full_name, customer_type FROM KPMGData..CustomerDemographic
SELECT customer_id, full_name, customer_type FROM KPMGData..NewCustomerList

-- current customers: 1 to 4,000; new customers: 4,001 to 5,000


-- append tables to obtain a list of all customers (new & current) including demographic and address information


--DROP VIEW IF EXISTS AllCustomers

CREATE VIEW AllCustomers
AS
SELECT 
c.customer_type, c.customer_id, c.full_name, c.gender, c.past_3_years_bike_related_purchases, 
c.job_title, c.job_industry_category, c.wealth_segment, c.owns_car, c.tenure, c.age, c.age_group, 
a.address, a.country, a.postcode, a.property_valuation, a.state
FROM KPMGData..CustomerDemographic c
JOIN KPMGData..CustomerAddress a ON c.customer_id = a.customer_id
        WHERE c.deceased_indicator != 'Y'
	AND c.customer_id IN (
		SELECT DISTINCT(customer_id) FROM KPMGData..Transactions
		WHERE 
		brand IS NOT NULL 
		AND online_order IS NOT NULL
		AND customer_id BETWEEN 1 AND 4000
 )
UNION ALL 
SELECT customer_type, customer_id, full_name, gender, past_3_years_bike_related_purchases, 
job_title, job_industry_category, wealth_segment, owns_car, tenure, age, age_group,
address, country, postcode, property_valuation, state
FROM KPMGData..NewCustomerList 
WHERE deceased_indicator != 'Y'


-- summary statistics ---- new customer count: 1000; current customers count: 3486
SELECT DISTINCT(customer_type), COUNT(customer_id) AS customer_count FROM AllCustomers
GROUP BY customer_type


-- view and extract table
SELECT * FROM AllCustomers
ORDER BY customer_id





/*
note:
for data exploration I will later be filtering out null values for gender, dob, etc in the individual graphs created
goal is to understand the broader markets to target i.e. need to understand who is purchasing
*/
