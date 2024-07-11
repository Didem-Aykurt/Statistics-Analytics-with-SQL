-- Didem B. Aykurt
/* We used the case statement to help us group ranked data into Core Tiles.
Let's take a closer look at the construct of a Case statement and see other ways.
Case statement allow you to add an if, then, else logic into your queries.
This allows the query to evalute a condition and return a different value, depending on the results od that evaluation.
A basic Case statement would look like this. First, it'll create a column in your query result
so treat it just like any other table column or function that you might add into the select clause of a query. 
Then, inside of the Case statement, you'll add when and then clauses. 
The when will be a condition that you'll want to evaluate and it either needs to be a true or false statement.
The then portion will control what to respond with if the when condition is true. If the first when condition is not true,
then the Case statement will move on the next when condition. 
If that one is true, then it'll return whather is written in the folowing then portion of the statement.
We can add many when and then clauses as want. At the end, we can inclued an option else keyword to capture all other conditions. 
After that, the case statement is complate so
need to the end keyword, and that's the entire construct of a Case statement.
So what Heppens if multiple when clauses are true? The sequence of conditions evaluated in each when clause is important. 
The case statement will return the value for the first when condition that is true.
Let look at the inventory datebase has a two tables. 
We have a relationship based off of the category_id column but category_id coulmn but category_id numbers are not very user-friendly.
Now we could write a query that joins the two tables together and pulls the related category description value for each product, 
or we can use Case statement to get the same result without having to perform a table join. Let's create a Case statement query*/
Select sku, 
       product_name, 
	   category_id,
     Case
	 When category_id=1 then 'Olive oils'
	 When category_id=2 then 'Flovor Infused Oils'
	 When category_id=3 then 'Bath and Beauty'
	 else 'category unknown'
	 end as "category description",
	 size, 
	 price
	 From inventory.products;

/* The COALESCE function can be used to choose an output from multiple columns, if those columns may contain null values.
It returns the first non-null value that it finds. Let demonstrate how this can be useful in a query with inventory.categories table.
Add in a new category for gift basket product line, but I will give it a category description. To do that, we need to insert into command.
The values that we're going to put in will be the number 4 a null value, and the text Gift Basket.*/
insert into inventory.categories values
(4,null, 'Gift Baskets');

--  now we can write a query using coalesce that will substitute the product line text for the description anywhere that encounters a null value.
Select category_id,
-- Create a new column, using the coalesce function. We'll prioritize the category description column, but if that one is null, 
-- we'll use product line colum. We will give new column that we're creating with the coalesce function a name, and just call it description.
-- So instead of pulling values from only the description column, we're using the COALESCE function to Prioritize the category description.
-- If the value's null, it will return the value
-- from the product line column as a fallback. The null value is baing replaced with the next from the prodcut line
-- The coalesce function allows us to effectively patch the hole in the date by substituting another value for the null.
       coalesce(category_description, product_line) as "description",
	   product_line
From inventory.categories;

/* The nullif function does the exact opposite, it turns non-null values into null
 In scientific data colection, it's not uncommon to have a dataset with someting called a canary value.
 Like an automated thermometer probe might collect temperature data every hour. If the sensor malfunctions, 
 the reported may get stored as samething like negative 9,9,9 degrees.
 This value is so far outside of the expected range that it's instantly recognizable by an analyst as a malfunction and not a true measurement.
 Here is how it is look like*/
Select sku, 
       prodcut_name, 
	   category_id,
-- When it encounters 32, it's going to replace it with a null value. Otherwise it'll just output the original size.
-- This create a new column in output results, Evertwhere that there was a size of 32 onces, 
-- the value has been replaced in query results with a null value.
	   nullif(size,32) as "size",
	   price
From inventory.products;


-- Which component is an optional part of a CASE statement? ELSE is not required in a CASE statement.
-- What is the result of this query? select coalesce('X', null, 'Z');
-- The COALESCE() function returns the first non-null value from the set of inputs. Result X
-- What is the purpose of the NULLIF() function? It turns non-null values into null.


