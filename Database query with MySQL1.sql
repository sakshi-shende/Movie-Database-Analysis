########################## ASSIGNMENT 4a SQL ##############################

# Name: Sakshi Shende
# Date: 30 October 2022

####### INSTRUCTIONS #######

# Read through the whole template and read each question carefully.  Make sure to follow all instructions.

# Each question should be answered with only one SQL query per question, unless otherwise stated.
# All queries must be written below the corresponding question number.
# Make sure to include the schema name in all table references (i.e. sakila.customer, not just customer)
# DO NOT modify the comment text for each question unless asked.
# Any additional comments you may wish to add to organize your code MUST be on their own lines and each comment line must begin with a # character
# If a question asks for specific columns and/or column aliases, they MUST be followed.
# Pay attention to the requested column aliases for aggregations and calculations. Otherwise, do not re-alias columns from the original column names in the tables unless asked to do so.
# Return columns in the order requested in the question.
# Do not concatenate columns together unless asked.

# Refer to the Sakila documentation for further information about the tables, views, and columns: https://dev.mysql.com/doc/sakila/en/

##########################################################################

## Desc: Joining Data, Nested Queries, Views and Indexes, Transforming Data

############################ PREREQUESITES ###############################

# These queries make use of the Sakila schema.  If you have issues with the Sakila schema, try dropping the schema and re-loading it from the scripts provided with Assignment 2.

# Run the following two SQL statements before beginning the questions:
SET SQL_SAFE_UPDATES=0;
UPDATE sakila.film SET language_id=6 WHERE title LIKE "%ACADEMY%";

############################### QUESTION 1 ###############################

# 1a) List the actors (first_name, last_name, actor_id) who acted in more then 25 movies.  Also return the count of movies they acted in, aliased as movie_count. Order by first and last name alphabetically.
SELECT a.first_name,
	   a.last_name,
	   a.actor_id,
       COUNT((b.film_id)) AS movie_count
FROM sakila.actor a
	JOIN sakila.film_actor b
    ON a.actor_id = b.actor_id
GROUP BY a.actor_id
HAVING COUNT((b.film_id)) > 25
ORDER BY a.first_name ASC,
		 a.last_name ASC;
         
# 1b) List the actors (first_name, last_name, actor_id) who have worked in German language movies. Order by first and last name alphabetically.
SELECT a.first_name,
	   a.last_name,
       a.actor_id
FROM sakila.actor a
	JOIN sakila.film_actor b
    ON a.actor_id = b.actor_id
    JOIN sakila.film c
    ON b.film_id = c.film_id
    JOIN sakila.language d
    ON c.language_id = d.language_id
WHERE d.name = 'German'
ORDER BY a.first_name ASC,
		 a.last_name ASC;
         
# 1c) List the actors (first_name, last_name, actor_id) who acted in horror movies and the count of horror movies by each actor.  Alias the count column as horror_movie_count. Order by first and last name alphabetically.
SELECT a.first_name,
	   a.last_name,
       a.actor_id,
       COUNT(c.film_id) AS horror_movie_count
FROM sakila.actor a
	JOIN sakila.film_actor b
    ON a.actor_id = b.actor_id
    JOIN sakila.film_category c
    ON b.film_id = c.film_id
    JOIN sakila.category d
    ON c.category_id = d.category_id
WHERE d.name = 'Horror'
GROUP BY a.actor_id
ORDER BY a.first_name ASC,
         a.last_name ASC;      
         
#1d) List the customers who rented more than 3 horror movies.  Return the customer first and last names, customer IDs, and the horror movie rental count (aliased as horror_movie_count). Order by first and last name alphabetically.
SELECT a.first_name,
	   a.last_name,
	   a.customer_id,
       COUNT(c.film_id) AS horror_movie_count
FROM sakila.customer a
	JOIN sakila.rental b
	ON a.customer_id = b.customer_id
	JOIN sakila.inventory c
	ON b.inventory_id = c.inventory_id
	JOIN sakila.film_category d
	ON c.film_id = d.film_id
	JOIN sakila.category e
	ON d.category_id = e.category_id
