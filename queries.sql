CREATE DATABASE Food_DeliveryDB;
Use Food_DeliveryDB;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    city VARCHAR(50),
    age INT
);

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100),
    city VARCHAR(50),
    cuisine VARCHAR(50)
);

CREATE TABLE menu (
    menu_id INT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    menu_id INT,
    quantity INT,
    price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    payment_method VARCHAR(50)
);

--after importing all the csv files to respective tables


Select Count(*) from menu;
Select Count(*) from orders;
Select Count(*) from restaurants;
Select Count(*) from users;

-- Food Delivery SQL Analysis
-- Dataset: Zomato Type Food Delivery
-- Tool: MySQL

-- ================================
-- BASIC ANALYSIS
-- ================================

-- Q1. Total Revenue
SELECT SUM(total_amount) AS total_revenue
FROM orders;
-- Result: 8,616,377.00

-- Q2. Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;
-- Result: 10,000

-- Q3. Most Used Payment Method
SELECT payment_method, COUNT(*) AS total
FROM orders
GROUP BY payment_method
ORDER BY total DESC;
-- Result: UPI 3378, Card 3324, COD 3298
-- Insight: UPI is most popular payment method

-- Q4. Top 5 Cities by Orders
SELECT u.city, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN users u ON o.user_id = u.user_id
GROUP BY u.city
ORDER BY total_orders DESC
LIMIT 5;
-- Result: Jaipur 1104, Ahmedabad 1093, 
--         Lucknow 1073, Pune 1065, Mumbai 995
-- Insight: Jaipur is the most active city for orders

-- Q5. Top 5 Restaurants by Revenue
SELECT r.restaurant_name, SUM(o.total_amount) AS revenue
FROM orders o
JOIN menu m ON o.menu_id = m.menu_id
JOIN restaurants r ON m.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY revenue DESC
LIMIT 5;
-- Result: Royal Kitchen 143 → 46,354
--         Spice Hub 59 → 41,988
--         Royal Kitchen 55 → 41,948
-- Insight: Royal Kitchen brand dominates top revenue

-- ================================
-- INTERMEDIATE  ANALYSIS
-- ================================

-- Q6. Most Ordered Food Item
SELECT m.item_name, COUNT(o.menu_id) AS total_count
FROM orders o
JOIN menu m ON o.menu_id = m.menu_id
GROUP BY m.item_name
ORDER BY total_count DESC
LIMIT 3;
-- Result: Burger 1159, Fried Rice 1120, Pasta 1073
-- Insight: Burger is most popular food item

-- Q7. Average Order Value
SELECT AVG(total_amount) AS avg_order_value
FROM orders;
-- Result: 861.64
-- Insight: Average customer spends ₹861 per order

-- Q8. Orders Per Month
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;
-- Insight: Dec 2024 & Jan 2024 peak months (650+)
-- May 2025 low (313) -- incomplete month data

-- Q9. Top 5 Customers by Spending
SELECT u.user_name, SUM(o.total_amount) AS total
FROM orders o
JOIN users u ON o.user_id = u.user_id
GROUP BY u.user_name
ORDER BY total DESC
LIMIT 5;
-- Result: Rahul Gupta 1,20,822 | Pooja Verma 1,05,769
-- Insight: Rahul Gupta is highest spending customer

-- Q10. Most Popular Cuisine
SELECT r.cuisine, COUNT(o.order_id) AS total_count
FROM orders o
JOIN menu m ON o.menu_id = m.menu_id
JOIN restaurants r ON m.restaurant_id = r.restaurant_id
GROUP BY cuisine
ORDER BY total_count DESC
LIMIT 3;
-- Result: Indian 2624, Italian 2365, Chinese 2323
-- Insight: Indian cuisine is most ordered

-- ================================
-- ADVANCED ANALYSIS
-- ================================

-- Q11. Rank Restaurants by Revenue
SELECT 
    restaurant_name,
    revenue,
    RANK() OVER(ORDER BY revenue DESC) AS rank_no
