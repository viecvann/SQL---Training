-- Step 1: Check if tables already exist and drop them if they do.
-- This ensures you don't get errors when re-running the script.
-- Creating Database
CREATE DATABASE IF NOT EXISTS Programiz;
USE Programiz; -- Makes Programiz_db the default database


DROP TABLE IF EXISTS Shippings; -- Drop 'Shippings' table if it exists
DROP TABLE IF EXISTS Orders;    -- Drop 'Orders' table if it exists
DROP TABLE IF EXISTS Customers; -- Drop 'Customers' table if it exists

-- Step 2: Create the Customers table.
-- This table stores customer information such as ID, name, age, and country.

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,         -- Unique ID for each customer
    first_name VARCHAR(100),             -- Customer's first name (up to 100 characters)
    last_name VARCHAR(100),              -- Customer's last name (up to 100 characters)
    age INT,                             -- Customer's age as an integer
    country VARCHAR(100)                 -- Customer's country
);

-- Step 3: Create the Orders table.
-- This table stores order details like item purchased, amount, and the customer who made the order.

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,            -- Unique ID for each order
    item VARCHAR(100),                   -- Item name (up to 100 characters)
    amount INT,                          -- Amount or cost of the item
    customer_id INT,                     -- Foreign key referencing Customers table
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Step 4: Create the Shippings table.
-- This table stores shipping details such as shipping status and the customer associated with it.

CREATE TABLE Shippings (
    shipping_id INT PRIMARY KEY,         -- Unique ID for each shipping record
    status VARCHAR(100),                 -- Shipping status (e.g., Pending, Delivered)
    customer INT,                        -- Foreign key referencing Customers table
    FOREIGN KEY (customer) REFERENCES Customers(customer_id)
);

-- Step 5: Insert data into the Customers table.
-- The provided data is inserted row by row.

INSERT INTO Customers (customer_id, first_name, last_name, age, country)
VALUES 
(1, 'John', 'Doe', 31, 'USA'),
(2, 'Robert', 'Luna', 22, 'USA'),
(3, 'David', 'Robinson', 22, 'UK'),
(4, 'John', 'Reinhardt', 25, 'UK'),
(5, 'Betty', 'Doe', 28, 'UAE');

-- Step 6: Insert data into the Orders table.
-- Data includes orders made by the customers.

INSERT INTO Orders (order_id, item, amount, customer_id)
VALUES
(1, 'Keyboard', 400, 4),
(2, 'Mouse', 300, 4),
(3, 'Monitor', 12000, 3),
(4, 'Keyboard', 400, 1),
(5, 'Mousepad', 250, 2);

-- Step 7: Insert data into the Shippings table.
-- Shipping data for different customers and statuses.

INSERT INTO Shippings (shipping_id, status, customer)
VALUES
(1, 'Pending', 2),
(2, 'Pending', 4),
(3, 'Delivered', 3),
(4, 'Pending', 5),
(5, 'Delivered', 1);

-- Step 8: Verify the tables and data using SELECT queries.

SELECT * FROM Customers; -- View all customers
SELECT * FROM Orders;    -- View all orders
SELECT * FROM Shippings; -- View all shipping records

SELECT * FROM Orders
WHERE amount >
	(SELECT AVG(amount)
	FROM Orders);
    
    
SELECT * FROM Customers
WHERE customer_id IN (
	SELECT customer
	FROM Shippings
	WHERE status = 'Pending'
);

SELECT status, count(status) AS Total_Delivered
FROM Shippings
GROUP BY status = 'Delivered';

SELECT item, sum(amount) AS Total_Sales
FROM Orders
GROUP BY item;

SELECT status, count(*) AS order_count -- can also be count(status)
FROM Shippings
GROUP BY status;








