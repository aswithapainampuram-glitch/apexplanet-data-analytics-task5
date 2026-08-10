-- ============================================================
-- TASK 2: SQL FOR DATA EXTRACTION
-- ApexPlanet Data Analytics Internship
-- Dataset: Superstore
-- Database: SQLite
-- ============================================================


-- ============================================================
-- 1. SELECT - Display first 10 records
-- ============================================================

SELECT *
FROM superstore
LIMIT 10;


-- ============================================================
-- 2. SELECT - Display selected columns
-- ============================================================

SELECT
    "Order ID",
    "Customer Name",
    Category,
    Sales,
    Quantity,
    Profit,
    Region,
    "Order Date"
FROM superstore
LIMIT 10;


-- ============================================================
-- 3. WHERE - Orders with sales greater than 500
-- ============================================================

SELECT
    "Order ID",
    "Customer Name",
    Sales,
    Profit
FROM superstore
WHERE Sales > 500
ORDER BY Sales DESC;


-- ============================================================
-- 4. ORDER BY + LIMIT - Top 10 orders by sales
-- ============================================================

SELECT
    "Order ID",
    "Customer Name",
    Sales
FROM superstore
ORDER BY Sales DESC
LIMIT 10;


-- ============================================================
-- 5. GROUP BY - Sales by Category
-- ============================================================

SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;


-- ============================================================
-- 6. GROUP BY - Profit by Category
-- ============================================================

SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Category
ORDER BY Total_Profit DESC;


-- ============================================================
-- 7. GROUP BY - Sales by Region
-- ============================================================

SELECT
    Region,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;


-- ============================================================
-- 8. GROUP BY - Profit by Region
-- ============================================================

SELECT
    Region,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Profit DESC;


-- ============================================================
-- 9. HAVING - Categories with sales greater than 100000
-- ============================================================

SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category
HAVING SUM(Sales) > 100000
ORDER BY Total_Sales DESC;


-- ============================================================
-- 10. TOP 10 CUSTOMERS BY SALES
-- ============================================================

SELECT
    "Customer Name",
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY "Customer Name"
ORDER BY Total_Sales DESC
LIMIT 10;


-- ============================================================
-- 11. TOP 10 CUSTOMERS BY PROFIT
-- ============================================================

SELECT
    "Customer Name",
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY "Customer Name"
ORDER BY Total_Profit DESC
LIMIT 10;


-- ============================================================
-- 12. CUSTOMER SEGMENTATION BY SPENDING
-- ============================================================

SELECT
    "Customer Name",
    SUM(Sales) AS Total_Spending,

    CASE
        WHEN SUM(Sales) >= 5000 THEN 'High'
        WHEN SUM(Sales) >= 2000 THEN 'Medium'
        ELSE 'Low'
    END AS Customer_Segment

FROM superstore
GROUP BY "Customer Name"
ORDER BY Total_Spending DESC;


-- ============================================================
-- 13. MONTHLY SALES TREND
-- ============================================================

SELECT
    strftime('%Y-%m', "Order Date") AS Month,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Month
ORDER BY Month;


-- ============================================================
-- 14. MONTHLY PROFIT TREND
-- ============================================================

SELECT
    strftime('%Y-%m', "Order Date") AS Month,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Month
ORDER BY Month;


-- ============================================================
-- 15. AVERAGE, MINIMUM AND MAXIMUM SALES
-- ============================================================

SELECT
    AVG(Sales) AS Average_Sales,
    MIN(Sales) AS Minimum_Sales,
    MAX(Sales) AS Maximum_Sales
FROM superstore;


-- ============================================================
-- 16. OVERALL BUSINESS SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Quantity) AS Total_Quantity,
    SUM(Profit) AS Total_Profit,
    AVG(Sales) AS Average_Sales
FROM superstore;


-- ============================================================
-- 17. SUBQUERY
-- Customers whose sales are above average customer sales
-- ============================================================

SELECT
    "Customer Name",
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY "Customer Name"
HAVING SUM(Sales) > (
    SELECT AVG(Customer_Total)
    FROM (
        SELECT
            SUM(Sales) AS Customer_Total
        FROM superstore
        GROUP BY "Customer Name"
    )
)
ORDER BY Total_Sales DESC;


-- ============================================================
-- 18. CTE - Sales by Region
-- ============================================================

WITH region_sales AS (
    SELECT
        Region,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY Region
)

SELECT
    Region,
    Total_Sales
FROM region_sales
ORDER BY Total_Sales DESC;


-- ============================================================
-- 19. CTE - Sales by Category
-- ============================================================

WITH category_sales AS (
    SELECT
        Category,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY Category
)

SELECT
    Category,
    Total_Sales
FROM category_sales
ORDER BY Total_Sales DESC;


-- ============================================================
-- 20. RANK - Rank customers by sales
-- ============================================================

SELECT
    "Customer Name",
    SUM(Sales) AS Total_Sales,

    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank

FROM superstore
GROUP BY "Customer Name"
ORDER BY Sales_Rank;


-- ============================================================
-- 21. ROW_NUMBER - Number customers by sales
-- ============================================================

SELECT
    "Customer Name",
    SUM(Sales) AS Total_Sales,

    ROW_NUMBER() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Row_Number

FROM superstore
GROUP BY "Customer Name"
ORDER BY Row_Number;


-- ============================================================
-- 22. LAG - Compare monthly sales with previous month
-- ============================================================

WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', "Order Date") AS Month,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY Month
)

SELECT
    Month,
    Total_Sales,

    LAG(Total_Sales) OVER (
        ORDER BY Month
    ) AS Previous_Month_Sales

FROM monthly_sales
ORDER BY Month;


-- ============================================================
-- 23. LEAD - Compare monthly sales with next month
-- ============================================================

WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', "Order Date") AS Month,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY Month
)

SELECT
    Month,
    Total_Sales,

    LEAD(Total_Sales) OVER (
        ORDER BY Month
    ) AS Next_Month_Sales

FROM monthly_sales
ORDER BY Month;


-- ============================================================
-- 24. VIEW - Category Summary
-- ============================================================

CREATE VIEW IF NOT EXISTS category_summary AS

SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity

FROM superstore
GROUP BY Category;


-- ============================================================
-- 25. DISPLAY CATEGORY SUMMARY VIEW
-- ============================================================

SELECT *
FROM category_summary
ORDER BY Total_Sales DESC;


-- ============================================================
-- END OF TASK 2 SQL QUERIES
-- ============================================================