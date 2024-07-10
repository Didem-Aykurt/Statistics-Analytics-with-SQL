-- Didem B. Aykurt
-- Summary Statistics with rank function
/* Putting values in sequential order and ranking data rows is a very common analysis operation.
Ranking data is how you determine wich products sell the best and which ones are underperforming
or which items are the largest, tallest, heaviest, or most expensive and which items are the smallest,shortest
lightest, or least expensive. We rank thing from top to bottom all the time.
In Postgresql, the rank function can be used in a couple of different ways depending on the kinds of questions that looking to answer.
It can be used as a window function to provide context in line with your data rows or it can be used as an ordered set 
grouping function to answer hypothetical questions. First, lets look at using rank as a window function.*/
-- we can also partition the data within the window frame. 
-- If you wanted to rank everyone within the same biological gender
-- we can add thet into the over clause
Select name, height_inches, gender,
-- we have rank over order by height_inches descending, rank function does skip ranks when there are multiple with the same rank.
       rank() over(partition by gender order by height_inches desc),
-- And dense_rank over ordered by height_inches descending, dense_rank doesn't skip ranks when there are multiples with the same rank
       dense_rank() over(partition by gender order by height_inches desc)
From public.people_heights
order by gender, height_inches;

/* We can use rank and dense_rank function as an ordered set function within a group
This will allow you to answer hypothetical questions. Next, what exacly is a hypothetical question?
With this technique, we could get rankings for values that don't actually exist within the data and find out, 
hypothetically speaking, where they would rank if they were in the dataset.
Let take look example that easy to see what I mean*/
-- To see how values would rank if they were added to the table.
-- As a result 75" Female's ranking 1 and male is 2.
Select gender,
-- 75 is the height_inches we are looking specific value like we did percentile_cont
       rank(75) within group(order by height_inches desc)
from public.people_heights
group by rollup(gender);

-- Percenting_rank calculates the percentage rank for each row in my table when compared to all other rows in the table.
-- This tells us how many rows as a percentage of the entire dataset are above the current row
/* As a result tallest person Marcellus 0% of the rows are above theirs. Ror Steph, only .25% 
or one-quarter of a percent of the rows are above theirs.
That way we have each person's percent rank and we can use these values to divide everyonr into quartiles.*/
Select name, gender, height_inches,
       percent_rank() over(order by height_inches)
From public.people_heights
Order by height_inches desc;

/* We can do above query with a case statement that will evaluate the results of the percent rank function and return a bit of text
depending on where each person falls in the ranking. A case statement is a good way to build some logic into the query
and alter the output based off of the result of a calculation. They are basically like an If-then-else block of code
that we might use in a programming language. Let look example, when a person's percent rank is less than 25%,
then they'll be in the first quartile.
If they're less than 50%, they will be in the second quartile and so on. The case statement will automate this evaluation 
and help us place each row into the appropriate bucket.*/
Select name, gender, height_inches,
       percent_rank() over(order by height_inches),
-- Case statement, each line in the statement will start with when so when the result of this function is less than .25 
-- then they'll be in the first quartile.
       Case
	       When percent_rank() over(order by height_inches) < .25 then '1st quartile'
		   When percent_rank() over(order by height_inches) <.50 then '2nd quartile'
		   When percent_rank() over(order by height_inches) <.75 then '3rd quartile'
		   else '4th'
		   End as "quartile rank"
From public.people_heights
Order by height_inches desc;

/* Cumulative distribution and it's almost identical to the percent rank function except for one small detail.
Let look at the result of both functions side by side*/
Select name, gender, height_inches,
       percent_rank() over(order by height_inches desc),
	   -- cume_dist function works exactly the same as percent_rank and they use the same order by statement
	   -- the difference is that percent rank excludes the current row from the calculation, whereas cumulative distribution includes it.
	   -- like talk about second row cume_dist's result 0.005= 2/400 that inclued first row and precent_rank 0.002506=1/399 excludes first row
	   -- cumulative distribution returns the percentage of rows that are less than or equal to the current row
	   -- while percent_rank returns the percentage of rows that are less than the current row
       cume_dist() over(order by height_inches desc)
From public.people_heights
order by height_inches desc;

-- use Olive oil products table contain product information inclued price
-- Task write a single query that shows product price rankings over all products and price rankings
-- partitioned into category and size groups. Inclues product_name, category, size, and price
-- Sort rows so the higest priced product rank higher
-- use window functions to get a dense ranking in three different partitions using the following column names
-- return an overall_rank of product pricing across all products
-- return a rank for product pricing within the same category as category_rank
-- return a rank for product pricing within the same size as size_rank
-- sort the final result by category, then price descending

Select product_name,
       category,
	   size,
	   price,
	   dense_rank() over(order by price desc) as "overall_rank",
	   dense_rank() over(partition by category order by price desc) as "category_rank",
	   dense_rank() over(partition by size order by price desc) as "size_rank"
From public.OliveOil_products
Order by category, price desc;

-- Which value will the PERCENT_RANK() function never return? 1.5 PERCENT_RANK returns a percentage value that will always be between 0 and 1.
-- Which of these best describes the output of the cumulative distribution function CUME_DIST()? 
-- the row's sorted position, divided by the number of rows in the data set
-- Which of these is NOT true about the PostgreSQL ranking functions? DENSE_RANK() will assign different ranks to rows with the same input value. 
-- Both RANK() and DENSE_RANK() will return the same rank given the same input values.
-- Given the data set 'my_numbers' with the values 10, 20, 30, 40, 50, what would be the result of this function? 
-- select rank (28) within group (order by my_numbers desc) from dataset. 4




