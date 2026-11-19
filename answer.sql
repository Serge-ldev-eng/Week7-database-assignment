
-- ============================================================
-- Week 7 Assignment: Database Design and Normalization
-- ============================================================

-- ============================================================
-- QUESTION 1: Achieving First Normal Form (1NF)
-- ============================================================
-- Problem: ProductDetail.Products contains multiple values
-- in a single cell (e.g. 'Laptop, Mouse'), violating 1NF.
-- Solution: Create a new table where each row = one product per order.
-- Each cell is atomic, no repeating groups.

CREATE TABLE ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

-- Insert normalized records: split comma-separated values
-- Original Row 101: John Doe - Laptop, Mouse
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse');

-- Original Row 102: Jane Smith - Tablet, Keyboard, Mouse
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse');

-- Original Row 103: Emily Clark - Phone
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(103, 'Emily Clark', 'Phone');

-- Verify 1NF: each row has only one product, no multi-values
-- SELECT * FROM ProductDetail_1NF;

-- ============================================================
-- QUESTION 2: Achieving Second Normal Form (2NF)
-- ============================================================
-- Original Table: OrderDetails(OrderID, CustomerName, Product, Quantity)
-- Composite Primary Key: (OrderID, Product)
-- Partial Dependency: CustomerName depends only on OrderID,
-- not on the full composite key (OrderID, Product).
-- This violates 2NF.
--
-- Solution: Decompose into 2 tables:
-- 1. Orders(OrderID, CustomerName) - CustomerName depends on OrderID only
-- 2. OrderItems(OrderID, Product, Quantity) - Quantity depends on full key

-- 1. Orders table: stores order information
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- 2. OrderItems table: stores products and quantities per order
CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert normalized records into Orders (one row per OrderID, no duplicates)
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Insert normalized records into OrderItems
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 2),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Verify 2NF:
-- SELECT * FROM Orders;
-- SELECT * FROM OrderItems;
-- SELECT o.OrderID, o.CustomerName, i.Product, i.Quantity
-- FROM Orders o
-- JOIN OrderItems i ON o.OrderID = i.OrderID
-- ORDER BY o.OrderID, i.Product;
