--Liste des 10 films les plus loués.
SELECT f.title, COUNT() nombre_de_locations
  FROM film f 
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r    ON i.inventory_id = r.inventory_id 
 GROUP BY title
 ORDER BY nombre_de_locations DESC 
 LIMIT 10;



--Acteurs ayant joué dans le plus grand nombre de films. (liste décroissante avec le nom/prénom et le nombre de films)
SELECT a.first_name, a.last_name, COUNT() nb
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
 GROUP BY fa.actor_id
 ORDER BY nb DESC;

select *
from actor a ;



--Revenu total généré par chaque magasin par mois pour l'année en cours.
-- en prenant en compte 2005 comme année en cours
SELECT s.store_id, strftime('%Y-%m', p.payment_date) annee, SUM(p.amount)
  FROM store s
  JOIN customer c ON s.store_id = c.store_id 
  JOIN payment p  ON c.customer_id = p .customer_id 
 WHERE strftime('%Y', p.payment_date) = "2005"
 GROUP BY s.store_id, strftime('%Y%m', p.payment_date);



--Les clients les plus fidèles, basés sur le nombre de locations.
SELECT c.first_name, c.last_name, COUNT() nb
  FROM customer c
  JOIN rental r ON c.customer_id = r.customer_id
 GROUP BY c.first_name, c.last_name
HAVING nb >= 30
 ORDER BY nb DESC;



--Films qui n'ont pas été loués au cours des 6 derniers mois.
SELECT MAX(rental_date), DATE(MAX(rental_date), '-6 months')  FROM rental
--2006-02-14 15:16:03.000      2005-08-14

-- requête modifiée pour prendre les 5 derniers mois et non les 6 derniers
SELECT f.film_id, f.title, r.rental_date
  FROM film f
  JOIN inventory i   ON f.film_id = i.film_id 
  JOIN rental r ON i.inventory_id = r.inventory_id
 GROUP BY f.title
HAVING MAX(strftime('%Y-%m-%d', r.rental_date)) NOT BETWEEN strftime('%Y-%m-%d', DATE((SELECT MAX(rental_date) FROM rental), '-5 months')) AND strftime('%Y-%m-%d', (SELECT MAX(rental_date) FROM rental))--strftime('%Y-%m', DATE("2006-02-14", '-6 month'))
 UNION ALL
SELECT f.film_id, f.title, NULL
  FROM film f 
  LEFT JOIN inventory i ON f.film_id = i.film_id 
  LEFT JOIN rental r ON i.inventory_id = r.inventory_id
 GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) = 0
 ;



--Le revenu total de chaque membre du personnel à partir des locations.
SELECT s.first_name, s.last_name, SUM(p.amount) total_rent
  FROM staff s
  JOIN payment p ON s.staff_id = p.staff_id 
 GROUP BY s.first_name, s.last_name;
--Jon	Stephens	33927.04
--Mike	Hillyer	33489.47

-- OU

SELECT s.first_name, s.last_name, SUM(p.amount) total_rent
  FROM staff s
  JOIN rental r  ON s.staff_id = r.staff_id
  JOIN payment p ON r.rental_id = p.rental_id
 GROUP BY s.first_name, s.last_name;
--Jon	Stephens	33881.94
--Mike	Hillyer	33524.62



--Catégories de films les plus populaires parmi les clients.
-- par rentabilité
SELECT c.name category, SUM(p.amount) total_sales
  FROM category c 
  JOIN film_category fc ON c.category_id = fc.category_id 
  JOIN film f           ON fc.film_id = f.film_id
  JOIN inventory i      ON f.film_id = i.film_id
  JOIN rental r         ON i.inventory_id = r.inventory_id 
  JOIN payment p        ON r.rental_id = p.rental_id 
 GROUP BY c.name
 ORDER BY total_sales DESC;



-- par nombre de location
SELECT c.name category, COUNT() rents
  FROM category c 
  JOIN film_category fc ON c.category_id = fc.category_id 
  JOIN film f           ON fc.film_id = f.film_id
  JOIN inventory i      ON f.film_id = i.film_id
  JOIN rental r         ON i.inventory_id = r.inventory_id
 GROUP BY c.name
 ORDER BY rents DESC;



--Durée moyenne entre la location d'un film et son retour.
SELECT AVG(JULIANDAY(r.return_date) - JULIANDAY(r.rental_date)) duration_average
  FROM rental r;

 
 
--Clients qui ont loué des films mais n'ont pas effectué de paiement pendant plus de 30 jours.
SELECT c.first_name, c.last_name,
       MAX(r1.rental_date) date1, MAX(r2.rental_date) date2,
       JULIANDAY(MAX(r1.rental_date)) - JULIANDAY(MAX(r2.rental_date)) diff
  FROM customer c
  JOIN rental r1 ON c.customer_id = r1.customer_id
  JOIN rental r2 ON c.customer_id = r2.customer_id
                AND r1.rental_date > r2.rental_date
 GROUP BY c.first_name, c.last_name
HAVING diff >= 30;
  


--Acteurs qui ont joué ensemble dans le plus grand nombre de films.
SELECT a1.first_name || " " || a1.last_name AS "Acteur n°1",
       a2.first_name || " " || a2.last_name AS "Acteur n°2",
       COUNT() nb
  FROM film_actor fa1
  JOIN actor a1       ON fa1.actor_id = a1.actor_id
  JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
                     AND fa1.actor_id < fa2.actor_id
  JOIN actor a2       ON fa2.actor_id = a2.actor_id
 GROUP BY fa1.actor_id, fa2.actor_id
 ORDER BY nb DESC;




-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

-- TEST DE RECURSIVITE

SELECT *
FROM categories;

WITH RECURSIVE children (id, name, parent_id, level, path) AS (
    SELECT id, name, parent_id, 0, name FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT 
        c.id,
        c.name, 
        c.parent_id, 
        children.level + 1,
        children.path || " > " || c.name
    FROM categories c, children
    WHERE c.parent_id = children.id
)
SELECT * FROM children;

SELECT * FROM categories c ;


