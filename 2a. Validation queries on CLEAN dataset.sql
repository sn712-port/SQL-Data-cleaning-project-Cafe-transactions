/* Validation query - after cleaning
Reviewing what values remain in each column to ensure no errors/null is left */

	select distinct item_category as value_list, 'item_category' as source_column, count(*) as count_value
	from cafe_trans	
	group by item_category, source_column
	
union all
	select distinct cast(quantity as varchar(255)) as quantity , 'quantity' as source_column, count(*) as count_value
	from cafe_trans	
	group by quantity, source_column
	
union all
	select distinct cast(price_per_item as varchar(255)) as price_per_item,'price_per_item' as source_column, count(*) as count_value
	from cafe_trans
	group by price_per_item, source_column
	
union all
	select distinct cast(total_spent as varchar(255)) as total_spent, 'total_spent' as source_column, count(*) as count_value
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

union all -- count by year to make the result set manageable 
	select distinct cast(date_part('year',transaction_date) as varchar) as transaction_year, 'transaction_date' as source_column, count(*) as count_value
	from cafe_trans
	group by transaction_year, source_column