FROM (
    SELECT r.restaurant_name, SUM(o.total_amount) AS revenue
    FROM orders o
    JOIN menu m ON o.menu_id = m.menu_id
    JOIN restaurants r ON m.restaurant_id = r.restaurant_id
    GROUP BY r.restaurant_name
) AS subquery;
-- Insight: Royal Kitchen 143 is #1 with 46,354 revenue
-- Royal Kitchen brand dominates top rankings

-- Q12. Running Total of Revenue by Date
WITH daily_revenue AS (
    SELECT order_date, SUM(total_amount) AS daily_total
    FROM orders
    GROUP BY order_date
)
SELECT 
    order_date,
    daily_total,
    SUM(daily_total) OVER(ORDER BY order_date) AS running_total
FROM daily_revenue
ORDER BY order_date;
-- Insight: Total revenue reached 8.6M by May 2025
-- Consistent daily orders throughout the period

-- Q13. Most ordered item per city
WITH city_food AS (
    SELECT 
        u.city,
        m.item_name,
        COUNT(*) AS order_count,
        ROW_NUMBER() OVER(PARTITION BY u.city ORDER BY COUNT(*) DESC) AS rn
    FROM orders o
    JOIN users u ON o.user_id = u.user_id
    JOIN menu m ON o.menu_id = m.menu_id
    GROUP BY u.city, m.item_name
)
SELECT city, item_name, order_count
FROM city_food
WHERE rn = 1
ORDER BY city;
--Ahmedabad    Burger     124
--Bangalore    Pasta      113
--Chennai      Pasta      111
--Delhi        Fried Rice 121
--Hyderabad    Pasta      114
--Jaipur       Burger     130
--Kolkata      Burger     119
--Lucknow      Fried Rice 126
--Mumbai       Burger     122
--Pune         Burger     131

-- Q14. Most Ordered Item Per Cuisine
SELECT 
    r.cuisine,
    m.item_name,
    COUNT(*) AS order_count
FROM orders o
JOIN menu m ON o.menu_id = m.menu_id
JOIN restaurants r ON m.restaurant_id = r.restaurant_id
GROUP BY r.cuisine, m.item_name
ORDER BY r.cuisine, order_count DESC;
-- Q14. Most Ordered Item Per Cuisine
-- Result: Chinese → Roll(313), Fast Food → Fried Rice(326)
--         Indian → Biryani(327), Italian → Paneer Tikka(324)
-- Insight: Each cuisine has different most popular item
--          Indian cuisine loves Biryani most!

-- Q15. Customer Who Ordered Most Times
SELECT u.user_name, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN users u ON o.user_id = u.user_id
GROUP BY u.user_name
ORDER BY total_orders DESC
LIMIT 5;
-- Result: Rahul Gupta 129, Pooja Verma 128
-- Insight: Rahul Gupta is most frequent customer

-- ================================
-- Procedures
-- ================================
--Procedure 3: Top 5 customers by Total spent
DELIMITER //
CREATE PROCEDURE TopCustomers()
BEGIN
    SELECT u.user_name, SUM(o.total_amount) AS total_spent
    FROM orders o
    JOIN users u ON o.user_id = u.user_id
    GROUP BY u.user_name
    ORDER BY total_spent DESC
    LIMIT 5;
END //
DELIMITER ;

-- Call 
CALL TopCustomers();

-- Procedure 2: Top 5 Restaurants by Revenue
DELIMITER //
CREATE PROCEDURE TopRestaurants()
BEGIN
    SELECT r.restaurant_name, SUM(o.total_amount) AS revenue
    FROM orders o
    JOIN menu m ON o.menu_id = m.menu_id
    JOIN restaurants r ON m.restaurant_id = r.restaurant_id
    GROUP BY r.restaurant_name
    ORDER BY revenue DESC
    LIMIT 5;
END //
DELIMITER ;

CALL TopRestaurants();

-- Procedure 3: Monthly Revenue Report
DELIMITER //
CREATE PROCEDURE MonthlyRevenue()
BEGIN
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(total_amount) AS monthly_revenue
    FROM orders
    GROUP BY YEAR(order_date), MONTH(order_date)
    ORDER BY year, month;
END //
DELIMITER ;

CALL MonthlyRevenue();