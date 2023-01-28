/* RFM ANALYSIS */

/*
Finding high value customers amongst customers with transaction history
based on Recency, Frequency and Monetary scores
*/



/* JOIN TABLES */


-- Obtain customers 1 to 4,000 with transaction history which are to be considered in the segmentation
-- Include fields that will be needed for the RFM Analysis
-- deceased customers will be filtered out, as well as transactions to which we have no product or profit information (where brand is null)
-- could use the table used for PBI dashboard instead (view was named TransactionHistoryCurrentCustomers)


DROP VIEW IF EXISTS customers_for_rfm

CREATE VIEW customers_for_rfm
AS
SELECT
t.transaction_id ,t.product_id ,t.customer_id, d.full_name, t.transaction_date, t.days_since_transaction, t.profit
FROM KPMGData..Transactions t
	JOIN KPMGData..CustomerDemographic d ON t.customer_id = d.customer_id
WHERE 
-- filter out transactions columns with no information
t.brand IS NOT NULL 
AND t.online_order IS NOT NULL
AND t.customer_id BETWEEN 1 AND 4000
-- remove deceased customers
AND d.deceased_indicator != 'Y' 


-- view 
SELECT * FROM customers_for_rfm
ORDER BY transaction_id




/* CUSTOMER SEGMENTATION WITH RFM ANALYSIS */




/* CALCULATING RECENCY, FREQUENCY AND MONETARY VALUES */


/*
Recency - based on how recent the transaction occured 
	Score 4 = most recent (smaller numbers of days), 1 = least recent (highest number of days)
Frequency - based on how many transactions a customer has
	Score 4 = most frequent (highest numbers of transactions), 1 = least frequent (smaller number of transactions)
Monetary - based on how much profit the customer has generated for the company or how much they have spent
	Score 4 = most spent (highest profit generated ), 1 = least spent (lowest profit generated)

*/



-- Start by storing main columns used for calculating RFM value in table so we can add columns and calculate as necessary

DROP TABLE IF EXISTS KPMG_RFMAnalysis

CREATE TABLE KPMG_RFMAnalysis
(
customer_id INT
-- for recency score
, days_since_last_transaction INT
-- for frequency score
, total_transactions INT
-- for monetary score
, total_profit INT
)
INSERT INTO KPMG_RFMAnalysis
SELECT
DISTINCT(customer_id)
, MIN(days_since_transaction) as days_since_last_transaction
, COUNT(transaction_id) as total_transactions
, SUM(profit) as total_profit
FROM customers_for_rfm
GROUP BY customer_id
ORDER BY customer_id

-- view table
SELECT * FROM KPMG_RFMAnalysis



-- calculate quartiles for recency, frequency and monetary values

/* 
NOTE:
Recency, Frequency and Monetary Scores are valued 1 to 4
Highest Score is 4 = Most Recent (least days since last transaction); Most Frequent (highest number of transactions); Highest Monetary (highest profit margin)
Lowest Score is 1 = Least Recent (highest number of days since last transaction); Least Frequent (lowest number of transactions); Lowest Monetary (lowest profit margin)

So 1 to 4 scores go from the lowest to the highest quartiles of the fields we are looking at; 
EXCEPT for Recency where the lowest quartiles are the most recent
as such when using NTILE to find the values 1 to 4 we need the rfm_recency value to be the opposite
*/


-- calculate RFM value

DROP VIEW IF EXISTS RFM_Scores

CREATE VIEW RFM_Scores
as
SELECT customer_id, 
	     R_Score,
		 F_Score,
		 M_Score,
	     R_Score*100 + F_Score*10 + M_Score AS RFM_Value 
FROM (
      SELECT customer_id, 
			days_since_last_transaction,
			NTILE(4) OVER (ORDER BY days_since_last_transaction desc) AS R_Score,
			 -- order is reversed so that a high ntile number is assigned to the customers with the least days since last transaction
			 -- Recency: 4 = most recent = least days; 1 = least recent = most days
             NTILE(4) OVER (ORDER BY total_transactions) AS F_Score,
			 -- Frequency: 4 = most transactions/ most frequent; 1 = least transactions/ least frequent
             NTILE(4) OVER (ORDER BY total_profit) AS M_Score
			 -- Monetary: 4 = most profit; 1 = least profit
      FROM KPMG_RFMAnalysis
      ) AS final_rfm


