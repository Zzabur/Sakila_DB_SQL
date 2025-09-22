use sakila;

--  1- Afficher les 5 premiers Records de la table Actor
select * from actor limit 5;

 -- 2- Récupérer dans une colonne Actor_Name le full_name des acteurs sous le format: first_name + " " + last_name
alter table actor add Actor_Name varchar(90);
update actor set Actor_Name = concat(first_name," ",last_name);
-- select concat(first_name," ",last_name) as Actor_Name from actor;
-- select concat(first_name," ", last_name) as "nom complet" from actor;    -- la solution sans créer de colonne dans les données originelles

-- 3- Récupérer dans une colonne Actor_Name le full_name des acteurs sous le format: first_name en minuscule + "." + last_name en majuscule
update actor set Actor_Name = concat(lower(first_name),".",upper(last_name));

--  4- Récupérer dans une colonne Actor_Name le full_name des acteurs sous le format: last_name en majuscule + "." + premiere lettre du first_name en majuscule
update actor set Actor_Name = concat(upper(last_name),".",left(first_name, 1),substring(lower(first_name), 2));
-- select concat(upper(actor.last_name), '.', left(actor.first_name,1) ,'', lower(right(actor.first_name,length(actor.first_name)-1)))  as Actor_Name from sakila.actor;

-- 5- Trouver le ou les acteurs appelé(s) "JENNIFER"
select Actor_Name from actor where first_name = "JENNIFER" or last_name = "JENNIFER";

-- 6- Trouver les acteurs ayant des prénoms de 3 charactères.
select Actor_Name from actor where length(first_name) =3;
-- SELECT * FROM actor WHERE firstname LIKE '__';

 -- 7- Afficher les acteurs (actor_id, first_name, last_name, nbre char first_name, nbre char last_name )par ordre décroissant de longueur de prénoms
-- alter table actor add nbre_char_first_name int;
-- alter table actor add nbre_char_last_name int;
-- update actor set nbre_char_first_name = length(first_name);
-- update actor set nbre_char_last_name = length(last_name);
-- alter table actor drop column nbre_char_first_name;
-- alter table actor drop column nbre_char_last_name;
select actor_id, first_name, last_name, length(first_name), length(last_name) from actor order by length(first_name) desc;
 
-- 8- Afficher les acteurs (actor_id, first_name, last_name, nbre char first_name, nbre char last_name )par ordre décroissant de longueur de prénoms et croissant de longuer de noms
select actor_id, first_name, last_name, length(first_name), length(last_name) from actor order by length(first_name) desc, length(last_name) asc;

--  9- Trouver les acteurs ayant dans leurs last_names la chaine: "SON
select Actor_Name from actor where last_name like ("%SON%");

-- 10- Trouver les acteurs ayant des last_names commençant par la chaine: "JOH"
select Actor_Name from actor where last_name like "JOH%";

-- 11- Afficher par ordre alphabétique croissant les last_names et les first_names des acteurs ayant dans leurs last_names la chaine "LI"
select Actor_Name from actor where last_name like ("%LI%") order by last_name, first_name;

-- 12- trouver dans la table country les countries "China", "Afghanistan", "Bangladesh"
select country from country where country in ("China", "Afghanistan", "Bangladesh");

-- 13- Ajouter une colonne middle_name entre les colonnes first_name et last_name
alter table actor add middle_name varchar(45) after first_name;

--  14- Changer le data type de la colonne middle_name au type blobs
alter table actor modify column middle_name BLOB;
-- ALTER TABLE actor CHANGE COLUMN middle_name middle_name BLOB;

-- 15- Supprimer la colonne middle_name
alter table actor drop column middle_name;

-- 16- Trouver le nombre des acteurs ayant le meme last_name Afficher le resultat par ordre décroissant
select last_name, count(last_name) as "nombre d'homonyme" from actor group by last_name having count(last_name) >1 order by count(last_name) DESC;

-- 17- Trouver le nombre des acteurs ayant le meme last_name Afficher UNIQUEMENT les last_names communs à au moins 3 acteurs Afficher par ordre alph. croissant
select last_name, count(last_name) as "nombre d'homonyme (min.3)" from actor group by last_name having count(last_name) >=3 order by last_name;

-- 18- Trouver le nombre des acteurs ayant le meme first_name Afficher le resultat par ordre alph. croissant
select first_name, count(first_name) from actor group by first_name having count(first_name)>1 order by first_name;

-- 19- Insérer dans la table actor ,un nouvel acteur , faites attention à l'id!
insert into actor(first_name, last_name, Actor_name) values ("ARISTOPHANIS", "GALANOPOULOS", "GALANOPOULOS Aristophanis");

--  20- Modifier le first_name du nouvel acteur à "Jean"
update actor set first_name = "test" where actor_id = (select max(actor_id) from actor);

--  21- Supprimer le dernier acteur inséré de la table actor
delete from actor where actor_id = (select max(actor_id) from actor);
-- DELETE from actor ORDER BY actor_id DESC LIMIT 1;

--   22-Corriger le first_name de l'acteur HARPO WILLIAMS qui était accidentellement inséré à GROUCHO WILLIAMS
update actor set first_name = "HARPO" where first_name = "GROUCHO" and last_name = "WILLIAMS";

-- 23- Mettre à jour le first_name dans la table actor pour l'actor_id 173 comme suit: si le first_name ="ALAN" alors remplacer le par "ALLAN" sinon par "MUCHO ALLAN"
update actor set first_name = 
case
when first_name = "ALAN" then "ALLAN"
else "MUCHO ALLAN"
end
where actor_id = 173;

