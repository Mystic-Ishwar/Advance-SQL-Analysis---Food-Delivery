# Food Delivery SQL Analysis 🍕

## Project Overview
This project performs an in-depth SQL analysis on a Zomato/Swiggy-style 
food delivery platform database. It covers business intelligence queries 
ranging from basic aggregations to advanced window functions and stored procedures.

## Database Schema
food_delivery
│
├── users         (user_id, user_name, city, age)
├── restaurants   (restaurant_id, restaurant_name, city, cuisine)
├── menu          (menu_id, restaurant_id, item_name, price)
└── orders        (order_id, user_id, menu_id, quantity, price, 
                   total_amount, order_date, payment_method)


## Tools Used
- MySQL 8.0
- MySQL Workbench

## Dataset
- Users: 2,000 records
- Restaurants: 400 records
- Menu Items: 2,000 records
- Orders: 10,000 records

## Business Questions Solved

###  Basic Analysis
-Question -> Key Result
-Q1 Total Revenue -> ₹8,616,377 
-Q2 Total Orders -> 10,000 
-Q3 Most Used Payment Method -> UPI (3,378) 
-Q4 Top 5 Cities by Orders -> Jaipur, Ahmedabad, Lucknow, Pune, Mumbai 
-Q5 Top 5 Restaurants by Revenue -> Royal Kitchen 143 (₹46,354) 

###  Intermediate Analysis
-Question -> Key Result 
-Q6  Most Ordered Food Item -> Burger (1,159) 
-Q7  Average Order Value -> ₹861.64 
-Q8  Orders Per Month -> Peak in Dec 2024 & Jan 2024 
-Q9  Top 5 Customers by Spending -> Rahul Gupta (₹1,20,822) 
-Q10 Most Popular Cuisine -> Indian (2,624 orders) 

### Advanced Analysis
 -Question ->Key Result 
 -Q11 Rank Restaurants by Revenue -> Window Function — RANK() 
 -Q12 Running Total by Date -> CTE + SUM OVER() 
 -Q13 Most Ordered Item Per City -> ROW_NUMBER() + PARTITION BY 
 -Q14 Most Ordered Item Per Cuisine -> Indian → Biryani 
 -Q15 Most Frequent Customers -> Rahul Gupta (129 orders) 

### Stored Procedures
- `TopCustomers()` — Top 5 customers by spending
- `TopRestaurants()` — Top 5 restaurants by revenue
- `MonthlyRevenue()` — Monthly revenue report

## SQL Concepts Used
- SELECT, WHERE, GROUP BY, ORDER BY, LIMIT
- JOINS (INNER JOIN) — multiple table joins
- Subqueries
- CTEs (Common Table Expressions)
- Window Functions — RANK(), ROW_NUMBER(), PARTITION BY
- Stored Procedures
- Aggregate Functions — SUM, COUNT, AVG

## Key Insights
1. Total platform revenue is ₹8.6M across 10,000 orders
2. UPI is the most preferred payment method (33.8%)
3. Jaipur is the most active city for food orders
4. Burger is the most ordered food item overall
5. Indian cuisine dominates with 2,624 orders
6. Royal Kitchen is the top performing restaurant brand
7. Average order value is ₹861
8. Rahul Gupta is both the highest spender and most frequent customer
9. December 2024 was the peak month for orders
10. Each city has different food preferences

## How to Run
1. Clone this repository
2. Open MySQL Workbench
3. Run `food_delivery_analysis.sql`
4. All queries and procedures will be created automatically

