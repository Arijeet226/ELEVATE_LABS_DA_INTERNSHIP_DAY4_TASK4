# ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4
Task 4: SQL for Data Analysis, Objective: Use SQL queries to extract and analyze data from a database.

DATASET USED:- https://github.com/KalyaniS29/SQL_SALES

### ABOUT DATA:-
product.csv
ProductID: unique product key like PROD001, used to join from orders.
ProductName: descriptive item name such as Laptop, Desk, or Monitor.
Category: top-level group such as Technology, Furniture, or Office Supplies.
SubCategory: finer grouping like Computers, Office Furniture, Stationery, Mobile Phones, Office Machines, or Accessories.

customer.csv
CustomerID: unique customer key like CUST001, referenced by orders.
CustomerName: person or account name, for example John Doe or Jane Smith.
Segment: customer segment label such as Consumer, Corporate, or Home Office.

order.csv
OrderID: unique order code such as ORD001.
OrderDate: order date, formatted as YYYY-MM-DD with values in 2024.
CustomerID: foreign key linking to customer.csv CustomerID.
Region: geographic region of the order such as East, West, South, or North.
ProductID: foreign key linking to product.csv ProductID.
Sales: revenue amount per order line (numeric), for example 250 or 700.
Profit: profit amount per order line (numeric), for example 50 or 150.
Discount: fractional discount rate per line (e.g., 0.10 means 10%).
Quantity: units sold on the line (integer), for example 1–10.
# Summary queries

## Q1-Total sales by category
```sql
SELECT category, SUM(sale) as total_sales 
FROM orders
GROUP BY category;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/158b7ff013e407d232b785ad35cfae38c3393bb7/Final_output_task4_SS/Screenshot%202025-09-26%20184858.png)

## Q2-Count the Number of Orders for Each Customer
```sql
SELECT c.customer_id, c.customer_name,COUNT(o.order_id) AS total_order
FROM orders o
JOIN customer c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185750.png)


## Q3-Sales by Region with Rank
```sql
SELECT region, SUM(sale) AS total_sales,
RANK() OVER (ORDER BY SUM(sale) DESC) AS sales_rank
FROM orders
GROUP BY region;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185139.png)


## Q4-Analyze Customer Profitability by Segment
```sql
SELECT c.segment, SUM(o.profit) AS total_profit
FROM customer c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.segment
ORDER BY total_profit DESC
LIMIT 5;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185220.png)

## Q5-Rank Products by Sales within Each Category
```sql
SELECT o.category,p.product_name,SUM(sale) AS total_sales,
RANK() OVER(PARTITION BY o.category ORDER BY SUM(sale) DESC) AS sale_rank
FROM orders o
JOIN product p ON o.product_id = p.product_id
GROUP BY o.category, p.product_name
ORDER BY o.category, sale_rank;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185240.png)

## Q6- Total Sales per Customer by Product Category in 2024(sale>500)
```sql
CREATE VIEW total_sales_per_customer_category_2024_over_500 AS
select c.customer_id,c.customer_name, o.category,SUM(sale) AS total_sales 
FROM orders o JOIN customer c ON o.customer_id = c.customer_id
JOIN product p ON o.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY c.customer_id, c.customer_name, o.category
HAVING SUM(sale)>500 ORDER BY total_sales DESC
LIMIT 5;

SELECT * FROM total_sales_per_customer_category_2024_over_500; 
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185317.png)


## Q7- Average Profit per Product Category in 2024
```sql
CREATE VIEW avg_profit_by_category_2024 AS
SELECT p.category,AVG(profit) as avg_profit
FROM orders o
JOIN product p on o.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.category
ORDER BY avg_profit DESC
LIMIT 5;

SELECT * FROM avg_profit_by_category_2024;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185359.png)


## Q8- Count the Number of quantity for Each Category
```sql
SELECT o.category,SUM(o.quantity) AS total_quantity
FROM orders o
GROUP BY o.category;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185411.png)

## Q9- Total revenue by sub category
```sql
SELECT p.sub_category, SUM(o.quantity*o.sale) AS total_revenue
FROM product p
JOIN orders o ON p.product_id=o.product_id
GROUP BY p.sub_category
ORDER BY total_revenue DESC;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185425.png)

## Q10- Total revenue earned from each customer
```sql
CREATE VIEW total_revenue_per_customer AS
SELECT o.customer_id,c.customer_name,SUM(o.quantity*o.sale) AS total_revenue
FROM customer c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY o.customer_id,c.customer_name
ORDER BY total_revenue DESC;

SELECT * FROM total_revenue_per_customer;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185619.png)


## Q11- Customer who haven't ordered anything
```sql
SELECT c.customer_id,c.customer_name
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.customer_id IS NULL;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185719.png)

## Q12- Find the second highest category for product by sales using subquery
```sql
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
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/cf603642292a58ea88976fcef29c8854cb784b81/Final_output_task4_SS/Screenshot%202025-09-26%20185820.png)



