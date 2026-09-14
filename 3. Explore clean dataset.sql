-- Aggregate quantity and total_spent by item_category

select
	item_category
	, sum(quantity) as quantity_purchased
	, sum(total_spent) as revenue
from
	cafe_trans
group by
	item_category
order by
	revenue desc


-- Revenue by month

select
	date_part('year',transaction_date) as year_num
	, date_part('month',transaction_date) as month_num
	, sum(total_spent) as revenue
from
	cafe_trans
group by
	year_num
	, month_num
order by
	year_num
	, month_num asc

-- Ranking item category by revenue for each month, pull in price for reference. 

with ranking as
	(select
		date_part('year',transaction_date) as year_num
		, date_part('month', transaction_date) as month_num
		, item_category
		, sum(total_spent) as revenue
		, row_number() over(partition by date_part('month', transaction_date) order by sum(total_spent) desc) as ranking
	from
		cafe_trans
	group by
		year_num
		, month_num
		, item_category)



select
	ranking.year_num
	, ranking.month_num
	, ranking.ranking
	, ranking.item_category
	, ranking.revenue
	, p.price_per_item
from
	ranking
	join 
		(select 
			distinct
				item_category
				, price_per_item
		 from
		 	cafe_trans
		)as p
		on ranking.item_category = p.item_category
	-- can pull in ranking for specific month with a where clause --

	