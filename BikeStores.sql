CREATE DATABASE BikeStores;
USE BikeStores;

-- Sales Performance Analysis
-- What was the total annual revenue?
ALTER TABLE sales.order_items
ADD total_price FLOAT;

UPDATE sales.order_items
SET total_price = (quantity*list_price - (1-list_price*discount));

SELECT 
YEAR(o.order_date) AS order_year,
SUM(i.total_price) AS total_revenue
FROM sales.orders AS o
JOIN sales.order_items AS i
ON o.order_id = i.order_id
GROUP BY
YEAR(o.order_date)
ORDER BY
total_revenue DESC;

-- Insight: the highest total revenue was in 2017 at $4113799.37, while the lowest was in 2018 at $2162584.14.

-- What was the total monthly revenue?
SELECT 
YEAR(o.order_date) AS order_year,
MONTH(o.order_date) AS order_month,
SUM(i.total_price) AS total_revenue
FROM sales.orders AS o
JOIN sales.order_items AS i
ON o.order_id = i.order_id 
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY total_revenue DESC;

-- Insight:the highest total revenue was in April 2018 at $968983.10, while the lowest was in June 2018 at $229.99.

-- What was the total revenue per category?
SELECT 
c.category_name,
SUM(i.total_price) AS total_revenue
FROM production.products AS p
JOIN production.categories AS c
ON p.category_id = c.category_id
JOIN sales.order_items AS i
ON p.product_id = i.product_id
GROUP BY c.category_name
ORDER BY SUM(i.total_price) DESC;

-- Insight: the highest total revenue by product was Mountain Bikes at $3242524.94, while the lowest was Children Bicycles at $350537.07.

-- What was the total annual revenue for each category?
SELECT  
c.category_name,  
YEAR(o.order_date) AS order_year,  
SUM(i.total_price) AS total_revenue  
FROM sales.orders AS o  
JOIN sales.order_items AS i  
ON o.order_id = i.order_id  
JOIN production.products AS p  
ON i.product_id = p.product_id  
JOIN production.categories AS c  
ON p.category_id = c.category_id  
GROUP BY c.category_name, YEAR(o.order_date)  
ORDER BY  
total_revenue DESC;

-- Insight: the highest total annual revenue for a category was Mountain Bikes in 2016 at $1418225.17, while the lowest was Children Bicycyles in 2018 at $68780.53.

-- What was the total monthly revenue for each category?
SELECT 
c.category_name,
YEAR(o.order_date) AS order_year,
MONTH(o.order_date) AS order_month,
SUM(i.total_price) AS total_revenue
FROM sales.orders AS o
JOIN sales.order_items AS i
ON o.order_id = i.order_id 
JOIN production.products AS p
ON i.product_id = p.product_id
JOIN production.categories AS c
ON p.category_id = c.category_id
GROUP BY c.category_name, YEAR(o.order_date), MONTH(o.order_date)
ORDER BY total_revenue DESC;

-- Insight: category rith the highest total monthly revenue was Road Bikes in April 2018 at $329669.94, while the lowest was Children Bicycles in June 2018 at $229.99.

-- What were the total units sold per year?
SELECT 
YEAR(o.order_date) AS order_year,
SUM(i.quantity) AS total_unit
FROM sales.orders AS o
JOIN sales.order_items AS i
ON o.order_id = i.order_id
GROUP BY YEAR(o.order_date)
ORDER BY total_unit DESC;

-- Insight: the highest number of units sold was in 2017 with 3099 units, while the lowest was in 2018 with 1316 units.

-- Stores Peformance Analysis
-- What were the total annual units sold per store?
SELECT  
o.store_id,  
YEAR(o.order_date) AS order_year,  
SUM(i.quantity) AS total_unit  
FROM sales.orders AS o  
JOIN sales.order_items AS i  
ON o.order_id = i.order_id  
GROUP BY o.store_id, YEAR(o.order_date)  
ORDER BY total_unit DESC;

-- Insight: the highest number of units sold by a store in a single year was 2,159 units by store_id = 2 in 2017, while the lowest was 149 units by store_id = 3 in 2018.

