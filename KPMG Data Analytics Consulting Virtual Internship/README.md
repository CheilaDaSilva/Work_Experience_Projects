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

The [Data Analytics Approach](https://docs.google.com/presentation/d/1y4rvjb6k0rYeO1hJ5ZMQndKSbti8TO3K/edit#slide=id.p15) presentation details the approach taken to achieve the project goals as well as the presentation of results and its interpretation. Below is a snip of this presentation with the overall steps taken:

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

## Data Exploration and Visualisation

Steps:
- Feature Construction: [Created additional fields](https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/2.%20Adding%20Extra%20Fields.sql) to obtain insights, such as a customer's age group and profit generated from a transaction, to further investigate customer behaviour and trends.
- Created [tables for data exploration stages](https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/3.%20tables%20for%20PBI%20dashboard.sql) with the quality assessment and mitigation methods suggested taken into consideration.
- Built Power BI dashboards to explore age, job and wealth segment distributions (amongt others) within current customers who have transaction history to understand who is buying the product and which broader markets are generating the most profit i.e. which are the broader markets to target.
- Compared current customers demographic distributions against new customers demographics to understand which broader markets to target.

#### Power BI Dashboard snips

![image](https://user-images.githubusercontent.com/88495091/216690572-ee675d95-fb80-4597-adb0-8a97f9664764.png)
![image](https://user-images.githubusercontent.com/88495091/216690246-02ec62dd-a8e3-423d-8505-6c043f8c6f97.png)
![image](https://user-images.githubusercontent.com/88495091/216690325-86a814f9-ca26-4455-beae-c3cde122a486.png)

#### Data Exploration Insights

Details in the [Data Analytics Approach](https://docs.google.com/presentation/d/1y4rvjb6k0rYeO1hJ5ZMQndKSbti8TO3K/edit#slide=id.p15) presentation.

The following insights were obtained from comparing various distributions between new and current customers:
- Current customers have higher percentages of customers in their 30s and 40s, and lower percentages of customers in other age groups as age increases and decreases. New customers have more spread out age groups amongst their customers, therefore having higher percentages of both newer and older customers.
- Both new and current customers have more customers in their 40s compared to other age groups.
- About 50% of the new and current customers reside in New South Wales, Australia.
- The top 3 industried that customers in both groups belong to are: Manufacturing, Financial Services and Health.
- About 50% of new and current customers have been assigned the "Mass Customer" wealth segment; Other wealth segments, "High Newtwork" and "Affluent Customers", contain about 25% of customers.
- Both new and current customers have a higher percentage of customers with a property evaluation score between 7 and 10.

## Customer Segmentation through RFM Analysis

- Calculated Recency, Frequency and Monetary scores for current customers to obtain overall RFM value in order to segment customers and the high target customers.

## Next steps:

- Using the insights obtained till now to find who from the 1000 new customers are potential high target customers.
