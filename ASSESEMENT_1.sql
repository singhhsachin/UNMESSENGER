-- CREATING A DATABASE 
CREATE DATABASE ORG;
USE ORG;
 
CREATE TABLE Customers (    
CustomerID INT PRIMARY KEY,    
Name VARCHAR(255),    
Email VARCHAR(255),    
JoinDate DATE 
);
 CREATE TABLE Products (    
 ProductID INT PRIMARY KEY,    
 Name VARCHAR(255),    
 Category VARCHAR(255),    
 Price DECIMAL(10, 2) ); 
 CREATE TABLE Orders (    
 OrderID INT PRIMARY KEY,    
 CustomerID INT,    
 OrderDate DATE,    
 TotalAmount DECIMAL(10, 2),    
 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID));
CREATE TABLE OrderDetails ( 
OrderDetailID INT PRIMARY KEY, 
OrderID INT, 
ProductID INT, 
Quantity INT, 
PricePerUnit DECIMAL(10, 2), 
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID), 
FOREIGN KEY (ProductID) REFERENCES Products(ProductID) );

-- Insert data into Customers table
INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES
(1, 'John Doe', 'john@example.com', '2022-01-10'),
(2, 'Jane Smith', 'jane@example.com', '2022-01-11'),
(3, 'Alice Johnson', 'alice@example.com', '2022-01-12'),
(4, 'Bob Williams', 'bob@example.com', '2022-01-13'),
(5, 'Emily Davis', 'emily@example.com', '2022-01-14'),
(6, 'Michael Brown', 'michael@example.com', '2022-01-15'),
(7, 'Olivia Jones', 'olivia@example.com', '2022-01-16'),
(8, 'David Lee', 'david@example.com', '2022-01-17'),
(9, 'Sophia White', 'sophia@example.com', '2022-01-18'),
(10, 'Daniel Miller', 'daniel@example.com', '2022-01-19');

-- Insert data into Products table
INSERT INTO Products (ProductID, Name, Category, Price) VALUES
(1, 'Laptop', 'Electronics', 899.99),
(2, 'Smartphone', 'Electronics', 599.99),
(3, 'Desk Chair', 'Furniture', 149.99),
(4, 'Headphones', 'Electronics', 49.99),
(5, 'Coffee Table', 'Furniture', 199.99),
(6, 'Printer', 'Office Supplies', 129.99),
(7, 'Dining Table', 'Furniture', 299.99),
(8, 'Tablet', 'Electronics', 349.99),
(9, 'Bookshelf', 'Furniture', 79.99),
(10, 'Desk Lamp', 'Home Decor', 29.99);

-- Insert data into Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(101, 1, '2022-01-15', 1499.97),
(102, 2, '2022-01-16', 749.98),
(103, 3, '2022-01-17', 1049.95),
(104, 4, '2023-11-18', 599.96),
(105, 5, '2023-10-19', 899.97),
(106, 6, '2023-09-20', 1349.94),
(107, 7, '2023-08-21', 249.99),
(108, 8, '2023-07-22', 1799.93),
(109, 9, '2023-12-23', 299.98),
(110, 10, '2024-01-09', 499.99);

-- Insert data into OrderDetails table
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, PricePerUnit) VALUES
(1, 101, 1, 2, 899.99),
(2, 101, 3, 1, 149.99),
(3, 102, 2, 1, 599.99),
(4, 103, 4, 3, 49.99),
(5, 104, 5, 2, 199.99),
(6, 105, 6, 1, 129.99),
(7, 106, 7, 1, 299.99),
(8, 107, 8, 2, 349.99),
(9, 108, 9, 4, 79.99),
(10, 109, 10, 1, 29.99);
/* 
   1. Basics Query.
   1.1  List of all customers */
   USE first;
    SELECT Name FROM  customers;
    /* ANSWER 1.1
John Doe
Jane Smith
Alice Johnson
Bob Williams
Emily Davis
Michael Brown
Olivia Jones
David Lee
Sophia White
Daniel Miller     
     */
    -- 1.2 Show all products in 'Electronics ' categorry 
SELECT Name FROM products
WHERE Category = 'Electronics'
;
/* Answer 1.2 
Laptop
Smartphone
Headphones
Tablet
*/

-- 1.3 Find the Total no of order placed
SELECT COUNT(OrderID) AS Total_Order 
FROM OrderDetails;
/* ANSWER 1.3 
10
*/


-- 1.4 Display the details of the most recent order
SELECT * FROM orders
ORDER BY OrderDate DESC
LIMIT 1
;
/* ANSWER NO. 1.4 
110	10	2024-01-09	499.99
*/

/* 2 jOINS AND RELATIONSHIP */
-- 2.1 List all products along with the names of the customers who ordered them.
SELECT products.Name,customers.Name FROM products
INNER JOIN orderdetails
ON products.ProductID = orderdetails.ProductID
INNER JOIN orders
ON orders.OrderID = orderdetails.OrderID
INNER JOIN customers
ON customers.CustomerID = orders.CustomerID;
/* 
Laptop	John Doe
Smartphone	Jane Smith
Desk Chair	John Doe
Headphones	Alice Johnson
Coffee Table	Bob Williams
Printer	Emily Davis
Dining Table	Michael Brown
Tablet	Olivia Jones
Bookshelf	David Lee
Desk Lamp	Sophia White
*/

