-- Didem B. Aykurt
-- Statistic Analyze with Window function
-- Window function use the Over clause in order to turn regular aggregate function into a Window function
-- Window function is allowing us to calculate the overall average for the entire dataset
-- But it's doing it in a way that doesn't group all of data rows together
Select avg(price) over()
From inventory.products;

-- Let's add other variables
-- This time see all the detail also have the overall average price for all products reported on each row.
-- That helps to compare whether each product's price is above or below the average and by how much.
-- The OVER clause turns regular aggregate functions into window functions by creating
-- Window frame is a set of data rows that the aggregate will operate on
-- In our below case by using a empty set of parentheses in the OVER clause
-- The over clause creates a window frame that inclueds all rows from a dataset
Select sku,
       product_name,
	   size,
	   price,
	   avg(price) over()
from inventory.products;

-- Create partions within this window frame in order to control the set of rows
-- that the aggregate calculation will operate on.
-- Lets look at avg price split up by product size for each unique size classification
-- Calculate the difference between the product price and the average price for its size
-- Products that are priced above average for their size will have a positive number
-- if that are below avg price will have a negative number
Select sku,
       product_name,
	   size,
	   category_id,
	   price,
	   avg(price) Over(partition by size) as "average price for size",
	   price - avg(price) over(partition by size) as "difference"
from inventory.products
order by sku, size;
-- Inclued multiple window functions, it's not uncommon to use the same partition over and over again
-- Like We want to review the average, min, and max price for each product within the same size clasification
-- that reference window function helps to modificate within the window clause instead of three times in each OVER clause
Select sku,
       product_name,
	   size,
	   category_id,
	   price,
	   avg(price) Over(partitionReference) as "average price for size",
	   min(price) over(partitionReference) as "min price",
	   max(price) over(partitionReference) as "max price"
from inventory.products
Window partitionReference as (partition by size)
order by sku, size;

-- The window frame created by an over clause contain the set of rows that a window function will operate on
-- We can create dynamic partitions within this window frame
-- We can also sort the rows within the frame this sorting can have an effect the aggregate function is applied
-- want to know total price for entire order as well as the runing total as each line is added
Select order_lines.order_id,
       order_lines.line_id,
	   order_lines.sku,
	   order_lines.quantity,
	   products.price as "price each",
	   order_lines.quantity*products.price as "line total",
	   sum(order_lines.quantity*products.price)
	   over(partition by order_id) as "order total",
	   sum(order_lines.quantity*products.price)
	   over(partition by order_id order by line_id) as "runing total"
from sales.order_lines 
inner join inventory.products
on order_lines.sku=products.sku;

-- When the window frame contains sorted data we can add additional parameter
-- to create a dynamically changing set of records that an aggregate function will apply to.
-- This thechnique allows you to create moving avrg and rolling sums of your data.
-- rolling sum for 3 rows and trailing sum
-- This dinamnic calculation often used to create a moving average.
Select order_id,
       sum(order_id) over(order by order_id rows between 0 preceding and 2 following)
	   as "3 period leading sum",
	   sum(order_id) over(order by order_id rows between 2 preceding and 0 following)
	   as "3 period trailing sum",
	   avg(order_id) over(order by order_id rows between 1 preceding and 1 following)
	   as "3 period moving average"
from sales.orders;

-- We can retrieve a row's value based off of its position within the frame using the first,last and Nth value window functions
-- Show first, last and 3rd value of company
Select company,
       first_value(company) over(order by company
			rows between unbounded preceding and unbounded following) as "first value",
	   last_value(company) over(order by company
			rows between unbounded preceding and unbounded following) as "last value",
	   nth_value(company,3) over(order by company
			rows between unbounded preceding and unbounded following) as "3rd value"
from sales.customers
order by company;

-- our each customers have placed a number of orders
-- find when they placed their first order and most recent order

select distinct customer_id,
       first_value(order_date)
	   over(partition by customer_id order by order_date
		   rows between unbounded preceding and unbounded following),
       last_value(order_date)
	   over(partition by customer_id order by order_date
		   rows between unbounded preceding and unbounded following)
from sales.orders
order by customer_id;

-- Return product details along with the minimum price, maximum price, average price, 
-- and the count of products that are in the same category.
-- Use window functions to expand on the information about each product
-- Return columns for the product_name, category, and price of each product
-- Add columns for the cat_min_price, cat_max_price, cat_avg_price, and cat_count
-- of all products that share the same category classification
-- Remember that you can include a window clause when you have multiple
-- functions that all use the same window frame parameters
Select product_name,
       category,
	   price,
	   min(price) over(xyz) as "cat_min_price",
	   max(price) over(xyz) as "cat_max_price",
	   avg(price) over(xyz) as "cat_avg_price",
	   count(*) over (xyz) as  "cat_count"
from products
Window xyz as (partition by category)
Order by category,price;



