USE classicmodels;
 
-- Ejercicio 1
-- Contactos de oficina: Tiene una tabla que contiene los códigos de oficina y sus números de teléfono asociados.
SELECT
  o.officeCode,
  o.phone
FROM offices AS o
ORDER BY o.officeCode;
-- Detectives de correo electrónico: ¿Puede identificar a los empleados cuyas direcciones de correo electrónico terminan en “.es”?
SELECT
  e.employeeNumber,
  e.firstName,
  e.lastName,
  e.email
FROM employees AS e
WHERE e.email LIKE '%.es'
ORDER BY e.lastName, e.firstName;

-- Estado de confusión: descubra qué clientes carecen de información estatal en sus registros.
SELECT
  c.customerNumber,
  c.customerName,
  c.city,
  c.country,
  c.state
FROM customers AS c
WHERE c.state IS NULL OR c.state = ''
ORDER BY c.country, c.city, c.customerName;
 
-- Grandes gastadores: busquemos pagos que superen los $20.000.
SELECT
  p.customerNumber,
  c.customerName,
  p.checkNumber,
  p.paymentDate,
  p.amount
FROM payments AS p
JOIN customers AS c
  ON c.customerNumber = p.customerNumber
WHERE p.amount > 20000
ORDER BY p.amount DESC, p.paymentDate DESC;

-- Grandes gastadores de 2005: Ahora, acote la lista aún más y busque los pagos mayores a $20,000 que se realizaron en el año 2005.
SELECT
  p.customerNumber,
  c.customerName,
  p.checkNumber,
  p.paymentDate,
  p.amount
FROM payments AS p
JOIN customers AS c
  ON c.customerNumber = p.customerNumber
WHERE p.amount > 20000
  AND YEAR(p.paymentDate) = 2005
ORDER BY p.amount DESC, p.paymentDate DESC;

-- Detalles distintos: busque y muestre solo las filas únicas de la tabla “orderdetails” en función de la columna “productcode”.
SELECT DISTINCT
  od.productCode
FROM orderdetails AS od
ORDER BY od.productCode;

-- Estadísticas globales de compradores: por último, cree una tabla que muestre el recuento de compras realizadas por país.

DROP VIEW IF EXISTS vw_purchases_by_country;
 
-- crear la vista
CREATE VIEW vw_purchases_by_country AS
SELECT
  c.country,
  COUNT(*) AS orders_count
FROM orders AS o
JOIN customers AS c
  ON c.customerNumber = o.customerNumber
GROUP BY c.country
ORDER BY orders_count DESC, c.country;
 
-- consultar la vista
SELECT * FROM vw_purchases_by_country;

 -- Ejercicio 2
 
-- Descripción de línea de producto más larga

SELECT productLine, CHAR_LENGTH(textDescription) AS desc_len
FROM productlines
ORDER BY desc_len DESC
LIMIT 1;
 
-- Recuento de clientes de oficina

SELECT o.officeCode, o.city, COUNT(c.customerNumber) AS customers_count
FROM offices o
LEFT JOIN employees e ON e.officeCode = o.officeCode
LEFT JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
GROUP BY o.officeCode, o.city
ORDER BY customers_count DESC, o.officeCode;
 
-- Día de mayores ventas de automóviles

SELECT DAYNAME(o.orderDate) AS day_of_week,
       COUNT(DISTINCT o.orderNumber) AS sales_count
FROM orders o
JOIN orderdetails od ON od.orderNumber = o.orderNumber
JOIN products p ON p.productCode = od.productCode
WHERE p.productLine LIKE '%Cars%'
GROUP BY day_of_week
ORDER BY sales_count DESC
LIMIT 1;
 
-- Corrección de datos territoriales faltantes

UPDATE offices
SET territory = CASE
                  WHEN territory IS NULL OR territory = '' OR territory = 'NA' THEN 'USA'
                  ELSE territory
                END;
 
-- Estadísticas de empleados de la familia Patterson (2004–2005)

WITH orders_patterson AS (
  SELECT o.orderNumber, o.orderDate
  FROM orders o
  JOIN customers c ON c.customerNumber = o.customerNumber
  JOIN employees e ON e.employeeNumber = c.salesRepEmployeeNumber
  WHERE e.lastName = 'Patterson' AND YEAR(o.orderDate) IN (2004, 2005)
),
order_totals AS (
  SELECT op.orderNumber,
         YEAR(op.orderDate) AS yr,
         MONTH(op.orderDate) AS mo,
         SUM(od.quantityOrdered * od.priceEach) AS order_total,
         SUM(od.quantityOrdered) AS items_total
  FROM orders_patterson op
  JOIN orderdetails od ON od.orderNumber = op.orderNumber
  GROUP BY op.orderNumber, yr, mo
)
SELECT yr AS year,
       mo AS month,
       ROUND(AVG(order_total), 2) AS avg_cart_amount,
       SUM(items_total) AS total_items
FROM order_totals
GROUP BY yr, mo
ORDER BY yr, mo;

-- EJERCICIO 3
 
-- 1. Análisis de compras anuales (subconsulta)

SELECT anio, mes,
       AVG(totalCarrito) AS promedioCarrito,
       SUM(totalArticulos) AS totalArticulos
FROM (SELECT YEAR(o.orderDate) AS anio,
          MONTH(o.orderDate) AS mes,
          (od.quantityOrdered * od.priceEach) AS totalCarrito,
          od.quantityOrdered AS totalArticulos
   FROM employees e
   JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
   JOIN orders o ON c.customerNumber = o.customerNumber
   JOIN orderdetails od ON o.orderNumber = od.orderNumber
   WHERE e.lastName = 'Patterson'
     AND YEAR(o.orderDate) IN (2004, 2005)
) AS sub
GROUP BY anio, mes
ORDER BY anio, mes;
 
-- 2. Oficinas con empleados que atienden clientes sin estado

SELECT DISTINCT o.officeCode, o.city, o.country
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE c.state IS NULL OR c.state = '';
 
  