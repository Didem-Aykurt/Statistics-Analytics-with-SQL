-- Didem B Aykurt
-- Statistics on sort data within group function
/*  
Central tendency by the mean, median, mode, and range
 Each one describes the central value in the set in a slightly 
 different way and each one can be useful in different types of analyses.
 Mean of a dataset is additional average where you add up all of the values
 and then divide by the number of data points. Avg function use 
 for that we have used with groups and window functions 
 This paper have other three measurements of central tendency starting with median.
 The median of a dataset can be found by sorting of the numeric values from low to high and then finding the value that occurs
 at the midpoint of the list. We can find median by few ways that 
 The Discreet median find the first number in the middle so the function is percentile_DISC will find the discreet median
 The continuous median would technically be the avareage of these two middle values when the set has an even number 
 of data points like 
 */
 Select gender,
 /* 0.5 is a percentage that tells the function that we're looking for value 50% of the way through the set 
 than we're processing a group of numbers
 and we need to make sure that they're sorted the syntax for is within group and 
 we can add group by for segment the height data by biological gender*/
 percentile_disc(0.5) within group(order by height_inches) as "discrete median",
 percentile_cont(0.5) within group(order by height_inches) as "continuous median"
 From public.people_heights
 Group by rollup(gender) ;
 
 /*Statistical Analysis may require split the data into four groups called quartiles.
 the value where a data point transitions between the first, second, third, and fourth quartiles can be determined
 using the same percentile functions. Our data set has even number of rows, so I'm going to sticking 
 with the continuous percentile functions.*/
 Select
 -- put in the break point from the first to second quartile, put 0.25
 percentile_cont(.25) within group(order by height_inches) as "1st quartile",
 -- from second to third quartile happens 50%, put 0.5
 percentile_cont(.50) within group(order by height_inches) as "2nd quartile",
 -- from third to fourth quartile happens 75% put 0.75
 percentile_cont(.75) within group(order by height_inches) as "3rd quartile"
 From public.people_heights;
 -- The ntile function is a window function and it can be used to break the data into groups
 -- ntile function is creating four groups with an equal number of rows
 -- ntile function si not actually giving us statistical quartiles. it just create 4 even groups
 Select name, 
        height_inches,
		ntile(4) over(order by height_inches)
From public.people_heights
Order by height_inches;

 -- Find the most frequent value within a dataset with MODE function
 -- To understand central tendency of data that 66.17 inches is the most common height
 -- this value all by itself, isn't all that useful, mode function can't tell us is how many times that height value occurs
 Select
 mode() within group(order by height_inches)
 From public.people_heights;
 -- Below the query shows how many times occurs the value in the dataset
 -- The dataset has three values has occure 3 times but mode function doesn't indicate 
 -- that other values occure with an equal frequency
 -- That is the bighest problem with the mode function in PostgreSQL
 Select height_inches, count(*)
 From public.people_heights
 group by height_inches
 order by count(*) desc;
 
 /* The range of a dataset is the last statistical measurement of
 of central tendency that we have yet to look at. 
 But this is just simple subtraction calculation and we can add a group by clause with gender*/
 Select gender,
 max(height_inches) - min(height_inches) as "height range"
 From public.people_heights
 Group By rollup(gender);
 
 /* olive oil products table contain prodcut and price information
 Find the minimum, maximum, first, second, third, and range of price for each category group*/
 Select Distinct category,
        min(price) as "min_price",
		percentile_cont(0.25) within group(order by price) as "first_quartile",
		percentile_cont(.50) within group(order by price) as "second_quartile",
		percentile_cont(.75) within group(order by price) as "third_quartile",
		Max(price) as "max_price",
		max(price) - min(price) as "price_range"
From public.products
Group by category;

-- What does the PostgreSQL RANGE() function do? There is no RANGE() function in PostgreSQL.
-- What does the NTIL() function do? It separates the data into equal groups.
-- The NTIL() function only creates groups with an equal number of rows. It does not evaluate tied values.
-- What is the mode of a data set? Be aware that the PostgreSQL MODE() function only returns one of these values 
-- if there are more than one with the same number of occurrences.
-- Which of these describes a continuous median? 
-- For datasets with an even number of data points, a continuous median will sort the data, then average the two middle values.
 
