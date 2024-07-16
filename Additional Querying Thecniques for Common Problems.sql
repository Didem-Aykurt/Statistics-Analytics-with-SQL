-- Didem B. Aykurt
/* When execute a query shows typically have a list of numbers down the left side of the results that indicate each rows number.
These numbers aren't part of the actual data. They're just shown as a convenience here in the graphical interface. PostgreSQL does have a row number as function that'll add this kind of sequence number as a column
in result set, which makes it convenient if you export the data to a spreatsheet or incorporate it into a report. To add a column of row numbers*/
Select sku,
       product_name,
	   size,
-- Create a column using the row number function. This is window function, so it needs an over clause. That creates an independent window frame of the data that we can sort and group within.
-- This column fills in the squence and makes it part of actual data and not just a feature of the interface.
-- This uses a window function, that means we can partition the window frame to create sequnces that resart for every group.
	   row_number() over(partition by product_name order by sku)
From inventory.products;

/* when execute a query the data types of output columns will be the same as the data types established in original table. In some graphical interfaces, this is made exclicit in the column headers.
The output result in the column headers displa the type of data each column contains. Order date is a date data type. it's possible to convert the data types on the fly. which can be useful if you need to combine values
from multiple columns using a coalesce function, or case statement. Or, if you simply need to make different kinds of data compatible. We can convert mismatched data types to a common type to work with them together. 
Now, the order date column is sorting dates. This allows PostgrSQL to calculate elapsed time, and help us restrict input to only valid dates. 
For instance, PostgreSQL would not allow us to input a date of March 38th. Sometimes we need to work with these values as a basic string of characters.
We can do that by converting this output into text. After reference to the table column type in two colons is CAST operation used to convert data from one type into another. After colon fill in the name of the data type that we want to convert to.
*/
Select order_id,
       order_date:: text,
	   customer_id
from sales.orders

/* There are two functions that will take a column of values from a table and then shift them up or down in the results. These functions are useful when you want to compare or reference values stored in adjacent rows.
Whet we need to do is shift the values up or down in the column. 
We do this with the LEAD and LAG function. LAG will shift the values down within a column. This will allow us to compare dates for each customer's next orders
The LAG function is customizable. We can specify how many rows we want to movr the data up or down. I only want to lag the data down one rows, so we type in comma, 1. This is window function,
we need an over clause within the window frame we need a create a partition. Otherwise PostrgreSQL will just shift all of the dates down by one, withoud regard for the specific customer. We 
The LEAD function in order to find the next order date The lead function works exactly the same way, but it shifts values up in the column. We will lead the order date values up by one, then we need our over clause.
We will partition by customer_id and order by the order_id
*/
Select order_id,
       customer_id,
	   order_date,
       lag(order_date,1) Over(partition by customer_id Order by order_id) 
	   as "previous order date",
	   lead(order_date,1) Over(partition by customer_id order by order_id) 
	   as "next order",
-- we can calculate elapsed time between them. In order to calculate elapsed time, we simple need to subtract one value from the other.
-- We will take the lead function subtract the current order date
       lead(order_date,1) Over(partition by customer_id order by order_id) 
	  - order_date as "time between orders"
From sales.orders
Order By customer_id, order_date;

/* When filtering the result query using a where clause. If I want to see product with three specific names I could write out the where clause like this*/
Select *
From inventory.products
where product_name = 'Delicate'
     or product_name = 'Bold'
	 or product_name = 'Light';
-- A more streamlined approach that'll get the exact same result is to use a function called IN.
-- The IN function takes a list of items and it'll compare the column against every item in the list
Select *
From inventory.products
Where product_name IN ('Delicate', 'Bold', 'Light');
-- In function can also take a select statement that returns a single column. If we want to see product details only for products that have a five or more items withing the same group.
-- First find out which product names those are.
Select product_name
From inventory.products
group by product_name
Having Count(*)>=5;
-- now up query is now returning a single column for five and more products list.
-- Copy the query and past in IN function. So this inner select statement on lines four through seven will fetch the list of items that we're interested in.
-- Then the where clause will filter the outher queries result to just the items in that list.
Select *
From inventory.products
Where product_name IN (
	Select product_name
    From inventory.products
    group by product_name
    Having Count(*)>=5);

/* PostgreSQL can create a list of sequential numbers with the generate_series function. We can customize the starting and ending number as well as the interval that numbers will be created. Like
use generate_series funtion inside the we ahve a couple options. The first number is the number the series will start with and the second number is the ending number. We can also add in an optional third parameter to control an interval. 
that generate from 100 to 120 only inclueds every fifth number
I don't think it really matters at all from a performance perspective whether you think of the function as a column or a table.
This list of items can be helpful if you only need to perform a statistical analysis or an audit of a subset of your data.
Say we want to perform a spot to perform a spot review of every tenth order. We can use the generate series function with a where clause by combining it in an function
*/
Select *
From sales.orders
Where order_id in(
      Select generate_series(0, 10000, 10)
)
Order by order_id;
-- We can use this technique with dates as well. We can find all orders where the order date is in a series.
-- The generate series function can create a list of dates within the range.
Select *
From sales.orders
Where order_date IN (
      Select generate_series('2021-03-15'::timestamp, '2021-03-31'::timestamp, '5 days')	
)
Order by order_id;

/* Challenge: Use the people_heights table in US inches.
Task: Sort people by their descending, then find how much taller each person is over the person on the row bellow.
Requirements: A row for each person in the table including columns for their person_id, name, and height_inches
An additional column that inclueds the name of person that is the next tallest. Name this column is_taller_than
A column that calculates the height diffenece between the two people. Name this column by_this_many_inches
*/
select person_id,
	   name,
	   height_inches,
	   lag(name, 1) over (order by height_inches) as is_taller_than,
	   height_inches - lag(height_inches, 1) over (order by height_inches)
		as by_this_many_inches
from public.people_heights
order by height_inches desc;

-- In order to use a sub select query within an IN() function, what criteria must be met?
-- The sub select query must return a single column.
-- What data types can be passed into the GENERATE_SERIES() function?
-- numeric or timestamp
-- Which symbols are used to cast values from one data type to another in PostgreSQL
-- You have a column of values named 'data' that contains the numbers 10, 20, 30, 40, 50. What would be the result of this function? lag(data, 1) over (order by data)
-- null, 10, 20, 30, 40. The LAG() window function shifts values down the specified number of rows.
-- The ROW_NUMBER() function requires which additional clause?
-- OVER. As a window function, the ROW_NUMBER() function requires an OVER clause.