-- 2.2 Show orders that include more than one product.
SELECT orders.OrderID, count(orderdetails.OrderDetailID) as Product_Count
FROM orders
JOIN orderdetails
ON orders.OrderID = orderdetails.OrderID
GROUP BY orders.OrderID
HAVING Product_Count>1
;
/* ANSWER
101	2
*/

-- 2.3 Find the total sales amount for each customer.
SELECT customers.CustomerID, customers.Name,  sum(Orders.TotalAmount) AS Total_Sales
FROM Customers
JOIN Orders 
ON customers.CustomerID = Orders.CustomerID
 GROUP BY customers.CustomerID
;
/* ANSWER
1	John Doe	1499.97
2	Jane Smith	749.98
3	Alice Johnson	1049.95
4	Bob Williams	599.96
5	Emily Davis	899.97
6	Michael Brown	1349.94
7	Olivia Jones	249.99
8	David Lee	1799.93
9	Sophia White	299.98
10	Daniel Miller	499.99
*/

/* 3 Aggregation and Grouping */
-- 3.1 Calculate the total revenue generated by each product category.
SELECT Category, SUM(Price * Quantity) AS TotalRevenue
FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Category;

-- 3.2 Determine the average order value.
SELECT AVG(TotalAmount) AS AverageOrderValue
FROM Orders;
/* ANSWER
Electronics	3449.92
Furniture	1169.92
Office Supplies	129.99
Home Decor	29.99
*/


-- 3.3. Find the month with the highest number of orders.
SELECT MONTH(OrderDate) AS OrderMonth, COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY OrderMonth
ORDER BY OrderCount DESC
LIMIT 1;


/* 4. Subqueries and Nested Queries:*/
-- 4.1 Identify customers who have not placed any orders.
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

-- 4.2. Find products that have never been ordered.
SELECT * FROM Products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails);

-- 4.3. Show the top 3 best-selling products.
SELECT Products.*, SUM(Quantity) AS TotalSold
FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductID
ORDER BY TotalSold DESC
LIMIT 3;
/* ANSWER
9	Bookshelf	Furniture	79.99	4
4	Headphones	Electronics	49.99	3
1	Laptop	Electronics	999.99	2
*/


/*  5. Date and Time Functions: */
-- 5.1. List orders placed in the last month.
SELECT * FROM Orders
WHERE OrderDate >= NOW() - INTERVAL 1 MONTH;
/* ANSWER
109	9	2023-12-23	299.98
110	10	2024-01-09	499.99
*/


-- 5.2. Determine the oldest customer in terms of membership duration.
SELECT * FROM Customers
ORDER BY JoinDate ASC
LIMIT 1;
/* ANSWER 
1	John Doe	john@example.com	2022-01-10
*/

/* 6. Advanced Queries: */
-- 6.1. Rank customers based on their total spending.
SELECT Customers.CustomerID, Name, SUM(TotalAmount) AS TotalSpending
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY CustomerID, Name
ORDER BY TotalSpending DESC;
/* ANSWER
8	David Lee	1799.93
1	John Doe	1499.97
6	Michael Brown	1349.94
3	Alice Johnson	1049.95
5	Emily Davis	899.97
2	Jane Smith	749.98
4	Bob Williams	599.96
10	Daniel Miller	499.99
9	Sophia White	299.98
7	Olivia Jones	249.99
*/

-- 6.2. Identify the most popular product category.
SELECT Category, SUM(Quantity) AS TotalSold
FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Category
ORDER BY TotalSold DESC
LIMIT 1;
/* ANSWER 
Electronics	8
*/

-- 6.3 Calculate the month-over-month growth rate in sales.
SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    SUM(TotalAmount) AS MonthlySales,
    LAG(SUM(TotalAmount)) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)) AS PrevMonthSales,
    CASE
        WHEN LAG(SUM(TotalAmount))
        OVER (ORDER BY YEAR(OrderDate),
        MONTH(OrderDate)) = 0 THEN NULL
        ELSE
        ((SUM(TotalAmount) - LAG(SUM(TotalAmount))
        OVER (ORDER BY YEAR(OrderDate),
        MONTH(OrderDate))) / LAG(SUM(TotalAmount))
        OVER (ORDER BY YEAR(OrderDate),
        MONTH(OrderDate))) * 100
    END AS GrowthRate
FROM Orders
GROUP BY OrderYear, OrderMonth
ORDER BY OrderYear, OrderMonth;
/*ANSWER
2022	1	3299.90		
2023	7	1799.93	3299.90	-45.455014
2023	8	249.99	1799.93	-86.111127
2023	9	1349.94	249.99	439.997600
2023	10	899.97	1349.94	-33.332593
2023	11	599.96	899.97	-33.335556
2023	12	299.98	599.96	-50.000000
2024	1	499.99	299.98	66.674445
*/


/* 7. Data Manipulation and Updates: */
-- 7.1. Add a new customer to the Customers table.
INSERT INTO Customers (CustomerID,Name, Email, JoinDate) VALUES
(11, 'New Customer', 'new@example.com', '2024-02-10');

-- 7.2. Update the price of a specific product.
UPDATE Products SET Price = 999.99 WHERE ProductID = 1;





    
   