-- view 
SELECT * FROM RFM_Scores a
JOIN KPMG_RFMAnalysis b ON a.customer_id = b.customer_id
ORDER BY a.customer_id

-- view recency segment

SELECT DISTINCT(R_Score), MIN(days_since_last_transaction) as min, MAX(days_since_last_transaction) as max, COUNT(a.customer_id) as customer_count
FROM RFM_Scores a
JOIN KPMG_RFMAnalysis b ON a.customer_id = b.customer_id
GROUP BY R_Score
ORDER BY R_Score asc

-- view frequency segment

SELECT DISTINCT(F_Score), MIN(total_transactions) as min, MAX(total_transactions) as max, COUNT(a.customer_id) as customer_count
FROM RFM_Scores a
JOIN KPMG_RFMAnalysis b ON a.customer_id = b.customer_id
GROUP BY F_Score
ORDER BY F_Score asc

-- view monetary segment
SELECT DISTINCT(M_Score), MIN(total_profit) as min, MAX(total_profit) as max, COUNT(a.customer_id) as customer_count
FROM RFM_Scores a
JOIN KPMG_RFMAnalysis b ON a.customer_id = b.customer_id
GROUP BY M_Score
ORDER BY M_Score asc



-- Rank customers based on RFM values and assign customer titles accordingly

DROP VIEW IF EXISTS KPMG_Customer_Ranks
CREATE VIEW KPMG_Customer_Ranks
AS
SELECT customer_id, RFM_Value
,NTILE(11) OVER(ORDER BY RFM_Value desc) as Customer_Rank
-- oder descending so that the higher RFM the lower the ntile number i.e. as RFM increases so does the customer rank
,CAST(
	CASE WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '1' THEN 'Champions'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '2' THEN 'Loyal Customers'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '3' THEN 'Potential Loyalists'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '4' THEN 'Recent Customers'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '5' THEN 'Promising'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '6' THEN 'Customer Needing Attention'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '7' THEN 'About to Sleep'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '8' THEN 'At Risk'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '9' THEN 'Cant Lose Them'
		 WHEN NTILE(11) OVER(ORDER BY RFM_Value desc) = '10' THEN 'Hibernating'
		 ELSE 'Lost'
		 END AS VARCHAR(100)
) AS Customer_Title
FROM RFM_Scores


-- view segmentation values

SELECT DISTINCT(Customer_Rank), Customer_Title, MIN(RFM_Value) as min_rfm, MAX(RFM_Value) as max_rfm, COUNT(customer_id) as customer_count
FROM KPMG_Customer_Ranks
GROUP BY Customer_Rank, Customer_Title
ORDER BY Customer_Rank


-- view current customers rank and titles

SELECT * FROM KPMG_Customer_Ranks
ORDER BY customer_id

-- highest ranks = high target customers





/* testing another way */
/* segment customers in 4 groups based on RFM */


DROP VIEW IF EXISTS KPMG_Customers_Ranks_test

CREATE VIEW KPMG_Customers_Ranks_test
AS
SELECT customer_id, RFM_Value
,NTILE(4) OVER(ORDER BY RFM_Value desc) as rank_test -- low number = higher rank (i.e top customers have rank 1)
,CAST(CASE WHEN NTILE(4) OVER(ORDER BY RFM_Value desc) = '1' THEN 'Platinum'
		   WHEN NTILE(4) OVER(ORDER BY RFM_Value desc) = '2' THEN 'Gold'
		   WHEN NTILE(4) OVER(ORDER BY RFM_Value desc) = '3' THEN 'Silver'
		   ELSE 'Bronze'
		END AS VARCHAR(50)
		) AS title_test
FROM RFM_Scores

SELECT * FROM KPMG_Customers_Ranks_test
ORDER BY customer_id

SELECT DISTINCT(rank_test), title_test , MIN(RFM_Value) as min_rfm, MAX(RFM_Value) as max_rfm, COUNT(customer_id) as customer_count
FROM KPMG_Customers_Ranks_test
GROUP BY rank_test, title_test
ORDER BY rank_test

