-- Customer Sales Insights
create database ecomm_task4;
use ecomm_task4;

-- Create Tables
create table orders (
order_id varchar(50) primary key,
order_date date,
customer_id varchar(50),
region varchar(50), 
product_id varchar(50),
sale float,
profit float,
discount float, 
quantity int, 
category varchar(50));

create table product (
product_id varchar(50) primary key,
product_name varchar(50),
category varchar(50),
sub_category varchar(50));

create table customer (
customer_id varchar(50) primary key,
customer_name varchar(50),
segment varchar(50));

SELECT * FROM orders;
SELECT * FROM product;
SELECT * FROM customer;

-- 1. Total Sales by Category
SELECT category, SUM(sale) as total_sales 
FROM orders
GROUP BY category;

-- 2. Count the Number of Orders for Each Customer
SELECT c.customer_id, c.customer_name,COUNT(o.order_id) AS total_order
FROM orders o
JOIN customer c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name;

-- 3.Sales by Region with Rank
SELECT region, SUM(sale) AS total_sales,
RANK() OVER (ORDER BY SUM(sale) DESC) AS sales_rank
FROM orders
GROUP BY region;

-- 4. Analyze Customer Profitability by Segment
SELECT c.segment, SUM(o.profit) AS total_profit
FROM customer c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.segment
ORDER BY total_profit DESC
LIMIT 5;


-- 5. Rank Products by Sales within Each Category
SELECT o.category,p.product_name,SUM(sale) AS total_sales,
RANK() OVER(PARTITION BY o.category ORDER BY SUM(sale) DESC) AS sale_rank
FROM orders o
JOIN product p ON o.product_id = p.product_id
GROUP BY o.category, p.product_name
ORDER BY o.category, sale_rank;

-- 6. Total Sales per Customer by Product Category in 2024(sale>500)
CREATE VIEW total_sales_per_customer_category_2024_over_500 AS
select c.customer_id,c.customer_name, o.category,SUM(sale) AS total_sales 
FROM orders o JOIN customer c ON o.customer_id = c.customer_id
JOIN product p ON o.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY c.customer_id, c.customer_name, o.category
HAVING SUM(sale)>500 ORDER BY total_sales DESC
LIMIT 5;

SELECT * FROM total_sales_per_customer_category_2024_over_500; 

-- 7. Average Profit per Product Category in 2024
CREATE VIEW avg_profit_by_category_2024 AS
SELECT p.category,AVG(profit) as avg_profit
FROM orders o
JOIN product p on o.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.category
ORDER BY avg_profit DESC
LIMIT 5;

SELECT * FROM avg_profit_by_category_2024;

-- 8. Count the Number of quantity for Each Category
SELECT o.category,SUM(o.quantity) AS total_quantity
FROM orders o
GROUP BY o.category;

-- 9. Total revenue by sub category
SELECT p.sub_category, SUM(o.quantity*o.sale) AS total_revenue
FROM product p
JOIN orders o ON p.product_id=o.product_id
GROUP BY p.sub_category
ORDER BY total_revenue DESC;

-- 10. Total revenue earned from each customer
CREATE VIEW total_revenue_per_customer AS
SELECT o.customer_id,c.customer_name,SUM(o.quantity*o.sale) AS total_revenue
FROM customer c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY o.customer_id,c.customer_name
ORDER BY total_revenue DESC;

SELECT * FROM total_revenue_per_customer;

-- 11. Customer who haven't ordered anything
SELECT c.customer_id,c.customer_name
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.customer_id IS NULL;

-- 12. Find the second highest category for product by sales using subquery
SELECT category, total_sales
FROM (SELECT p.category, SUM(o.sale) AS total_sales
FROM orders o JOIN product p ON p.product_id = o.product_id
GROUP BY p.category) s
WHERE total_sales < (SELECT MAX(total_sales)
FROM (SELECT p2.category, SUM(o2.sale) AS total_sales
FROM orders o2 JOIN product p2 ON p2.product_id = o2.product_id
GROUP BY p2.category) t)
ORDER BY total_sales DESC
LIMIT 1;


