/* 2. Query to create a temp table that can be used as a menu showing all item categories and the associated prices.
This is a temp table which can be run once each session and is stored in memory until connection to the server ends.
The query compiles distinct values of items and prices, ignoring lines where either columns returns null or errors. */

create temp table menu_table as (
select
	distinct
		item_category
		, cast(price_per_item as numeric(5,2))
from
	cafe_trans
where
	item_category is not null
	and item_category not in ('ERROR','UNKNOWN')
	and price_per_item is not null
	and price_per_item not in ('ERROR','UNKNOWN')
order by
	price_per_item asc
) 
;

-- Run a SELECT query to view the menu and ensure there are no items with multiple prices. 


/* 3. Clean up price data */

-- Updating price where quantity and total spend are known, excluding where either are null or is an error.

update cafe_trans
	set price_per_item = cast(cast(total_spent as numeric) / cast(quantity as numeric) as numeric(5,2))
	where
		(price_per_item is null or price_per_item in ('ERROR','UNKNOWN'))
		and
		(quantity is not null and quantity not in ('ERROR','UNKNOWN'))
		and
		(total_spent is not null and total_spent not in ('ERROR','UNKNOWN'))
;



--Updating price using value set in the menu.

update cafe_trans
	set price_per_item = menu.price_per_item
	from
		(	select
				menu_table.item_category
				, menu_table.price_per_item
			from
				menu_table
		) as menu
	where
		cafe_trans.item_category = menu.item_category
		and cafe_trans.item_category is not null
		and cafe_trans.item_category not in ('ERROR','UNKNOWN')
;

/* 4. Clean up item category by updating the value where price is known, except where it equals '3' or '4' and where it is an error */

update cafe_trans
	set item_category = menu.item_category
	from
		(	select
				menu_table.item_category
				, menu_table.price_per_item
			from
				menu_table
		) as menu
	where
		cast(cafe_trans.price_per_item as numeric(5,2)) = menu.price_per_item
		and cafe_trans.price_per_item is not null
		and cafe_trans.price_per_item not in ('3','4','ERROR','UNKNOWN')
;


/* 5. Clean up total_spent and quantity where possible */

-- Clean up quantity where price and total spend values are known, except when either is null or is an error.

update cafe_trans
	set quantity = cast(total_spent as numeric) / cast(price_per_item as numeric)
	where
		(quantity is null or quantity in ('ERROR','UNKNOWN'))
		and
		(price_per_item is not null and price_per_item not in ('ERROR','UNKNOWN'))
		and
		(total_spent is not null and total_spent not in ('ERROR','UNKNOWN'))
;



-- Clean up total spent where price and quantity are known, except when either is null or is an error.

update cafe_trans
	set total_spent = cast(price_per_item as numeric) * cast(quantity as numeric)
	where
		(total_spent is null or total_spent in ('ERROR','UNKNOWN'))
		and
		(price_per_item is not null and price_per_item not in ('ERROR','UNKNOWN'))
		and
		(quantity is not null and quantity not in ('ERROR','UNKNOWN'))
;

/* 6. Deleting rows where critcal fields have null or errors that cannot be updated with clean-up queries above */

-- Create a temp table that can be used as a reference to identify which items should be removed from analyses - this is defined as items where two out of three of price, quantity, or price is null or returns errors.

create temp table delete_error as(

	Select
		transaction_id
		, transaction_date
		, item_category
		, quantity
		, price_per_item
		, total_spent
		, (case 	when quantity is null then 1
					when quantity = 'ERROR' then 1
					when quantity = 'UNKNOWN' then 1
					else 0
				end) 
			as quantity_err
		, (case 	when price_per_item is null then 1
					when price_per_item = 'ERROR' then 1
					when price_per_item = 'UNKNOWN' then 1
					else 0
				end)	
			as price_err
		, (case 	when total_spent is null then 1
					when total_spent = 'ERROR' then 1
					when total_spent = 'UNKNOWN' then 1
					else 0
				end)	
			as total_err
	from 
		cafe_trans
)
;


-- Referencing temp table above that identifies data that cannot be corrected, delete items that still have errors

delete from cafe_trans as tr
using delete_error as er
where tr.transaction_id = er.transaction_id
	and 
		(
			(er.quantity_err = 1 and er.price_err = 1) 
			or (er.quantity_err = 1 and er.total_err = 1) 
			or (er.price_err = 1 and er.total_err = 1)
			or er.transaction_date is null 
			or er.transaction_date in ('ERROR','UNKNOWN')
			or (
				er.item_category is null or er.item_category in ('ERROR','UNKNOWN')
				) 
			   and
				cast(er.price_per_item as int) in ('3','4')
		)
;

/* 7. Clean up payment_method and trans_location to keep values more consistent by replacing errors with 'Unknown' */

update cafe_trans
	set payment_method = 'Unknown'
where payment_method is null or payment_method in ('ERROR','UNKNOWN') 
;


update cafe_trans
	set transaction_location = 'Unknown'
where transaction_location is null or transaction_location in ('ERROR','UNKNOWN')
;



/* 8. Alter table data types to ensure pricing and quantity data can be used mathematically */

alter table cafe_trans alter column quantity type numeric(5,2) using quantity::numeric(5,2);
alter table cafe_trans alter column price_per_item type numeric(5,2) using price_per_item::numeric(5,2);
alter table cafe_trans alter column total_spent type numeric(5,2) using total_spent::numeric(5,2);
alter table cafe_trans alter column transaction_date type date using transaction_date::date;


/* View clean dataset */
select * from cafe_trans

