-- Step 1: Create a new database safely
DROP DATABASE IF EXISTS learningjoins; -- Ensures any existing database with the same name is dropped to avoid conflicts
CREATE DATABASE learningjoins; -- Creates a new database named 'learningjoins'
USE learningjoins; -- Sets the current database context to 'learningjoins'

-- Step 2: Create tables with necessary constraints
CREATE TABLE IF NOT EXISTS Customerinfo (
  ID_Customerinfo INT(10) PRIMARY KEY, -- Unique identifier for each customer
  Country VARCHAR(25), -- Stores the country of the customer
  Gender VARCHAR(10), -- Stores the gender of the customer
  Age INT(25) -- Stores the age of the customer
);

-- Insert data into Customerinfo table
-- Using ON DUPLICATE KEY UPDATE to avoid duplicate entries and ensure data integrity
INSERT INTO Customerinfo (ID_Customerinfo, Country, Gender, Age)
VALUES
  (9, 'UK', 'M', 32), -- Inserts a male customer from the UK, aged 32
  (2, 'Canada', 'F', 44), -- Inserts a female customer from Canada, aged 44
  (12, 'UK', 'M', 36), -- Inserts another male customer from the UK, aged 36
  (4, 'Australia', 'F', 56), -- Inserts a female customer from Australia, aged 56
  (8, 'USA', 'M', 29), -- Adds a male customer from the USA, aged 29
  (3, 'India', 'F', 35), -- Adds a female customer from India, aged 35
  (10, 'Germany', 'M', 40), -- Adds a male customer from Germany, aged 40
  (22, 'France', 'F', 28) -- Adds a female customer from France, aged 28
ON DUPLICATE KEY UPDATE
  Country = VALUES(Country), -- Updates country if ID_Customerinfo already exists
  Gender = VALUES(Gender), -- Updates gender if ID_Customerinfo already exists
  Age = VALUES(Age); -- Updates age if ID_Customerinfo already exists

CREATE TABLE IF NOT EXISTS Customer_orders (
  OrderID INT(10) PRIMARY KEY, -- Unique identifier for each order
  ID_Customerinfo INT(10), -- Links the order to a customer in Customerinfo
  ItemName VARCHAR(30), -- Stores the name of the item ordered
  ProductPrice DECIMAL(10,2), -- Stores the price of the item ordered
  FOREIGN KEY (ID_Customerinfo) REFERENCES Customerinfo(ID_Customerinfo) -- Establishes a relationship to the Customerinfo table
);

-- Insert data into Customer_orders table
-- Ensures each row is unique and avoids duplicate entries using ON DUPLICATE KEY UPDATE
INSERT INTO Customer_orders (OrderID, ID_Customerinfo, ItemName, ProductPrice)
VALUES
  (6333, 2, 'Toaster', 17.99), -- Order for a toaster linked to customer ID 2
  (3434, 8, 'Set of 3 Nested Tables', 105.99), -- Order for nested tables linked to customer ID 8
  (3433, 4, 'Electric Toothbrush', 45.99), -- Order for an electric toothbrush linked to customer ID 4
  (1443, 3, '4 Person Tent', 220.99), -- Order for a tent linked to customer ID 3
  (4678, 10, 'Upright Fan', 41.99), -- Order for a fan linked to customer ID 10
  (5244, 22, 'Henry Hoover', 111.99) -- Order for a hoover linked to customer ID 22
ON DUPLICATE KEY UPDATE
  ID_Customerinfo = VALUES(ID_Customerinfo), -- Updates customer ID if OrderID already exists
  ItemName = VALUES(ItemName), -- Updates item name if OrderID already exists
  ProductPrice = VALUES(ProductPrice); -- Updates product price if OrderID already exists

-- Step 3: Demonstrating SQL Joins with detailed explanations

-- 3.1 INNER JOIN
-- Purpose: Combines rows from both tables where there is a matching value in the specified column(s).
-- Explanation:
--  - Only returns rows where Customerinfo.ID_Customerinfo matches Customer_orders.ID_Customerinfo.
--  - Excludes rows that do not have a match in both tables.
-- Use case: To find orders along with customer details for matched IDs.
SELECT
  Customerinfo.ID_Customerinfo, -- Customer ID from Customerinfo
  Customerinfo.Country, -- Country from Customerinfo
  Customer_orders.ItemName, -- Item name from Customer_orders
  Customer_orders.ProductPrice, -- Product price from Customer_orders
  Customer_orders.OrderID -- Order ID from Customer_orders
