# 💻 KPMG Data Consulting Virtual Internship with Forage

![banner](https://user-images.githubusercontent.com/88495091/215600105-cc565ceb-4545-4620-9e13-6c208497a18e.png)

Virtual Experience Program Participant | [Program Details](https://www.theforage.com/virtual-internships/theme/m7W4GMqeT3bh9Nb2c/KPMG-Data-Analytics-Virtual-Internship) | [Certificate](https://insidesherpa.s3.amazonaws.com/completion-certificates/KPMG/m7W4GMqeT3bh9Nb2c_KPMG_pHMgyJ6PB3ENxLgKb_completion_certificate.pdf)

# Project Overview
## Tasks Covered
- Data Quality Assessment: Assessment of data quality and completeness in preparation for analysis.
	- Skills: Data Quality Analysis; Analytical Dashboard Creation.
- Data Insights: Targeting high value customers based on customer demographics and attributes.
	- Skills: Data Analytics; Customer Segmentation; Data Driven Presentation.
- Data Insights and Presentation: Using visualisations to present insights.
	- Skills: Data Dashboards; Data Visualisation; Presentation.

## The Client: Sprocket Central Pty Ltd
Sprocket Central is a medium-size company/organisation that sells bicycles and accessories. The client is looking to expand into a new market and needs help with its customer and transaction data. 

## Datasets
The client has a large dataset relating to its customers but their team is unsure how to effectively analyse it to help optimise its marketing strategy.

“The importance of optimising the quality of customer datasets cannot be underestimated. The better the quality of the dataset, the better chance you will be able to use it to drive company growth.”

Client provided KPMG with 3 datasets regarding their current customers and transaction history of the year 2017:
- Customer Demographic; 
- Customer Addresses; 
- Transactions data.

An additional dataset was provided with a list of 1000 new customers:
- New Customer List

## Project Goals

The purpose of the project is to:
- Analyse the client's existing customers and transaction history to determine customer trends and behaviours.
- Specify who Spocket Central's marketing team should be targeting out of the new 1000 customer list as well as the broader market segment to reach out to.

## Project Approach and Results

The [Data Analytics Approach](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fraw.githubusercontent.com%2FCheilaDaSilva%2FWork_Experience_Projects%2Fmain%2FKPMG%2520Data%2520Analytics%2520Consulting%2520Virtual%2520Internship%2FData%2520Analytics%2520Approach.pptx&wdOrigin=BROWSELINK) presentation details the approach taken to achieve the project goals as well as the presentation of results and its interpretation. Below is a snip of this presentation with the overall steps taken:

![snip from presentation](https://user-images.githubusercontent.com/88495091/216684629-cec66dd6-1ed7-4679-80ff-ece185cbe030.png)

# Task 1 - Data Quality Assessment and Actions taken

Overview of the steps taken to analyse the quality of the datasets and transformation that have been done to the datasets as a result.

Steps:
- Conducted a quality assessment of the datasets based on the Standard Data Quality Dimensions Framework (checked Accuracy, Completeness, Consistency, Currency, Relevancy, Validity and Uniqueness)
- [Cleaned Data With SQL](https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/cleaning%20data%20with%20SQL.sql): Data was transformed; inconsistent formats and categorical labels were fixed.
- Recommended mitigation methods and implement it to create a training dataset for data exploration and model development.

<table>
  <tbody>
    <tr>
      <th align="center">Tables</th>
      <th align="center">Issues Found</th>
      <th align="center">Mitigation/Action</th>
    </tr>
    <tr>
      <td align="center">Transactions</td>
      <td align="left">
              <li>NULL values across various columns (online order; brand; product line; product class; product size; standard cost; product first sold date)</li>
              <li>Customer IDs not in the customer demographics table</li>
		    <li>Inconsistent formats: product_first_sold_date as a number instead of date</li>
      </td>
      <td align="left">
              <li>Transformed product_first_sold_date to DATE format;</li>
              <li>Filtered out NULL values across all columns and  customers not present in the Customer Demographics table;</li>
      </td>
    </tr>
    <tr>
      <td align="center">Customer Demographics</td>
      <td align="left">
	      <li>DOB with year 1843 found</li>
	      <li>NULL values across various columns (last name; DOB; job title) and duplicated first names where last_name is NULL which could affect segmentation of data </li>
	      <li>'default' column provides no information</li>
	      <li> Inconsistent categorical labels in the gender column</li>
      </td>
      <td align="left">
	      <li>Fixed Gender column categorical labels;</li>
	      <li>Transformed DOB to DATE format;</li>
	      <li>Set NULL job_titles to n/a, matching the job_title_category label for null values;</li>
	      <li>Removed inaccurate date of births;</li>
	      <li>Removed the ‘default’ column;</li>
	      <li>Filtered out NULL values across all columns, deceased customers and customers with no Address information;</li>
      </td>
    </tr>
    <tr>
      <td align="center">Customer Address</td>
     <td align="left">
	     <li>Additional customer ids not present in the customer demographics table, as well as missing information for some of the exisiting ids</li>
	     <li>Inconsistent categorical labels in the state column</li>
     </td>
      <td align="left">
	 <li>Fixed State column categorical labels</li>    
	      <li>Filtered out customers not present in the customer demographics table</li>
      </td>
    </tr>
  </tbody>
</table>


# Task 2 & 3 - Data Insights and Presentation

Overview of the data exploration done to find the broader markets for the client to target, as well as the use of RFM analysis for the purpose of segmenting customers and finding the high value customers amongst the current customers dataset. 

More details in the [Data Analytics Approach](https://docs.google.com/presentation/d/1y4rvjb6k0rYeO1hJ5ZMQndKSbti8TO3K/edit#slide=id.p15](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fraw.githubusercontent.com%2FCheilaDaSilva%2FWork_Experience_Projects%2Fmain%2FKPMG%2520Data%2520Analytics%2520Consulting%2520Virtual%2520Internship%2FData%2520Analytics%2520Approach.pptx&wdOrigin=BROWSELINK) presentation.

## Data Exploration and Visualisation

Steps:
- Feature Construction: [Created additional fields](https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/2.%20Adding%20Extra%20Fields.sql) to obtain insights, such as a customer's age group and profit generated from a transaction, to further investigate customer behaviour and trends.
- Created [tables for data exploration stages](https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/3.%20tables%20for%20PBI%20dashboard.sql) with the quality assessment and mitigation methods suggested taken into consideration.
- Built [Power BI dashboards](https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/KPMG%20Power%20Bi%20data%20exploration.pbix) to explore age, job and wealth segment distributions (amongt others) within current customers who have transaction history to understand who is buying the product and which broader markets are generating the most profit i.e. which are the broader markets to target.
- Compared current customers demographic distributions against new customers demographics to understand which broader markets to target.

### Power BI Dashboard Visualisation & Data Insights Interpretation

Transaction Dashboard Snip
![transactions dashboard](https://user-images.githubusercontent.com/88495091/216690572-ee675d95-fb80-4597-adb0-8a97f9664764.png)

#### Interpretation of the transaction dashboard/ Data Exploration insights:
- Top 4 products that customers purchase and that brought the most profit: Solex Standard (class: medium); WeareA2B Standard (class: medium); Giant Bycicles Standard (class: medium); Trek Bycicles Standard (class: medium).
- Customers in the age groups 20s to 50s are the ones making the most transactions. Customers in their 30s to 40s provide the most profit to the clien, followed by customers in their 20s and 50s; with female customers generating a slightly higher percentage of total profit generated by age group.
- Mass Customers are generating about 50% of total profit by month. 
- Most transactions/total profit generated come from customers in New South Wales, Australia.
- Months of October and August had the highest profit and number of transactions.


Current Customers Demographics and Attributes Dashboard Snip
![current customers dashboard](https://user-images.githubusercontent.com/88495091/216713658-35076d33-a2a1-48be-80e6-4cfa5f65a931.png)


New Customers Demographics and Attributes Dashboard Snip
![new customers dashboard](https://user-images.githubusercontent.com/88495091/216713751-68af9200-64a4-4073-84c0-812c1578719b.png)

#### Interpretation of the New & Current Customers dashboard/ Data Exploration Insights

Differences between new and current customers sets distribution:
- Current customers have a younger population in comparison to new customers.
- 	Less than 7% of current customers are over 60, 87% of current customers are in their 20s to 50s; in comparison 25% of new customers are over 60, and 68% of new customers are in their 20s to 50s.  
- 	Slightly higher number of female customers, particularly in the new customer group.

Similarities between new and current customers distributions:
- Top 3 job industries that customers belong to are: Manufacturing, Finance Services and Health
- 50% of customers have been assigned a wealth segment of "Mass Customer". 
- About 50% of customers are from New South Wales, Australia. 
- Across the 3 states, the numbers of customers that own cars and the the ones that do not own car are slightly similar.
- Most customers have property evaluations scores between 7 and 10.
- Most customers are in their 40s (28% of total current customers and 21% of total new customers belong to this age group)

#### Markets to Target

From initial data exploration of customer attributes and demographics, most of current customers with transaction history in 2017 tend to belong to the following markets:

Wealth Segment = Mass Customer;
Gender = Female;
Age Group = 30s to 40s;
Job Industry = Manufacturing, Financial Services and Health.
Property Evaluation = Scores 7 to 10

Based on the transaction dashboard these groups are also the ones who tend to buy the most and spend the most hence I recommend the marketing team to target these broader market segments.

Seeing as new and current customers have similar distribution, high value customers from the new customer list will also belong to these markets.


## Customer Segmentation through RFM Analysis

Steps:
- [RFM Calculation using SQL](https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/4.%20RFM%20for%20Customer%20Segmentation.sql): Calculated Recency, Frequency and Monetary scores for current customers to obtain overall RFM value using SQL NTILE function.
- Ranked/Segmented customers based on their RFM value and assigned customer titles accordingly (imported table with results to PBI).


### Customer Title & Rank Allocation

<table>
	<tbody>
		<tr>
			<th align="center">Rank</th>
			<th align="center">Customer Title</th>
			<th align="center">Description</th>
			<th align="center">RFM Value</th>
		</tr>
		<tr>
			<td align="left">1</td>
			<td align="left">Champions</td>
			<td align="left">Bought recently, buy often, and spends the most.</td>
			<td align="left">442 - 444</td>
		</tr>
				<tr>
			<td align="left">2</td>
			<td align="left">Loyal Customers</td>
			<td align="left">Spend good money often, responsive to promotions.</td>
			<td align="left">422 - 442</td>
		</tr>
				<tr>
			<td align="left">3</td>
			<td align="left">Potential Loyalist</td>
			<td align="left">Recent customers but spend a good amount and bought more than once.</td>
			<td align="left">344 - 422</td>
		</tr>
				<tr>
			<td align="left">4</td>
			<td align="left">Recent Customers</td>
			<td align="left">Bought more recently, but not often.</td>
			<td align="left">333 - 344</td>
		</tr>
				<tr>
			<td align="left">5</td>
			<td align="left">Promising</td>
			<td align="left">Recent shoppers but haven’t spend much.</td>
			<td align="left">313 - 333</td>
		</tr>
				<tr>
			<td align="left">6</td>
			<td align="left">Customer Needing Attention</td>
			<td align="left">Above average recency, frequency and monetary values. May not have bought very recently though.</td>
			<td align="left">234 - 313</td>
		</tr>
				<tr>
			<td align="left">7</td>
			<td align="left">About to Sleep</td>
			<td align="left">Below average recency, frequency and monetary values. Will lose them if not reactivated.</td>
			<td align="left">223 - 234</td>
		</tr>
				<tr>
			<td align="left">8</td>
			<td align="left">At Risk</td>
			<td align="left">Spends good amount of money and purchases.</td>
			<td align="left">211 - 223</td>
		</tr>
				<tr>
			<td align="left">9</td>
			<td align="left">Can’t Lose Them</td>
			<td align="left">Made biggest purchases and often. Last purchase was a long time ago.</td>
			<td align="left">124 - 211</td>
		</tr>
				<tr>
			<td align="left">10</td>
			<td align="left">Hibernating</td>
			<td align="left">Last purchase was long back, low spenders, low number of orders.</td>
			<td align="left">113 -124</td>
		</tr>
				<tr>
			<td align="left">11</td>
			<td align="left">Lost</td>
			<td align="left">Lowest recency, frequency and monetary values.</td>
			<td align="left">111 - 113</td>
		</tr>
	</tbody>

</table>

### High Value Current Customers

Ranking current customers based on RFM value, I found the top current customers. These are the "Champions" with Rank = 1 / RFM = 444.

A sample of the top current customers is shown in current customers Power BI dashboard.



## Next steps:

- Develop mmodel using the insights obtained to find who to target from the 1000 new customers list.
