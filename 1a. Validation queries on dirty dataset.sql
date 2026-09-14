/* Validation queries - Before cleaning */

-- Check for duplicates in transaction IDs (not other fields because it doesn't make sense to check; they have duplicates).

select
	transaction_id
	, count(*)
from
	cafe_trans
group by
	transaction_id
order by
	count(*) desc
;

-- Check for null and errors in all other columns by examining what value exists in each columns.

	select distinct item_category, 'item_category' as source_column, count(*) as count_value
	from cafe_trans	
	group by item_category, source_column
	
union all
	select distinct quantity , 'quantity' as source_column, count(*) as count_value
	from cafe_trans	
	group by quantity, source_column
	
union all
	select distinct price_per_item,'price_per_item' as source_column, count(*) as count_value
	from cafe_trans
	group by price_per_item, source_column
	
union all
	select distinct total_spent, 'total_spent' as source_column, count(*) as count_value
	from cafe_trans
	group by total_spent, source_column
	
union all
	select distinct payment_method, 'payment_method' as source_column, count(*) as count_value
	from cafe_trans
	group by payment_method, source_column
	
union all
	select distinct transaction_location, 'transaction_location' as source_column, count(*) as count_value
	from cafe_trans
	group by transaction_location, source_column

union all
	select distinct split_part(transaction_date,'-',1) as transaction_year, 'transaction_date' as source_column, count(*) as count_value
	from cafe_trans
	group by transaction_year, source_column

		
-- Validating that price_per_item * quantity = total_spent.
		
select
	price_per_item
	, quantity
	, cast(total_spent as numeric) as total_spent
	, (cast(price_per_item as numeric) * cast(quantity as numeric)) as total_calc
	, abs((cast(total_spent as numeric) - (cast(price_per_item as numeric) * cast(quantity as numeric)))) as diff
from
	cafe_trans
order by
	diff desc
	


