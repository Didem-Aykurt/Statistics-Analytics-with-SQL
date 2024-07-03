-- Didem B. Aykurt
-- Statistics with filters, bool_and, bool_or, rollup, filter, and aggregate function
-- only shows the 
-- products that had a price over $20
select product_name, 
       category_id,  
	   size,
	   price
From inventory.products
Where price>20.00;

-- Let's analyze 
-- our product information based off of each product size
-- want to know 
-- how many size classification there are in the product data.
-- How many products are in each size category.
-- want to see only groups that have over 10 products
Select size as "product size", 
       count(*) as "number of products"
From inventory.products
Group By size
Having Count(*)>10
Order By size DESC;

-- Let see our product and their prices
Select sku,
       product_name,
	   size,
	   price
From inventory.products;

-- show each of the different olive oil products are available
-- in multiple size and at different prices
Select sku, 
       product_name,
	   Size,
	   price,
	   Count(*) as "Number of product"
From inventory.products
Group By sku, product_name, size, price
Order By size DESC, price DESC;

-- Find the higest& lowest prices product within each oil type
-- Find the higest size within each oil category
-- return the average price for each oil category
Select product_name, 
       Count(*) as "Number of products",
       MAX(price) as "Higest price",
       Max(size) as "Largest size",
	   Min(price) as "Lowest price",
	   Round(Avg(price),2) as "average price"
From inventory.products
Group By product_name;

--Boolean type data is used to represent data is either true or false
-- Let's look at the customer table to see an example column that uses
-- this data type. First pull the all data in the table 
Select * from sales.customers;

-- newsletter has a boolean type data
-- Use grouping with Boolean columns to get some statistical insight into the data
Select newsletter,
       count(*)
From sales.customers
Group By newsletter;

-- There two function to apply boolean variable bool_and & bool_or
-- As a result there are two customers in Ohio& Georgia 
-- and one customer in Michigan&lowa
-- Than we have two column represent bool_and&bool_or
-- bool_and function display a true or false that reveals whether every customer
-- each group is signed up for the newsletter. 
-- If every record the group is true bool_and returns true
-- if a single record within the group is false and bool_and return false.
-- bool_or is looking for the presence os a single true value within the group.
-- If one record in the group is true then bool_or returns true
Select state,
       Count(*),
	   bool_and(newsletter),
	   bool_or(newsletter)
From sales.customers
Group By state

-- Let's use aggregate function with peoeple_heights table 
-- As a result shows the range of values for each gender.
-- It tells us the highest and lowest height as well as the average
-- So we know the range of data that we're working with
-- But we don't know is the shape of the distribution are 
-- all 200 height measurements uniformly distributed across the min&max range
-- The shape of a bell curve or normal distribution are
-- Standard deviation abbreviated as stddev or variance.
-- As the number of sample increases, or in other word the more rows that have
-- in original dataset the two function will converge and report the same result.
-- The standard deviation in particular gives as a good understanding about 
-- where the majority of our values occur between the full spread from max to min
-- With a stddev of about 2.7 that means approximately 68% of our data height measurements
-- will fall within 2.7 inches above or below the average.
-- So nearly everyone will be within the range of about 66 to 72 for males and 61 to 67 inches for females
-- Normal distribution we can also expect that 95% of our data points will fall within two stddev
-- Or about 5.5 inches above and below the average
Select gender,
       Count(*) as "Number of people",
	   Round(avg(height_inches),2) as "Average height",
	   Min(height_inches) as "Lowest height",
	   Max(height_inches) as "Highest height",
	   Round(stddev_samp(height_inches),2) as "Standard deviation of the sample",
	   Round(stddev_pop(height_inches),2) as "Standard deviation of the population",
	   Round(var_samp(height_inches),2) as "Variance of the sample",
	   Round(var_pop(height_inches),2) as "Variance of the population"
From public.people_heights
group by gender;

-- Use aggregate function with sales data and rollup function
-- rollup function shows subtotal number of each group category for all of the products
-- rollup shows subtotal and grand total for entire data
-- the category number one has a total of 89 products across all product name
-- the lowest price is $8.99 across all of those products.
-- The highest price is $27.99 across all of those products
-- The average price is $18.52 in the category one.
-- End of the row we have a grand total row for the entire dataset across all category and product name
Select category_id,
       product_name,
	   Count(*) as "Number of products",
	   min(price) as "Lowest price",
	   max(price) as "Highest price",
	   Round(avg(price),2) as "Average price"
From inventory.products
Group By rollup(category_id, product_name)
Order By category_id, product_name;

-- That is return all possible combinations of groups when you're using multiple Group By column
-- Our products come in different categories and have different sizes, 
-- but those two attributes aren't related to one another 
-- they're just different ways to describe each product.
-- Notice that we have products of the same size spread across the different categories
--Such as size number 16 in category one, two,and three
-- want to see subtotal for these products by size, 
-- without regard for the different categories that they're in
-- This is where the CUBE variation of the group By clause comes into play
-- Cube is giving us four separate queries all at once. 
-- It returns all posible combinations of the group in a single result
-- This result with CUBE is the same as grouping all of the product data just by the category, 
-- just by the size and combination size and category
Select category_id,
       size,
	   Count(*) as "Number of products",
	   min(price) as "Lowest price",
	   max(price) as "Highest price",
	   Round(avg(price),2) as "Average price"
From inventory.products
Group By Cube(category_id, size)
Order By category_id, size;

--Segmenting groups with aggregate filter
-- If you want to create customized segments based off of product size,
-- we can do that with a filters into two different size classifications.
-- Small products are all 16 ounces or less in size and large products, which are over 16 ounces
-- The rollup function give me another final group total at very bottom
Select category_id,
       Count(*) as "count all",
	   Round(avg(price),2) as "average price",
	   -- small products
	   count(*) filter (where size <= 16 ) as "count small",
	   avg(price) filter (where size <=16) as "average price small",
	   -- large products
	   Count(*) filter(Where size > 16) as "count large",
	   avg(price) filter (where size >16) as"average price large" 	   
From inventory.products
Group By rollup(category_id)
Order By category_id

-- Task: Find the number of orders placed per month for each customer.
-- The order data contain order information from March and April, 2021
-- Use an aggregate function to count up the total_orders placed by each customer
-- Use filter to segment out the data in two new columns named march_orders and april_orders
select customer,
    Count(*) As "total_orders",
	Count(*) filter (Where order_date between '2021-03-01' and '2021-03-31') as "march_order",
	Count(*) filter (Where order_date >= '2021-04-01' and order_date<='2021-04-30') as "april_order"
from public.orders
Group By customer;
--Or we can use extract function
select customer,
    Count(*) As "total_orders",
	Count(*) filter (Where extract(month from order_date) = 3) as "march_order",
	Count(*) filter (Where extract(month from order_date) = 4) as "april_order"
from public.orders
Group By customer;

-- Which SQL clause is used to filter groups from a result set? HAVING: The HAVING clause is used to filter group rows.
-- Aggregate functions can be applied to a subset of the data using what keyword?-Filter
-- Which of these GROUP BY clauses will display subtotal and grand total rows?
-- GROUP BY ROLLUP (dept_name, emp_id). The parenthesis are required when using ROLLUP.
-- Which keyword, when added to a GROUP BY clause, will return all possible combination of grouping parameters? -CUBE
-- The BOOL_AND() function will return 'true' under which circumstance? All rows are true
-- Standard deviation and Variance are ways to describe what aspect of a data set? Distribution
-- In order to use the max(), min(), or avg() functions in a SELECT clause, what other clause does your query need to have?
-- GROUP BY; These three aggregate functions compute values from a group of records.