-- What was the total revenue per store?
SELECT  
s.store_name,
SUM(i.total_price) AS total_revenue
FROM sales.orders AS o
JOIN sales.stores AS s
ON o.store_id = s.store_id
JOIN sales.order_items AS i
ON o.order_id = i.order_id
GROUP BY s.store_name
ORDER BY SUM(i.total_price) DESC;

-- Insight: the highest revenue by store was Baldwin Bikes with $6234519.49, while the lowest was Rowlett Bikes with $1025731.74.

-- What was the total annual revenue per store?
SELECT  
s.store_name,
SUM(i.total_price) AS total_revenue,
YEAR(o.order_date) AS order_year
FROM sales.orders AS o
JOIN sales.stores AS s
ON o.store_id = s.store_id
JOIN sales.order_items AS i
ON o.order_id = i.order_id
GROUP BY s.store_name, YEAR(o.order_date)
ORDER BY total_revenue DESC;

-- Insight: the highest annual revenue by store was $2957523.49 by Baldwin Bikes in 2017, while the lowest was $226682.98 by Rowlett Bikes in 2018.

-- What was the total stock per store?
SELECT
s.store_name,
SUM(sto.quantity) AS total_stock
FROM sales.stores AS s
JOIN production.stocks AS sto
ON s.store_id = sto.store_id
GROUP BY s.store_name
ORDER BY SUM(sto.quantity) DESC;

-- Insight: Rowlett Bikes had the highest total stock with 4620 units, while Baldwin Bikes had the lowest with 4359 units.

-- What was the most profitable state?
SELECT  
str.state,  
SUM(i.quantity * (i.list_price * (1 - i.discount))) AS total_revenue  
FROM sales.stores AS str  
JOIN sales.orders AS o  
ON o.store_id = str.store_id  
JOIN sales.order_items AS i 
ON i.order_id = o.order_id  
GROUP BY str.state  
ORDER BY total_revenue DESC;


-- Insight: New York was the most profitable state with the highest total revenue with $5215751.28.

-- Which regions show the highest customer concentration for potential expansion or advertising?
SELECT 
c.state, 
COUNT(c.customer_id) AS number_of_people 
FROM sales.customers AS c 
GROUP BY c.state 
ORDER BY number_of_people DESC; 

-- Inisght: New York is the region with the highest customer concentration with 1019 people, making it the ideal location for opening new stores.



– Products Performance Analysis
-- What were the total units sold per category?
SELECT 
c.category_name,
SUM(i.quantity) AS total_unit
FROM production.products AS p
JOIN production.categories AS c
ON p.category_id = c.category_id
JOIN sales.order_items AS i
ON p.product_id = i.product_id
GROUP BY c.category_name
ORDER BY SUM(i.quantity) DESC;

-- Insight: Cruisers Bicycles had the highest total units sold with 2063 units, while Electric Bikes had the lowest with 315 units.

-- What were the total units sold per brand?
SELECT
b.brand_name,
SUM(i.quantity) AS total_orders
FROM production.products AS p 
JOIN production.brands AS b
ON p.brand_id = b.brand_id
JOIN sales.order_items AS i
ON p.product_id = i.product_id 
GROUP BY b.brand_name
ORDER BY SUM(i.quantity) DESC;

-- Insight: Electra recorded the highest total units sold with 2612 units, while Strider had the lowest with 25 units.

-- What was the total stock per product?
SELECT 
p.product_name,
SUM(sto.quantity) AS total_stocks
FROM production.products AS p
JOIN production.stocks AS sto
ON p.product_id = sto.product_id
GROUP BY p.product_name
ORDER BY SUM(sto.quantity) DESC;

-- Insight: Electra Townie Original 7D - 2017 had the highest total stock with 125 units, while Trek Domane SLR Frameset - 2018 had the lowest with 5 units.

