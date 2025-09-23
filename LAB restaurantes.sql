-- Crear la BBDD

CREATE DATABASE Restaurante;

USE Restaurante;
 
-- Crear tabla de ventas

CREATE TABLE sales (

    customer_id VARCHAR(10),

    order_date DATE,

    product_id INT

);
 
INSERT INTO sales (customer_id, order_date, product_id) VALUES

('A', '2021-01-01', 1),

('A', '2021-01-01', 2),

('A', '2021-01-07', 2),

('A', '2021-01-10', 3),

('A', '2021-01-11', 3),

('A', '2021-01-11', 3),

('B', '2021-01-01', 2),

('B', '2021-01-02', 2),

('B', '2021-01-04', 1),

('B', '2021-01-11', 1),

('B', '2021-01-16', 3),

('B', '2021-02-01', 3),

('C', '2021-01-01', 3),

('C', '2021-01-01', 3),

('C', '2021-01-07', 3);
 
-- Crear tabla del menú

CREATE TABLE menu (

    product_id INT,

    product_name VARCHAR(50),

    price INT

);
 
INSERT INTO menu (product_id, product_name, price) VALUES

(1, 'sushi', 10),

(2, 'curry', 15),

(3, 'ramen', 12);
 
-- Crear tabla de miembros

CREATE TABLE members (

    customer_id VARCHAR(10),

    join_date DATE

);
 
INSERT INTO members (customer_id, join_date) VALUES

('A', '2021-01-07'),

('B', '2021-01-09');
 
----------------------------------------------------

-- 1. Total gastado por cada cliente

SELECT customer_id, SUM(price) AS total_gastado
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY customer_id;

-- 2. Días visitados por cliente

SELECT customer_id, COUNT(DISTINCT order_date) AS dias_visitados
FROM sales
GROUP BY customer_id;
 
-- 3. Primer artículo comprado por cada cliente

SELECT customer_id, product_name, order_date
FROM sales
JOIN menu ON sales.product_id = menu.product_id
WHERE order_date IN (
  SELECT MIN(order_date)
  FROM sales
  GROUP BY customer_id
);
 
-- 4. Artículo más comprado en el menú

SELECT m.product_name, COUNT(*) AS veces_compra
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY veces_compra DESC
LIMIT 1;
 
-- 5. Artículo más popular por cliente

SELECT s.customer_id, m.product_name, COUNT(*) AS veces
FROM sales s
JOIN menu m ON s.product_id=m.product_id
GROUP BY s.customer_id, m.product_name
ORDER BY s.customer_id, veces DESC;


-- 6. ¿Qué artículo compró primero el cliente después de convertirse en miembro?

SELECT s.customer_id, s.order_date, m.product_name
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date >= mb.join_date
ORDER BY s.customer_id, s.order_date;
 
-- 7. ¿Qué artículo se compró justo antes de que el cliente se convirtiera en miembro?

SELECT s.customer_id, s.order_date, m.product_name
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date < mb.join_date
ORDER BY s.customer_id, s.order_date;
 
-- 8. Total artículos y gasto antes de ser miembro

SELECT s.customer_id,
       COUNT(*) AS total_articulos,
       SUM(m.price) AS total_gastado
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;
 
-- 9. Puntos con regla normal (sólo miembros después de join_date)

SELECT s.customer_id,
       SUM(CASE 
				WHEN m.product_name = 'sushi' THEN m.price * 20
               ELSE m.price * 10
				END) AS puntos
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date >= mb.join_date
GROUP BY s.customer_id;
 
-- 10. Puntos con primera semana doble

SELECT s.customer_id,
       SUM(CASE 
		WHEN s.order_date BETWEEN mb.join_date AND DATE_ADD(mb.join_date, INTERVAL 6 DAY)
        THEN m.price * 20
        WHEN m.product_name = 'sushi' THEN m.price * 20
        ELSE m.price * 10
        END) AS puntos
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date >= mb.join_date AND s.order_date <= '2021-01-31'
GROUP BY s.customer_id;
 
