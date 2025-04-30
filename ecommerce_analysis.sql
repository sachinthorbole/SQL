CREATE DATABASE ecommerce_db;
USE ecommerce_db;
Drop database


-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(100)
);

-- Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create order_items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data into customers
INSERT INTO customers VALUES
(1, 'Alice Smith', 'alice@example.com', 'New York'),
(2, 'Bob Johnson', 'bob@example.com', 'Los Angeles'),
(3, 'Carol Davis', 'carol@example.com', 'Chicago'),
(4, 'David Wilson', 'david@example.com', 'New York');

-- Insert sample data into products
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 1200.00),
(2, 'Headphones', 'Electronics', 150.00),
(3, 'Coffee Maker', 'Home Appliances', 80.00),
(4, 'Book', 'Books', 20.00);

-- Insert sample data into orders
INSERT INTO orders VALUES
(1, 1, '2023-07-10'),
(2, 2, '2023-07-11'),
(3, 1, '2023-07-15'),
(4, 3, '2023-07-16');

-- Insert sample data into order_items
INSERT INTO order_items VALUES
(1, 1, 1, 1, 1200.00),
(2, 1, 2, 2, 150.00),
(3, 2, 3, 1, 80.00),
(4, 3, 4, 3, 20.00),
(5, 4, 1, 1, 1200.00);

-- a. Basic SELECT with WHERE and ORDER BY
SELECT customer_id, name, city
FROM customers
WHERE city = 'New York'
ORDER BY name;

-- b. GROUP BY with Aggregates
SELECT p.category, SUM(oi.price * oi.quantity) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- c. JOINs (INNER, LEFT, RIGHT)
-- INNER JOIN
SELECT o.order_id, o.order_date, c.name, c.city
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- LEFT JOIN
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN
SELECT p.name, oi.quantity
FROM products p
RIGHT JOIN order_items oi ON p.product_id = oi.product_id;

-- d. Subquery Example
SELECT name, customer_id
FROM customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
    HAVING SUM(oi.price * oi.quantity) > 500
);

-- e. Creating Views for Analysis
CREATE VIEW customer_revenue AS
SELECT c.customer_id, c.name, SUM(oi.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name;

-- f. Query Optimization with Indexes
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