WHERE e.name = "Horror"
GROUP BY a.customer_id
HAVING COUNT(c.film_id) > 3
ORDER BY a.first_name ASC,
		 a.last_name ASC;

# 1e) List the customers who rented a movie which starred Scarlett Bening.  Return the customer first and last names and customer IDs. Order by first and last name alphabetically.
SELECT a.first_name,
		a.last_name,
        a.customer_id
FROM sakila.customer a
	JOIN sakila.rental b
	ON a.customer_id = b.customer_id
	JOIN sakila.inventory c
	ON b.inventory_id = c.inventory_id
	JOIN sakila.film_actor d
	ON c.film_id = d.film_id
	JOIN sakila.actor e
	ON d.actor_id = e.actor_id
WHERE e.first_name = 'Scarlett'
	AND e.last_name = 'Bening'
GROUP BY a.customer_id
ORDER BY a.first_name ASC,
		 a.last_name ASC;

# 1f) Which customers residing at postal code 62703 rented movies that were Documentaries?  Return their first and last names and customer IDs.  Order by first and last name alphabetically.
SELECT a.first_name,
	   a.last_name,
       a.customer_id
FROM sakila.customer a
	JOIN sakila.address b
    ON a.address_id = b.address_id
    JOIN sakila.rental c
    ON a.customer_id = c.customer_id
    JOIN sakila.inventory d
    ON c.inventory_id = d.inventory_id
    JOIN sakila.film_category e
    ON d.film_id = e.film_id
    JOIN sakila.category f
    ON e.category_id = f.category_id
WHERE b.postal_code = '62703'
	AND f.name = 'Documentary'
ORDER BY a.first_name ASC,
		 a.last_name ASC;

# 1g) Find all the addresses (if any) where the second address line is not empty and is not NULL (i.e., contains some text).  Return the address_id and address_2, sorted by address_2 in ascending order.
SELECT address_id,
	   address2
FROM sakila.address
WHERE address2 <>'' 
ORDER BY address2 ASC;

# 1h) List the actors (first_name, last_name, actor_id)  who played in a film involving a “Crocodile” and a “Shark” (in the same movie).  Also include the title and release year of the movie.  Sort the results by the actors’ last name then first name, in ascending order.
SELECT a.first_name,
	   a.last_name,
       a.actor_id,
       c.title,
       c.release_year
FROM sakila.actor a
	JOIN sakila.film_actor b
    ON a.actor_id = b.actor_id
    JOIN sakila.film c
    ON b.film_id = c.film_id
WHERE c.description like '%Crocodile%'
	AND c.description like '%Shark%'
ORDER BY a.last_name ASC,
	  a.first_name ASC;
      
# 1i) Find all the film categories in which there are between 55 and 65 films. Return the category names and the count of films per category, sorted from highest to lowest by the number of films.  Alias the count column as count_movies. Order the results alphabetically by category.
SELECT a.name,
	   count(b.film_id) AS count_movies
FROM sakila.category a
	JOIN sakila.film_category b
    ON a.category_id = b.category_id
GROUP BY a.name
HAVING count(b.film_id) BETWEEN 55 AND 65
ORDER BY count_movies DESC,
      a.name ASC;

# 1j) In which of the film categories is the average difference between the film replacement cost and the rental rate larger than $17?  Return the film categories and the average cost difference, aliased as mean_diff_replace_rental.  Order the results alphabetically by category.
SELECT a.name,
       AVG(c.replacement_cost - c.rental_rate) AS mean_diff_replace_rental
FROM sakila.category a
	JOIN sakila.film_category b
    ON a.category_id = b.category_id
    JOIN sakila.film c
    ON b.film_id = c.film_id
GROUP BY a.name
HAVING AVG(c.replacement_cost - c.rental_rate) > 17
ORDER BY a.name ASC;

