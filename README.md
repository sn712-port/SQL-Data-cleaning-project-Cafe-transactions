# Data cleaning project: Cafe transactions

## Project objective:
Utilize SQL in PostgreSQL to transform and clean a dirty dataset, getting it ready for further analysis. Transaction data can provide insights into trends and opportunities for improving efficiency. While missing information can be extrapolated, for the purpose of this exercise, the approach is to clean the dataset without using estimation to derive values where data is corrupted.

## Tools: 
PostgreSQL & pgAdmin4  |  Google sheets

## Project files:
  - Raw data file: Cafe Transactions_Dirty dataset.csv
  - 5 SQL scripts: Create table | Validate dirty dataset | Clean dataset | Validate clean dataset | Explore clean dataset
  - Clean dataset: Cafe Transactions_Clean dataset.csv

## Cleaning approach:

### Step 1: Data exploration to identify issues and appropriate solutions

***Issues:*** 

A quick review of the dataset in Google Sheets reveals missing values and errors as the main data issue that would critically impact analyses using the dataset. Quantitative fields (**transaction_date**, **quantity**, **price_per_item**, and **total_spent**) and an important qualitative field (**item_category**) containing null items or errors that show up as 'ERROR' or 'UNKNOWN'. Missing values and errors also impact other data fields that are not easily corrected (**payment_method**, **transaction_location**) but should be addressed at point of entry to allow for better insights in future analyses.

***Solutions:***

  #1 - *quantity*, *price_per_item*, and *total_spent* have a mathematical relationship. For any rows with 2 out of 3 items, the third can be inferred. 
  
  #2 - With pricing structure not changing over time, a menu can be created as a reference and used to infer **price_per_item** from **item_category** and vice versa. In the case where **price_per_item** is known but is either $3 or $4, I opt to exclude these rows instead of randomly assigning item category since there are more than one item with $3 and $4 per unit. 
  
  #3 - Rows with null or errors in **transaction_date** field are to be excluded to keep the dataset clean, especially for time series analyses.

### Step 2: Load and clean dataset using SQL

  1. Load data using create table query, importing data using pgAdmin GUI.
     
      a. Validate values and confirm issues (null, errors) using SQL concepts, including: *aggregate functions*, *select distinct*, *union all*.
     
  3. Clean data using various SQL concepts: *create temp table*, *update* records via *set* conditions, *update* records *using* values from temp table, *delete from* table *using* a temp table as reference, *alter column type*
     
      a. Validate values to ensure issues identified in 1a have been dealt with.


### Step 3: Use dataset for analyses

Use SQL queries, including select statements, aggregate functions, joins, common expression table, and window functions, etc. to answer business questions. 


## Data Cleaning Summary

| Column | Before | After | Action(s) taken |
|--------|--------|-------|-----------------|
| transaction_id | 10,000 records<br/>No duplicates<br/>No null<br/>No errors<br/>(100% clean) | 9,089 records<br/>No duplicates<br/>No null<br/>No errors<br/>(100% clean) | None |
| item_category | 333 null<br/>636 records with errors ('ERROR', 'UNKNOWN')<br/>(90.31% clean) | No null<br/>No records with errors<br/>(100% clean) | Since there were no price changes, I created a fixed menu as a temp table. Using the menu, where a price_per_item is valid, derive the item_category from price_per_item.<br/><br/>Exception: when price equals $3 or $4, I opted not to update these rows since there are multiple menu items with a price of $3 or $4. |
| quantity | 138 null<br/>341 records with errors ('ERROR', 'UNKNOWN')<br/>(95.21% clean) | No null<br/>No records with errors<br/>(100% clean) | Where price_per_unit and total_spent are available, calculate quantity.<br/><br/>Alter column type to numeric. |
| price_per_item | 179 null<br/>354 records with errors ('ERROR', 'UNKNOWN')<br/>(94.67% clean) | No null<br/>No records with errors<br/>(100% clean) | Where there is no valid value in item_category but quantity and total_spent are available, calculate price.<br/><br/>Where there is a valid value in item_category, derive price using the menu.<br/><br/>Alter column type to numeric. |
| total_spent | 173 null<br/>329 records with errors ('ERROR', 'UNKNOWN')<br/>(94.98% clean) | No null<br/>No records with errors<br/>(100% clean) | Where quantity and price_per_unit are available, calculate total_spent.<br/><br/>Alter column type to numeric. |
| payment_method | 2579 null<br/>599 records with errors ('ERROR', 'UNKNOWN')<br/>(68.22% clean) | No null<br/>No records with errors<br/>2,879 records of 'Unknown'<br/>(68.32% clean) | Update records with null / 'ERROR' / 'UNKNOWN' to 'Unknown' to keep values consistent |
| transaction_location | 3265 null<br/>696 records with errors ('ERROR', 'UNKNOWN')<br/>(60.39% clean) | No null<br/>No records with errors<br/>3,603 records of 'Unknown'<br/>(60.36% clean) | Update records with null / 'ERROR' / 'UNKNOWN' to 'Unknown' to keep values consistent |
| transaction_date | 159 null<br/>301 records with errors ('ERROR', 'UNKNOWN')<br/>(95.4% clean) | No null<br/>No records with errors<br/>(100% clean) | Remove records with null or error values.<br/><br/>Alter column type to date. |


## Dataset samples

*** Dataset before cleaning

<img width="331" height="204" alt="Dataset before cleaning" src="https://github.com/user-attachments/assets/feafdc52-958d-4a63-8eb2-51ddc7b402b4" />

*** Dataset after cleaning

<img width="350" height="162" alt="Dataset after cleaning" src="https://github.com/user-attachments/assets/e3f49f77-37a2-4bdc-8ba1-c146bf9110bc" />


## Analyses samples

<img width="512" height="340" alt="Annual revenue by item category" src="https://github.com/user-attachments/assets/1306b05c-de47-43ce-8593-ed8022966369" />

<img width="512" height="483" alt="Revenue by month" src="https://github.com/user-attachments/assets/4e3a3372-2ba3-4a98-ab93-109c49b89274" />




