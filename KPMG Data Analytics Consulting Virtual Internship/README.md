# 💻 KPMG Data Consulting Virtual Internship with Forage

Virtual Experience Program Participant

Completed practical task modules in: Data Quality Assessment; Data Insights; Data Insights and Presentation	

View: [Virtual Internship Program](https://www.theforage.com/virtual-internships/theme/m7W4GMqeT3bh9Nb2c/KPMG-Data-Analytics-Virtual-Internship)

![project git banner](https://user-images.githubusercontent.com/88495091/210605926-adc1d17a-5f54-4984-8370-38fd6cb83f70.png)

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
“the importance of optimising the quality of customer datasets cannot be underestimated. The better the quality of the dataset, the better chance you will be able to use it to drive company growth.”

Client provided KPMG with 3 datasets: 
- Customer Demographic; 
- Customer Addresses; 
- Transactions data in the past 3 months.

## Project Goal
We need to use our data analytics skills to recommend a suitable marketing strategy and find who the marketing team should be targeting out of the new 1000 customer list as well as the broader market segment to reach out to.
To achieve this I performed an RFM analysis to segment the customers and find the high value customers.


# Task 1 - Data Quality Assessment and Actions taken

Overview of the results of the data quality assessment and the actions done to each dataset.

View code: [Cleaning Data With SQL](https://github.com/CheilaDaSilva/Work_Experience_Projects/blob/main/KPMG%20Data%20Analytics%20Consulting%20Virtual%20Internship/cleaning%20data%20with%20SQL.sql)

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



