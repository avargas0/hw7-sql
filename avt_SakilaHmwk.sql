USE sakila; 

#Query 1a: Display the first & last name of all the actors from the table, "actor."
SELECT first_name, last_name 
  FROM actor
  ;

#Query 1b: Display the first & last name of eac actor in a single column in upper case ltrs.
#Name the column "Actor Name."
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
  FROM actor
  ; 

#Query 2a: Find the ID number, first name and last name of an actor,
#of whom you know only the first name, "Joe." 
SELECT actor_id, first_name, last_name
  FROM actor
  WHERE first_name = "JOE" 
  ;
  
#Query 2b: Find all actors whose last name contain the letters "GEN."
SELECT last_name
  FROM actor
  WHERE last_name LIKE '%GEN%'
  ;

#Query 2c: Find all actors whose last name contain the letters "LI." 
#Order the rows by last name and first name. 
SELECT last_name, first_name
  FROM actor
  WHERE last_name LIKE '%LI%'
  ORDER BY last_name, first_name  
  ;

#Query 2d: Using "IN," display the "country_id" and "country" columns of the following:
#Afghanistan, Bangladesh, and China.
SELECT country_id, country
  FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
  ;

#Query 3a: Create a column in the table `actor` named `description` and use the data type `BLOB`
ALTER TABLE actor
  ADD COLUMN description BLOB AFTER last_name
  ;

#Query 3b: Delete the `description` column.
ALTER TABLE actor
  DROP COLUMN description
  ;

#Query 4a: List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*)
  FROM actor
  GROUP BY last_name
  ;

#Query 4b: List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*)
  FROM actor
  GROUP BY last_name
  HAVING count(*) >= 2
  ;

#4c: The actor 'HARPO WILLIAMS' was accidentally entered in the `actor` table as 'GROUCHO WILLIAMS.' 
#Write a query to fix the record.
SELECT actor_id, first_name, last_name
  FROM actor
  WHERE first_name = "Groucho" 
  ;
UPDATE actor
  SET first_name = 'HARPO'
  WHERE actor_id = 172
  ;

#4d: In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor
  SET first_name = 'GROUCHO'
  WHERE actor_id = 172
  ;

#Query 5: You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address; 

#Or:
DESCRIBE address; 

#Query 6a: Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`
SELECT s.last_name, s.first_name, a.address 
  FROM staff s
  LEFT JOIN address a ON 
  s.address_id=a.address_id
  ;

#Query 6b: Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
#Use tables `staff` and `payment`

SELECT CONCAT(s.first_name, ' ', s.last_name) AS 'Staff Name',
  CONCAT('$', FORMAT(SUM(p.amount), 2)) AS 'Amount'
  FROM payment p
  INNER JOIN staff s ON 
  s.staff_id=p.staff_id
  WHERE payment_date 
    BETWEEN CAST('2005-08-01' AS DATETIME)
    AND CAST('2005-08-31' AS DATETIME)
  GROUP BY s.staff_id
  ;

#Query 6c: List each film and the number of actors who are listed for that film. 
#Use tables `film_actor` and `film`. Use inner join.
SELECT f.title, COUNT(fa.actor_id)
  FROM film_actor fa
  INNER JOIN film f ON 
  fa.film_id=f.film_id
  GROUP BY f.title
  ;

#Query 6d: How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT f.title, COUNT(i.inventory_id) 
  FROM inventory i
  JOIN film f ON 
  f.film_id=i.film_id
  WHERE f.title LIKE 'Hunchback Impossible'
  GROUP BY f.film_id
  ;

#Query 6e: Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
#List the customers alphabetically by last name.
SELECT CONCAT(c.last_name, ', ', c.first_name) AS 'Staff',
  CONCAT('$', FORMAT(SUM(p.amount), 2)) AS 'Amount'
  FROM customer c
  INNER JOIN payment p ON 
  c.customer_id=p.customer_id
  GROUP BY c.last_name
  ;

#Query 7a: #Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title 
  FROM film f
  WHERE ((f.title LIKE 'K%') OR
          f.title LIKE 'Q%') AND
            (f.language_id IN 
               (SELECT language_id 
                  FROM language l
                  WHERE l.name = 'English'))
                  ;
                  film
#Query 7b: Use subqueries to display all actors who appear in the film `Alone Trip`
SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'Actor' 
  FROM actor a, 
       film_actor fa
  WHERE fa.film_id IN 
	(SELECT film_id
       FROM film f
       WHERE f.title = 'Alone Trip')
  AND fa.actor_id = a.actor_id
  ;

#Query 7c: You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.
SELECT last_name, first_name, email, country
  FROM customer c 
  INNER JOIN address a ON 
  c.address_id = a.address_id
  INNER JOIN city cy ON 
  a.city_id=cy.city_id
  INNER JOIN country cn on 
  cy.country_id=cn.country_id
  WHERE country = 'Canada'
  ;
	
#Query 7d: Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as _family_ films.
SELECT title, name 
	FROM film f 
    INNER JOIN film_category fc ON 
    f.film_id=fc.film_id
    INNER JOIN category c ON 
    fc.category_id=c.category_id
    WHERE name = 'family'
    ;

#Query 7e: Display the most frequently rented movies in descending order.
SELECT i.film_id, f.title, COUNT(*) AS rented
	FROM rental r,
		inventory i,
        film f
    WHERE r.inventory_id = i.inventory_id
    AND i.film_id = f.film_id
    GROUP BY i.film_id, f.title
    ORDER BY rented DESC
    ;

#Query 7f: Write a query to display how much business, in dollars, each store brought in.
SELECT c.store_id, CONCAT('$', FORMAT(SUM(p.amount), 2)) AS 'Revenue'
  FROM customer c,
	payment p
	WHERE p.customer_id = p.customer_id
    GROUP BY c.store_id
    ;

#Query 7g: Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, cy.city, cn.country
	FROM store s,
		address a,
        city cy,
        country cn
	WHERE s.address_id=a.address_id
    AND a.city_id=cy.city_id
    AND cy.country_id=cn.country_id
    ;

#Query 7h: List the top five genres in gross revenue in descending order.
SELECT c.name AS 'Genre', CONCAT('$', FORMAT(SUM(p.amount), 2)) AS 'Gross Revenue'
	FROM category c, 
		payment p,
        rental r,
        inventory i,
        film_category fc
	WHERE p.rental_id=r.rental_id
    AND r.inventory_id=i.inventory_id
    AND i.film_id=fc.film_id
    AND fc.category_id=c.category_id
    GROUP BY c.name
    ORDER BY 2 DESC
    LIMIT 5
    ;

#Query 8a: In your new role as an executive, you would like to have an easy way of viewing 
#the Top five genres by gross revenue. Use the solution from the problem above to create a view.
CREATE VIEW Genre_Gross_Revenue AS 
	(SELECT c.name AS 'Genre', CONCAT('$', FORMAT(SUM(p.amount), 2)) AS 'Gross Revenue'
	FROM category c, 
		payment p,
        rental r,
        inventory i,
        film_category fc
	WHERE p.rental_id=r.rental_id
    AND r.inventory_id=i.inventory_id
    AND i.film_id=fc.film_id
    AND fc.category_id=c.category_id
    GROUP BY c.name
    ORDER BY 2 DESC
    LIMIT 5)
    ;

#Query 8b: How would you display the view that you created in 8a?
SHOW CREATE VIEW Genre_Gross_Revenue; 
SELECT * FROM Genre_Gross_Revenue;

#Query 8c: You find that you no longer need the view `top_five_genres`. 
#Write a query to delete it.
DROP VIEW Genre_Gross_Revenue;


