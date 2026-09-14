# Data cleaning project: Cafe transactions
**The objective** of this project is to utilize SQL to transform and clean a dirty dataset, getting it ready for further analysis. Transaction data can provide insights into trends and opportunities for the cafe.

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
