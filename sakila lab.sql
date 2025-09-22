-- 1. Todos los datos de actor, film y customer
USE sakila;

SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM customer;
 
-- 2. Títulos de películas


SELECT title AS títulos_películas FROM film;
 
-- 3. Idiomas únicos de películas

SELECT DISTINCT name FROM language;


-- 5.1 Número de tiendas

SELECT COUNT(store_id) AS tiendas_totales FROM store;

 
-- 5.2 Número de empleados

SELECT COUNT(staff_id) AS empleados_totales FROM staff;

 
-- 5.3 Lista de nombres de empleados

SELECT first_name, last_name FROM staff; 

-- Actores con el nombre Scarlett

SELECT first_name, last_name from actor
WHERE first_name="Scarlett";



 
-- Actores con el apellido Johansson


SELECT first_name, last_name from actor
WHERE last_name="Johansson";

-- ¿Cuántas películas están disponibles para alquilar?

SELECT COUNT(inventory_id) AS película_alquiler FROM inventory;

 
-- ¿Cuántas películas se han alquilado?


SELECT COUNT(DISTINCT inventory_id) AS películas_alquiladas FROM rental;

 
-- Período de alquiler más corto y más largo


SELECT MIN(rental_duration) AS alquiler_corto, MAX(rental_duration) AS alquiler_largo FROM film;

-- Duración más corta y más larga de una película


SELECT MIN(length) AS duración_corta, MAX(length) AS duración_larga FROM film;
 
-- Duración media de una película

SELECT AVG(length) AS duración_media FROM film;

 
-- Duración promedio en formato horas:minutos

SELECT FLOOR(AVG(length)/60) AS horas, ROUND(AVG(length)%60) AS minutos FROM film;

 
-- ¿Cuántas películas duran más de 3 horas?

SELECT COUNT(*) AS películas_más_tres_horas FROM film 
WHERE length>180;

 
-- Formatear nombre y correo electrónico

SELECT CONCAT(lower(first_name),lower(last_name), "@gmail.com") AS mail FROM customer;


 
-- Longitud del título más largo de una película


SELECT MAX(LENGTH(title)) AS título_más_largo FROM film;
 