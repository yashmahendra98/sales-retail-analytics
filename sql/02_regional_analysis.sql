-- ============================================================
-- QUERY 2: Regional Sales Performance (Superstore Dataset)
-- Dataset: train.csv — Superstore Sales 2015–2018
-- ============================================================

-- 2a. Sales by Region with growth index
SELECT
    Region,
    COUNT(DISTINCT "Customer ID")          AS unique_customers,
    COUNT(*)                               AS total_orders,
    ROUND(SUM(Sales), 2)                   AS total_sales,
    ROUND(AVG(Sales), 2)                   AS avg_order_value,
    ROUND(SUM(Sales) / (SELECT SUM(Sales) FROM superstore) * 100, 1) AS revenue_share_pct
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;

/*
RESULTS:
Region  | unique_customers | total_orders | total_sales | revenue_share_pct
West    | (highest)        | 3,140        | $710,220    | 31.3%
East    |                  | 2,785        | $669,519    | 29.5%
Central |                  | 2,277        | $492,647    | 21.7%
South   | (lowest)         | 1,598        | $389,151    | 17.1%  ← UNDERPERFORMER

ACTION: South region underperforms by 14% vs West. Targeted campaigns and
expanded product assortment could close this gap.
*/

-- 2b. Sub-category performance by region
SELECT
    Region,
    "Sub-Category",
    ROUND(SUM(Sales), 2)   AS total_sales,
    COUNT(*)               AS order_count
FROM superstore
GROUP BY Region, "Sub-Category"
ORDER BY Region, total_sales DESC;
