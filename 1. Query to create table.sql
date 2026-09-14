/* 1. Query to create a table that allows the raw csv data file to be imported */

-- All columns are created as varchar data types to capture all values, including null and errors.

create table
	cafe_trans (
		transaction_id VARCHAR(255)
		, item_category VARCHAR(255)
		, quantity VARCHAR(255)
		, price_per_item VARCHAR(255)
		, total_spent VARCHAR(255)
		, payment_method VARCHAR(255)
		, transaction_location VARCHAR(255)
		, transaction_date VARCHAR(255)
	)
;

/* Import data using pgAdmin GUI (Encoding: UFT8 | On Error: ignore | Log Verbosity: default) */

-- Run SELECT statement to view the dataset
select * from cafe_trans 