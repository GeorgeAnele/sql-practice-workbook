/* ==========================================================
   📘 SQL PRACTICE WORKBOOK (MSSQL)
   Author: GEORGE ANELE
   Database: SalesDB
   Purpose: Practice DDL, DML, and DQL with Questions & Answers
   ========================================================== */

--------------------------------------------------------------
-- 1. DDL (Data Definition Language)
--------------------------------------------------------------

-- Q1: Create a new database called SalesDB
CREATE DATABASE SalesDB;
GO
USE SalesDB;
GO

-- Q2: Create tables (Customers, Products, Orders, Suppliers)
CREATE TABLE Customers (
    customer_id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    product_id INT NOT NULL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE Orders (
    order_id INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Suppliers (
    supplier_id INT NOT NULL PRIMARY KEY,
    supplier_name VARCHAR(50) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- Q3: Add a new column "phone_number" to Customers
ALTER TABLE Customers ADD phone_number VARCHAR(30);

-- Q4: Change Products category column size
ALTER TABLE Products ALTER COLUMN category VARCHAR(100) NOT NULL;

-- Q5: Delete the city column from Customers
ALTER TABLE Customers DROP COLUMN city;

-- Q6: Create a view to show customer names, product names, and total amount
CREATE VIEW CustomerOrdersView AS
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    p.product_name,
    o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;

--------------------------------------------------------------
-- 2. DML (Data Manipulation Language)
--------------------------------------------------------------

-- Q7: Insert customers
INSERT INTO Customers (customer_id, first_name, last_name, email, join_date, phone_number)
VALUES 
(1, 'John', 'Doe', 'john.doe@email.com', '2023-01-15', '08120000001'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2023-02-10', '08120000002'),
(3, 'Michael', 'Brown', 'michael@email.com', '2023-03-12', '08120000003'),
(4, 'Chinedu', 'Anele', 'Chidonanele448@gmail.com', '2023-06-10', '08123001381');

-- Q8: Insert products
INSERT INTO Products (product_id, product_name, category, price, stock_quantity)
VALUES 
(1, 'Laptop', 'Electronics', 1000.00, 50),
(2, 'Smartphone', 'Electronics', 600.00, 100),
(3, 'Headphones', 'Electronics', 150.00, 200),
(4, 'Office Chair', 'Furniture', 300.00, 40);

-- Q9: Insert orders
INSERT INTO Orders (order_id, customer_id, product_id, quantity, total_amount, order_date)
VALUES
(1, 1, 1, 1, 1000.00, '2023-03-15'),
(2, 2, 2, 2, 1200.00, '2023-04-01'),
(3, 3, 3, 1, 150.00, '2023-05-20');

-- Q10: Insert a new order for Jane Smith (3 Headphones)
DECLARE @customer_id INT, @product_id INT;
SELECT @customer_id = customer_id FROM Customers WHERE first_name = 'Jane' AND last_name = 'Smith';
SELECT @product_id = product_id FROM Products WHERE product_name = 'Headphones';

INSERT INTO Orders (order_id, customer_id, product_id, quantity, total_amount, order_date)
VALUES (4, @customer_id, @product_id, 3, 3 * (SELECT price FROM Products WHERE product_id = @product_id), GETDATE());

-- Q11: Update price of Laptop
UPDATE Products SET price = 1050.00 WHERE product_name = 'Laptop';

-- Q12: Reduce Smartphone stock by 5
UPDATE Products SET stock_quantity = stock_quantity - 5 WHERE product_name = 'Smartphone';

-- Q13: Delete a customer by email
DELETE FROM Customers WHERE email = 'michael@email.com';

--------------------------------------------------------------
-- 3. DQL (Data Query Language)
--------------------------------------------------------------

-- Q14: Retrieve all customers who joined after March 1, 2023
SELECT * FROM Customers WHERE join_date > '2023-03-01';

-- Q15: Retrieve all products in category 'Electronics'
SELECT * FROM Products WHERE category = 'Electronics';

-- Q16: Count total orders per customer
SELECT customer_id, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id;

-- Q17: Find the product with the highest price
SELECT TOP 1 product_id, product_name, price
FROM Products
ORDER BY price DESC;

-- Q18: Retrieve all orders where total amount > 500
SELECT * FROM Orders WHERE total_amount > 500;

-- Q19: Retrieve top 3 products with highest stock
SELECT TOP 3 product_id, product_name, stock_quantity
FROM Products
ORDER BY stock_quantity DESC;

-- Q20: Find customers who never placed an order
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q21: Calculate total sales amount per product
SELECT 
    p.product_id,
    p.product_name,
    SUM(o.quantity * p.price) AS total_sales_amount
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- Q22: Retrieve orders with customer names
SELECT 
    c.first_name,
    c.last_name,
    o.order_id,
    o.product_id,
    o.quantity,
    o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;
