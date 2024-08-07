/*Day 21
Advanced SQL Functions
Explore windows funtion and store procedure
*/

-- calculate cummulative sales amount from deach product
-- (**Cumulative sales for a product are the running total of sales amounts for that product over time. **)
CREATE TABLE order_details2 (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2)
);

INSERT INTO order_details2 (order_detail_id, order_id, product_id, quantity, price) VALUES
(1, 1, 101, 2, 50.00),
(2, 2, 101, 1, 50.00),
(3, 3, 102, 3, 30.00),
(4, 4, 101, 4, 50.00),
(5, 5, 103, 2, 40.00);

select * from order_details2;
select *, 
sum(quantity*price) over (partition by   product_id order by product_id  )
from order_details2
order by  product_id
;



-- create store procedure insert new  a new customers into the database.
-- calculate top 3 customer interm of total order  amount and find % of each customer order amount  compare to total. 

select * from customers2;
select * from orders2;

with top_3 as(
select o.customer_id,sum(o.order_amount) as total_order_amount,c.customer_name from orders2 o
join customers2 c on o.customer_id=c.customer_id
group by o.customer_id
order by  sum(o.order_amount) desc
limit 3)


select *,sum(total_order_amount) over() as total_sales_amount_over,
concat(round((total_order_amount/sum(total_order_amount) over() *100),2),"%") as "% contribution per customer"
 from top_3
;

/*
Your query looks good and should correctly calculate the
 top 3 customers by total order amount and their percentage contribution to the total sales amount.
 Here is the formatted query:

```sql
WITH top_3 AS (
    SELECT o.customer_id, SUM(o.order_amount) AS total_order_amount, c.customer_name
    FROM orders2 o
    JOIN customers2 c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
    ORDER BY SUM(o.order_amount) DESC
    LIMIT 3
)
SELECT 
    customer_id, 
    customer_name,
    total_order_amount,
    SUM(total_order_amount) OVER() AS total_sales_amount_over,
    CONCAT(ROUND((total_order_amount / SUM(total_order_amount) OVER()) * 100, 2), '%') AS "% contribution per customer"
FROM top_3;
```

### Explanation

1. **Common Table Expression (CTE) - `top_3`**:
    - Aggregates the total order amount for each customer.
    - Joins the `orders2` table with the `customers2` table to get the customer names.
    - Groups by `customer_id` and `customer_name`.
    - Orders the results by the total order amount in descending order.
    - Limits the results to the top 3 customers.

2. **Final SELECT**:
    - Retrieves the customer ID, customer name, and total order amount.
    - Calculates the total sales amount for the top 3 customers using `SUM(total_order_amount) OVER()`.
    - Calculates the percentage contribution of each customer's order amount to the total sales amount.
    - Formats the percentage contribution with two decimal places and appends a '%' sign.

This query should give you the top 3 customers, their total order amounts, the total sales amount for the top 3,
 and the percentage contribution of each customer to the total.
*/





CREATE TABLE customers2 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE orders2 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_amount DECIMAL(10, 2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers2(customer_id)
);

-- Sample data for customers
INSERT INTO customers2 (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David');

-- Sample data for orders
INSERT INTO orders2 (order_id, customer_id, order_amount, order_date) VALUES
(1, 1, 200.00, '2024-04-01'),
(2, 2, 300.00, '2024-04-02'),
(3, 1, 150.00, '2024-04-03'),
(4, 3, 400.00, '2024-04-04'),
(5, 2, 250.00, '2024-04-05'),
(6, 1, 350.00, '2024-04-06'),
(7, 4, 100.00, '2024-04-07');



-- create store procedure to update salary of   employee and log changes in seperate table

-- calcualte avg rating for each product and assing rank base on their rating
CREATE TABLE products2 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE ratings2 (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    rating INT,
    FOREIGN KEY (product_id) REFERENCES products2(product_id)
);

-- Insert sample data into products table
INSERT INTO products2 (product_id, product_name) VALUES
(1, 'Product A'),
(2, 'Product B'),
(3, 'Product C');

-- Insert sample data into ratings table
INSERT INTO ratings2 (product_id, rating) VALUES
(1, 5),
(1, 4),
(1, 3),
(2, 4),
(2, 4),
(2, 5),
(3, 3),
(3, 2),
(3, 4);

select * from products2;
select * from ratings2;
with avg_rating as(
select p.product_id,p.product_name,avg(r.rating) as rating from products2 p
join ratings2 r
on p.product_id=r.product_id
group by p.product_id
order by avg(r.rating) desc
)
select *,rank() over(order by rating desc) product_rank from  avg_rating
;




/* chatgpt
WITH avg_rating AS (
    SELECT 
        p.product_id, 
        p.product_name, 
        AVG(r.rating) AS rating 
    FROM 
        products2 p
    JOIN 
        ratings2 r ON p.product_id = r.product_id
    GROUP BY 
        p.product_id
    ORDER BY 
        AVG(r.rating) DESC
)
SELECT 
    *,
    RANK() OVER (ORDER BY rating DESC) AS product_rank
FROM 
    avg_rating;
*/



-- implement new records to  insert new order  along with  its order items into database
-- retive top 5 product  based on cummulative sales  amount  using windows funtion..

CREATE TABLE products3 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE sales3 (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    sale_amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES products3(product_id)
);

-- Sample data for products3
INSERT INTO products3 (product_id, product_name) VALUES
(1, 'Product A'),
(2, 'Product B'),
(3, 'Product C'),
(4, 'Product D'),
(5, 'Product E'),
(6, 'Product F');

-- Sample data for sales3
INSERT INTO sales3 (product_id, sale_amount) VALUES
(1, 100.00),
(1, 200.00),
(2, 300.00),
(3, 150.00),
(4, 50.00),
(5, 250.00),
(6, 400.00),
(2, 100.00),
(3, 200.00),
(1, 300.00);
select * from products3;
select * from sales3;

with top_5 as (
select p.product_name,sum(s.sale_amount) as total_sales from products3 p
join sales3 s on p.product_id=s.product_id
group by p.product_id,p.product_name
order by sum(s.sale_amount) desc
limit 5)
select *,
dense_rank() over(order by total_sales desc) as product_rank from top_5;



-- calculate avg rating for each product and assign rank base of their dating

select * from products2;
select * from ratings2;
with avg_rating as(
select p.product_id,p.product_name,avg(r.rating) as rating from products2 p
join ratings2 r
on p.product_id=r.product_id
group by p.product_id
order by avg(r.rating) desc
)
select *,rank() over(order by rating desc) product_rank from  avg_rating
;


-- create store procedure to delete  customers and  all associated  orders and  order items  from database, 
-- retrieve top 3 employee based of their total sales amount  using winow fuction..alter
-- create procedure to update quality of stock  for speific product  and log changes in new.seperate table