FROM Customerinfo
INNER JOIN Customer_orders
  ON Customerinfo.ID_Customerinfo = Customer_orders.ID_Customerinfo; -- Joins on matching customer IDscustomerinfocustomerinfo

-- 3.2 LEFT JOIN
-- Purpose: Retrieves all rows from the left table (Customerinfo), with matching rows from the right table (Customer_orders).
-- Explanation:
--  - If there is no match, columns from the right table will contain NULL.
--  - This is useful when you want to include all customers, even if they haven’t placed an order.
SELECT
  Customerinfo.ID_Customerinfo, -- Customer ID from Customerinfo
  Customerinfo.Country, -- Country from Customerinfo
  Customer_orders.ItemName, -- Item name from Customer_orders (NULL if no match)
  Customer_orders.ProductPrice -- Product price from Customer_orders (NULL if no match)
FROM Customerinfo
LEFT JOIN Customer_orders
  ON Customerinfo.ID_Customerinfo = Customer_orders.ID_Customerinfo; -- Joins on matching customer IDs

-- 3.3 RIGHT JOIN
-- Purpose: Retrieves all rows from the right table (Customer_orders), with matching rows from the left table (Customerinfo).
-- Explanation:
--  - If there is no match, columns from the left table will contain NULL.
--  - This is useful to find all orders, even if the customer details are missing.
SELECT
  Customer_orders.ID_Customerinfo, -- Customer ID from Customer_orders
  Customer_orders.ItemName, -- Item name from Customer_orders
  Customerinfo.Country, -- Country from Customerinfo (NULL if no match)
  Customerinfo.Age -- Age from Customerinfo (NULL if no match)
FROM Customerinfo
RIGHT JOIN Customer_orders
  ON Customerinfo.ID_Customerinfo = Customer_orders.ID_Customerinfo; -- Joins on matching customer IDs

-- 3.4 FULL OUTER JOIN (Simulated in MySQL using UNION)
-- Purpose: Combines the results of LEFT JOIN and RIGHT JOIN.
-- Explanation:
--  - Includes all rows from both tables.
--  - Rows that do not have a match in either table will contain NULL for the non-matching columns.
-- Use case: To identify matching and non-matching rows across two tables.
SELECT
  Customerinfo.ID_Customerinfo, -- Customer ID from Customerinfo
  Customerinfo.Country, -- Country from Customerinfo
  Customer_orders.ItemName, -- Item name from Customer_orders (NULL if no match)
  Customer_orders.ProductPrice -- Product price from Customer_orders (NULL if no match)
FROM Customerinfo
LEFT JOIN Customer_orders
  ON Customerinfo.ID_Customerinfo = Customer_orders.ID_Customerinfo
UNION
SELECT
  Customer_orders.ID_Customerinfo, -- Customer ID from Customer_orders
  Customerinfo.Country, -- Country from Customerinfo (NULL if no match)
  Customer_orders.ItemName, -- Item name from Customer_orders
  Customer_orders.ProductPrice -- Product price from Customer_orders
FROM Customer_orders
LEFT JOIN Customerinfo
  ON Customerinfo.ID_Customerinfo = Customer_orders.ID_Customerinfo; -- Joins on matching customer IDs

-- 3.5 CROSS JOIN
-- Purpose: Creates a Cartesian product of rows from both tables.
-- Explanation:
--  - Every row from the first table is paired with every row from the second table.
--  - Use with caution, as it can result in a very large number of rows if both tables are large.
-- Use case: To create combinations of data that do not depend on matching keys.
SELECT
  Customerinfo.Country, -- Country from Customerinfo
  Customerinfo.Gender, -- Gender from Customerinfo
  Customer_orders.ItemName, -- Item name from Customer_orders
  Customer_orders.ProductPrice -- Product price from Customer_orders
FROM Customerinfo
CROSS JOIN Customer_orders; -- Combines all rows from both tables

-- Step 4: Explanation of concepts
-- INNER JOIN: Matches rows with a common key in both tables and excludes unmatched rows.
-- LEFT JOIN: Includes all rows from the left table, adding NULLs for non-matching rows from the right table.
-- RIGHT JOIN: Includes all rows from the right table, adding NULLs for non-matching rows from the left table.
-- FULL OUTER JOIN: Combines all rows from both tables, with NULLs for unmatched rows (simulated with UNION in MySQL).
-- CROSS JOIN: Produces every possible pair of rows from the two tables, without any condition.

-- Safety Notes:
-- 1. Use IF EXISTS to avoid errors when recreating tables or databases.
-- 2. Use ON DUPLICATE KEY UPDATE to prevent duplicate data during INSERT.
-- 3. Always test queries on a non-production database.
