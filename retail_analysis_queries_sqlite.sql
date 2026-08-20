/* ============================================================
   Retail Sales Analytics — SQL Analysis
   Dataset: Sample Superstore (table: orders, 9994 rows)
   Author: Haitham Abdulmajeed
   Engine: SQLite (DB Browser for SQLite)

   Actual columns in the "orders" table:
   "Row ID", "Order ID", "Order Date", "Ship Date", "Ship Mode",
   "Customer ID", "Customer Name", "Segment", "Country", "City",
   "State", "Postal Code", "Region", "Product ID", "Category",
   "Sub-Category", "Product Name", "Sales", "Quantity",
   "Discount", "Profit"

   Note: "Order Date" is stored as TEXT, not DATE — queries below
   cast it where needed using SQLite date functions.
   ============================================================ */


/* ------------------------------------------------------------
   1. DATA CLEANING / VALIDATION CHECKS
   ------------------------------------------------------------ */

-- 1a. Check for missing critical values
SELECT
    SUM(CASE WHEN "Order Date" IS NULL THEN 1 ELSE 0 END) AS missing_order_date,
    SUM(CASE WHEN "Sales" IS NULL THEN 1 ELSE 0 END)      AS missing_sales,
    SUM(CASE WHEN "Profit" IS NULL THEN 1 ELSE 0 END)     AS missing_profit,
    SUM(CASE WHEN "Region" IS NULL THEN 1 ELSE 0 END)     AS missing_region
FROM orders;

-- 1b. Check for duplicate order line items
SELECT "Order ID", "Product Name", COUNT(*) AS occurrences
FROM orders
GROUP BY "Order ID", "Product Name"
HAVING COUNT(*) > 1;

-- 1c. Sanity check: negative sales or impossible discounts
SELECT *
FROM orders
WHERE "Sales" < 0
   OR "Discount" < 0
   OR "Discount" > 1;


/* ------------------------------------------------------------
   2. SALES & PROFIT OVERVIEW
   ------------------------------------------------------------ */

-- 2a. Total sales, profit, and margin by category
SELECT
    "Category",
    ROUND(SUM("Sales"), 2)  AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit,
    ROUND(SUM("Profit") * 1.0 / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin_pct
FROM orders
GROUP BY "Category"
ORDER BY total_sales DESC;

-- 2b. Top 10 sub-categories by profit
SELECT
    "Sub-Category",
    ROUND(SUM("Profit"), 2) AS total_profit
FROM orders
GROUP BY "Sub-Category"
ORDER BY total_profit DESC
LIMIT 10;

-- 2c. Sub-categories with high sales but low/negative margin
SELECT
    "Sub-Category",
    ROUND(SUM("Sales"), 2)  AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit,
    ROUND(SUM("Profit") * 1.0 / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin_pct
FROM orders
GROUP BY "Sub-Category"
HAVING SUM("Profit") * 1.0 / NULLIF(SUM("Sales"), 0) < 0.05
ORDER BY total_sales DESC;


/* ------------------------------------------------------------
   3. REGIONAL PERFORMANCE
   ------------------------------------------------------------ */

-- 3a. Sales and profit by region
SELECT
    "Region",
    ROUND(SUM("Sales"), 2)  AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit,
    COUNT(DISTINCT "Order ID") AS total_orders
FROM orders
GROUP BY "Region"
ORDER BY total_sales DESC;

-- 3b. Region ranked by profit margin
SELECT
    "Region",
    ROUND(SUM("Profit") * 1.0 / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin_pct
FROM orders
GROUP BY "Region"
ORDER BY profit_margin_pct DESC;


/* ------------------------------------------------------------
   4. YEAR-OVER-YEAR TREND
   Note: "Order Date" is TEXT in format MM/DD/YYYY.
   We extract the year using SUBSTR since SQLite has no native
   date type — this is a common real-world data quirk.
   ------------------------------------------------------------ */

WITH yearly_sales AS (
    SELECT
        SUBSTR("Order Date", -4, 4) AS sales_year,
        SUM("Sales") AS total_sales
    FROM orders
    GROUP BY SUBSTR("Order Date", -4, 4)
)
SELECT
    sales_year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_year) AS prior_year_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY sales_year))
        * 1.0 / NULLIF(LAG(total_sales) OVER (ORDER BY sales_year), 0) * 100
    , 2) AS yoy_growth_pct
FROM yearly_sales
ORDER BY sales_year;


/* ------------------------------------------------------------
   5. TOP PRODUCTS
   ------------------------------------------------------------ */

-- 5a. Top 10 products by sales
SELECT
    "Product Name",
    ROUND(SUM("Sales"), 2)  AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM orders
GROUP BY "Product Name"
ORDER BY total_sales DESC
LIMIT 10;

-- 5b. Products with high sales volume but negative profit
SELECT
    "Product Name",
    ROUND(SUM("Sales"), 2)  AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM orders
GROUP BY "Product Name"
HAVING SUM("Profit") < 0
ORDER BY total_sales DESC;


/* ------------------------------------------------------------
   6. CUSTOMER-LEVEL VIEW
   ------------------------------------------------------------ */

-- 6a. Customer count and average order value by segment
SELECT
    "Segment",
    COUNT(DISTINCT "Customer ID")                              AS total_customers,
    COUNT(DISTINCT "Order ID")                                 AS total_orders,
    ROUND(SUM("Sales") * 1.0 / NULLIF(COUNT(DISTINCT "Order ID"), 0), 2) AS avg_order_value
FROM orders
GROUP BY "Segment"
ORDER BY total_customers DESC;