-- What was the total stock per category?
SELECT  
c.category_name,  
SUM(sto.quantity) AS total_stocks  
FROM production.stocks AS sto  
JOIN production.products AS p  
ON sto.product_id = p.product_id  
JOIN production.categories AS c  
ON p.category_id = c.category_id  
GROUP BY c.category_name  
ORDER BY total_stocks DESC;

-- Insight: Cruisers Bicycles had the highest total stock with 3378 units, while Cyclocross Bicycles had the lowest with 414 units.

– Customers Behaviour Analysis
-- Who were the top 5 customers with the most spent?
ALTER TABLE sales.customers
ADD customer_name VARCHAR(30);

UPDATE sales.customers
SET customer_name = CONCAT(first_name, ' ', last_name);

SELECT TOP 5
cu.customer_name,
SUM(i.total_price) AS total_revenue
FROM sales.orders AS o
JOIN sales.customers AS cu  
ON o.customer_id = cu.customer_id
JOIN sales.order_items AS i  
ON o.order_id = i.order_id
GROUP BY cu.customer_name
ORDER BY SUM(i.total_price) DESC;

-- Insight: The top 5 customers based on their spent were Pamelia Newman, Abby Gamble, Sharyn Hopkins, Lyndsey Bean, and Emmitt Sanchez.

-- Who were the top 5 customers with the most total units ordered?
SELECT TOP 5
cu.customer_name,
SUM(i.quantity) AS total_orders
FROM sales.orders AS o
JOIN sales.customers AS cu 
ON o.customer_id = cu.customer_id
JOIN sales.order_items AS i
ON o.order_id = i.order_id
GROUP BY cu.customer_name
ORDER BY SUM(i.quantity) DESC;

-- Insight: the top 5 customers based on their total units ordered were Emmitt Sanchez, Tameka Fisher, Pamelia Newman, Debra Burks, and Elinore Aguilar.

-- Did customer retention perform well by store and in total?
SELECT  
store_name,  
COUNT(CASE WHEN status = 'returning' THEN 1 END) AS returning_customers,  
COUNT(CASE WHEN status = 'new' THEN 1 END) AS new_customers,  
CAST(ROUND(100.0 * COUNT(CASE WHEN status = 'returning' THEN 1 END) / COUNT(*), 2) 
AS VARCHAR) + '%' AS returning_percentage  
FROM (
SELECT  
cu.customer_id,  
s.store_name,  
CASE  
WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'returning'  
ELSE 'new'  
END AS status  
FROM sales.customers AS cu  
JOIN sales.orders AS o  
ON o.customer_id = cu.customer_id  
JOIN sales.stores AS s  
ON s.store_id = o.store_id  
GROUP BY cu.customer_id, s.store_name) 
AS customer_status_by_store  
GROUP BY store_name  
ORDER BY CAST(ROUND(100.0 * COUNT(CASE WHEN status = 'returning' THEN 1 END) / COUNT(*), 2) 
AS VARCHAR) DESC;

-- Insight: Santa Cruz Bikes had the largest retention rate of customers.



– Staff Performance Analysis
-- Which staff generated the highest total revenue?
WITH staff_name_data AS(
SELECT
staff_id,
first_name,
last_name,
CONCAT(first_name, ' ', last_name) AS staff_name
FROM 
sales.staffs
)
SELECT TOP 5
st.staff_name,
s.store_name,
SUM(i.total_price) AS total_revenue
FROM sales.orders AS o 
JOIN staff_name_data AS st
ON o.staff_id = st.staff_id
JOIN sales.stores AS s
ON o.store_id = s.store_id
JOIN sales.order_items AS i
ON o.order_id = i.order_id
GROUP BY st.staff_name, s.store_name
ORDER BY SUM(i.total_price) DESC;

-- Insight: Marcelene Boyer from Baldwin Bikes generated the highest revenue, totaling $3147789.21.

– Order Overview
-- What were all the order status?
SELECT  
order_status,  
COUNT(*) AS total_orders,  
COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales.orders) AS percentage_order_status  
FROM sales.orders  
GROUP BY order_status  
ORDER BY total_orders DESC;

-- Insights: All order were 89.47% completed.


