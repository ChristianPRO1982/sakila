SELECT first_name
  FROM actor;
  
SELECT last_name
  FROM actor; 
 
SELECT film_id, COUNT() nb
  FROM film_category
 GROUP BY film_id
HAVING nb > 0; 
 

SELECT f.release_year, f.title, a.first_name || " " || a.last_name full_name, c.name, l.name
  FROM film f
  JOIN film_actor fa ON f.film_id = fa.film_id 
  JOIN actor a ON fa.actor_id = a.actor_id
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  LEFT JOIN "language" l ON f.language_id = l.language_id  
 ORDER BY 1 DESC, 2, 3;
 



SELECT DISTINCT last_name
  FROM actor
 WHERE last_name LIKE "a%";

SELECT DISTINCT last_name
  FROM actor
 WHERE last_name LIKE "ak%";


  WITH aaa AS (SELECT DISTINCT last_name
  FROM actor
 WHERE last_name LIKE "a%"),
       bbb AS (SELECT DISTINCT last_name
  FROM actor
 WHERE last_name LIKE "ak%")
SELECT *
  FROM aaa
UNION
--UNION ALL
--INTERSECT
--EXCEPT
SELECT *
  FROM bbb;
 
 