-- UPDATE actor SET first_name = IF(first_name="ALAN","ALLAN","MUCHO ALLAN") WHERE actor_id = 173;

-- 24- Trouver les first_names,last names et l'adresse de chacun des membre staff RQ: utiliser join avec les tables staff & address:
select first_name, last_name, address from staff join address on staff.address_id = address.address_id;    -- (on staff.address_id = address.address_id) => using(address_id)

-- 25- Afficher pour chaque membre du staff ,le total de ses salaires depuis Aout 2005. RQ: Utiliser les tables Staff & Payment
select first_name, last_name, sum(amount) as "salaire total depuis août 2005" from payment join staff on staff.staff_id = payment.staff_id where payment.payment_date >= "2005-08-01 00:00:00" group by first_name, last_name order by sum(amount) desc;

-- 26- Afficher pour chaque film ,le nombre de ses acteurs
select film.title, count(distinct (actor_id)) as "nombre d'acteurs.trices" from film join film_actor on film.film_id = film_actor.film_id group by film.film_id order by count(actor_id) desc;

--  27- Trouver le film intitulé "Hunchback Impossible"
select film_id from film where title = "Hunchback Impossible";

--  28- combien de copies exist t il dans le systme d'inventaire pour le film "Hunchback Impossible"
select count(inventory.film_id) as "nombre de copies de Hunchback Impossible" from inventory join film on inventory.film_id = film.film_id
where title = "Hunchback Impossible";
select count(film_id) as "nombre de copies de Hunchback Impossible" from inventory where film_id = 439;

-- 29- Afficher les titres des films en anglais commençant par 'K' ou 'Q'
select title from film join language on film.language_id = language.language_id where name = "English" and (title like "K%" or title like "Q%") order by title;

--  30- Afficher les first et last names des acteurs qui ont participé au film intitulé 'ACADEMY DINOSAUR'
select actor_name as "noms des acteurs.trices de Academy Dinosaur" from actor join film_actor on actor.actor_id = film_actor.actor_id join film on film_actor.film_id = film.film_id where film.title = "ACADEMY DINOSAUR" order by Actor_Name;

-- 31- Trouver la liste des film catégorisés comme family films.
select film.title from film join film_category on film.film_id = film_category.film_id join category on film_category.category_id = category.category_id where category.name = "Family" order by film.title;

 -- 32- Afficher le top 5 des films les plus loués par ordre decroissant
 select film.title as "Top 5", count(rental.inventory_id) as "nombre de locations" from film join inventory on film.film_id = inventory.film_id join rental on inventory.inventory_id = rental.inventory_id group by film.title order by count(rental.inventory_id) desc limit 5;
-- SELECT film.title, COUNT(rental.inventory_id) AS Count_of_Rented_Movies
-- FROM film 
-- JOIN inventory ON film.film_id = inventory.film_id 
-- JOIN rental ON inventory.inventory_id = rental.inventory_id 
-- GROUP BY film.film_id 
-- ORDER BY 2 DESC LIMIT 5;    -- 2 étant la position du paramètre dans select

 -- 33- Afficher la liste des stores : store ID, city, country
 select store_id, city.city, country.country from store join address on store.address_id = address.address_id join city on address.city_id = city.city_id join country on city.country_id = country.country_id;
 
 -- 34- Afficher le chiffre d'affaire par store. RQ: le chiffre d'affaire = somme (amount)
select store.store_id, sum(amount) from store join staff on store.store_id = staff.store_id join payment on staff.staff_id = payment.staff_id group by store.store_id order by sum(amount) desc;

select store.store_id, sum(amount) from store join customer on store.store_id = customer.store_id join payment on customer.customer_id = payment.customer_id group by store.store_id order by sum(amount) desc;

SELECT i.store_id AS store, SUM(p.amount) AS chiffre_d_affaire      -- <---- bonne réponse car Elle part du paiement → location → stock → magasin / Donc elle associe le paiement au magasin réellement concerné par l’inventaire loué / Elle suit la chaîne logique de la transaction.
FROM payment p
JOIN rental r
ON r.rental_id = p.rental_id
JOIN inventory i
ON i.inventory_id = r.inventory_id
GROUP BY i.store_id
ORDER BY chiffre_d_affaire DESC;

SELECT
  st.store_id                   AS store,
  SUM(p.amount)                 AS chiffre_affaires
FROM
  payment p
  JOIN rental r   ON p.rental_id = r.rental_id
  JOIN staff st   ON r.staff_id  = st.staff_id
GROUP BY
  st.store_id
ORDER BY
  chiffre_affaires DESC;
  
--  35- Lister par ordre décroissant le top 5 des catégories ayant le plus des revenues. RQ utiliser les tables : category, film_category, inventory, payment, et rental.
select category.name, sum(amount) 
from category 
join film_category on category.category_id = film_category.category_id 
join film on film_category.film_id = film.film_id 
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name
order by sum(amount) desc limit 5;

--  36- Créer une view top_five_genres avec les résultat de la requete precedante.
create view top_five_genres as
select category.name, sum(amount) 
from category 
join film_category on category.category_id = film_category.category_id 
join film on film_category.film_id = film.film_id 
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name
order by sum(amount) desc limit 5;

-- 37- Supprimer la table top_five_genres
drop view if exists top_five_genres;
