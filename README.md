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

## Q1-Total sales by category
```sql
SELECT category, SUM(sale) as total_sales 
FROM orders
GROUP BY category;
```
![](https://github.com/Arijeet226/ELEVATE_LABS_DA_INTERNSHIP_DAY4_TASK4/blob/158b7ff013e407d232b785ad35cfae38c3393bb7/Final_output_task4_SS/Screenshot%202025-09-26%20184858.png)

Category: product category repeated on the order line for convenience and aligns with product.csv Category.