# 1k) Create a list of overdue rentals so that customers can be contacted and asked to return their overdue DVDs. Return the title of the  film, the customer first name and last name, customer phone number, and the number of days overdue, aliased as days_overdue.  Order the results by first and last name alphabetically.
## NOTE: To identify if a rental is overdue, find rentals that have not been returned and have a rental date rental date further in the past than the film's rental duration (rental duration is in days)
SELECT e.title,
	   a.first_name,
       a.last_name,
       b.phone,
       DATEDIFF(CURRENT_DATE(),rental_date) AS days_overdue
FROM sakila.customer a
	JOIN sakila.address b
    ON a.address_id = b.address_id
    JOIN sakila.rental c
    ON a.customer_id = c.customer_id
    JOIN sakila.inventory d
    ON c.inventory_id = d.inventory_id
    JOIN sakila.film e
    ON d.film_id = e.film_id
WHERE c.return_date IS NULL
	AND c.rental_date + INTERVAL e.rental_duration DAY < CURRENT_DATE()
ORDER BY first_name ASC,
	     last_name ASC;
         
# 1l) Find the list of all customers and staff for store_id 1.  Return the first and last names, as well as a column indicating if the name is "staff" or "customer", aliased as person_type.  Order results by first name and last name alphabetically.
## Note : use a set operator and do not remove duplicates
SELECT *
FROM (
		SELECT first_name,
			   last_name,
               'Customer' AS person_type
		FROM sakila.customer
        WHERE store_id = 1
		UNION
		SELECT first_name,
			   last_name,
               'Staff' AS person_type
		FROM sakila.staff
        WHERE store_id = 1
) a
ORDER BY first_name ASC,
	last_name ASC;


############################### QUESTION 2 ###############################

# 2a) List the first and last names of both actors and customers whose first names are the same as the first name of the actor with actor_id 8.  Order in alphabetical order by last name.
## NOTE: Do not remove duplicates and do not hard-code the first name in your query.
SELECT first_name,
	   last_name
FROM sakila.actor
WHERE first_name = (SELECT first_name
					FROM sakila.actor
                    WHERE actor_id = 8)
UNION ALL
SELECT first_name,
       last_name
FROM sakila.customer
WHERE first_name = (SELECT first_name
					FROM sakila.actor
                    WHERE actor_id = 8)
ORDER BY last_name ASC;

# 2b) List customers (first name, last name, customer ID) and payment amounts of customer payments that were greater than average the payment amount.  Sort in descending order by payment amount.
## HINT: Use a subquery to help
SELECT first_name,
       last_name,
       a.customer_id,
       SUM(amount) AS payment_amount
FROM sakila.customer a
JOIN sakila.payment b
ON a.customer_id = b.customer_id
GROUP BY a.customer_id
HAVING SUM(amount) > (SELECT AVG(amount)
				FROM sakila.payment)
ORDER BY payment_amount DESC;

# 2c) List customers (first name, last name, customer ID) who have rented movies at least once.  Order results by first name, lastname alphabetically.
## Note: use an IN clause with a subquery to filter customers
SELECT first_name,
	   last_name,
       customer_id
FROM sakila.customer
WHERE customer_id IN (SELECT customer_id
                      FROM sakila.rental
                      GROUP BY customer_id
                      HAVING count(customer_id) >= 1)
ORDER BY first_name ASC,
         last_name ASC;
         
# 2d) Find the floor of the maximum, minimum and average payment amount.  Alias the result columns as max_payment, min_payment, avg_payment.
SELECT FLOOR(MAX(amount)) AS max_payment,
       FLOOR(MIN(amount)) AS min_payment,
       FLOOR(AVG(amount)) AS avg_payment
FROM sakila.payment;


############################### QUESTION 3 ###############################

# 3a) Create a view called actors_portfolio which contains the following columns of information about actors and their films: actor_id, first_name, last_name, film_id, title, category_id, category_name
CREATE VIEW sakila.actors_portfolio AS
SELECT a.actor_id,
       first_name,
       last_name,
       c.film_id,
       title,
       e.category_id,
       name
FROM sakila.actor a
JOIN sakila.film_actor b
ON a.actor_id = b.actor_id
JOIN sakila.film c
ON b.film_id = c.film_id
JOIN sakila.film_category d
ON c.film_id = d.film_id
JOIN sakila.category e
ON d.category_id = e.category_id;

# 3b) Describe (using a SQL command) the structure of the view.
DESCRIBE sakila.actors_portfolio;

# 3c) Query the view to get information (all columns) on the actor ADAM GRANT
SELECT *
FROM sakila.actors_portfolio
WHERE first_name = 'ADAM'
	AND last_name = 'GRANT';    

# 3d) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT
## NOTE: If you need to use multiple statements for this question, you may do so.
## WARNING: Do not hard-code any id numbers in your where criteria.
## !! Think about how you might do this before reading the hints below !!
## HINT 1: Given what you know about a view, can you insert directly into the view? Or do you need to insert the data elsewhere?
## HINT 2: Consider using SET and LAST_INSERT_ID() to set a variable to aid in your process.

INSERT INTO sakila.film(title, language_id, rental_duration, rental_rate, replacement_cost)
VALUES ('Data Hero',
	     (SELECT a.language_id
		  FROM sakila.language a
			JOIN sakila.film b
            ON a.language_id = b.language_id
            JOIN sakila.film_actor c
			ON b.film_id = c.film_id
            JOIN sakila.actor d
			ON c.actor_id = d.actor_id
          WHERE first_name = 'ADAM'
			AND last_name = "Grant"
		  GROUP BY a.language_id
          ORDER BY 1 DESC
          LIMIT 1),
          6,
          4.99,
          20.99);
SET @last_id_in_table1 = LAST_INSERT_ID();

INSERT INTO sakila.film_category(film_id, category_id)
VALUES (@last_id_in_table1,
		(SELECT category_id
         FROM sakila.category
         WHERE name = 'Sci-Fi')); 
         
INSERT INTO sakila.film_actor(actor_id, film_id)
VALUES ((SELECT actor_id
        FROM sakila.actor
		WHERE first_name = 'ADAM'
			AND last_name = 'GRANT'),
        @last_id_in_table1);


############################### QUESTION 4 ###############################

# 4a) Extract the street number (numbers at the beginning of the address) from the customer address in the customer_list view.  Return the original address column, and the street number column (aliased as street_number).  Order the results in ascending order by street number.
## NOTE: Use Regex to parse the street number
SELECT address,
       REGEXP_SUBSTR(address, '[0-9]+') AS street_number
FROM sakila.customer_list
ORDER BY street_number ASC;

# 4b) List actors (first name, last name, actor id) whose last name starts with characters A, B or C.  Order by first_name, last_name in ascending order.
## NOTE: Use either a LEFT() or RIGHT() operator
SELECT first_name,
       last_name,
	   actor_id
FROM sakila.actor
WHERE LEFT(last_name, 1) IN ('A', 'B', 'C')
ORDER BY first_name ASC,
         last_name ASC;         

# 4c) List film titles that contain exactly 10 characters.  Order titles in ascending alphabetical order.
SELECT title
FROM sakila.film
WHERE LENGTH(title) = 10
ORDER BY title ASC;

#4d) Return a list of distinct payment dates formatted in the date pattern that matches "22/01/2016" (2 digit day, 2 digit month, 4 digit year).  Alias the formatted column as payment_date.  Retrn the formatted dates in ascending order.
SELECT DISTINCT(DATE_FORMAT(payment_date, '%d/%m/%Y'))  AS payment_date
FROM sakila.payment
ORDER BY payment_date ASC;

#4e) Find the number of days each rental was out (days between rental_date & return_date), for all returned rentals.  Return the rental_id, rental_date, return_date, and alias the days between column as days_out.  Order with the longest number of days_out first.
SELECT rental_id, 
       rental_date,
       return_date,
       DATEDIFF(return_date, rental_date) AS days_out
FROM sakila.rental
ORDER BY days_out DESC;