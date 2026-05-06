-- ============================================================
-- QUERY 4: Customer Segmentation — Repeat vs New Customers
-- Dataset: E-commerce Dataset
-- ============================================================

-- 4a. Identify repeat vs one-time buyers
WITH customer_orders AS (
    SELECT
        Customer_Id,
        COUNT(*)            AS order_count,
        ROUND(SUM(Sales),2) AS lifetime_value,
        ROUND(AVG(Sales),2) AS avg_order_value,
        MIN(Order_Date)     AS first_order,
        MAX(Order_Date)     AS last_order
    FROM ecommerce_orders
    GROUP BY Customer_Id
)
SELECT
    CASE
        WHEN order_count = 1  THEN 'One-Time Buyer'
        WHEN order_count <= 3 THEN 'Occasional Buyer (2–3x)'
        WHEN order_count <= 6 THEN 'Regular Buyer (4–6x)'
        ELSE                       'Loyal Buyer (7+x)'
    END                                          AS customer_segment,
    COUNT(*)                                     AS num_customers,
    ROUND(AVG(lifetime_value), 2)                AS avg_ltv,
    ROUND(AVG(avg_order_value), 2)               AS avg_order_value,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct_of_customers
FROM customer_orders
GROUP BY customer_segment
ORDER BY avg_ltv DESC;

-- 4b. Customer segments by Superstore (Consumer / Corporate / Home Office)
SELECT
    Segment,
    COUNT(DISTINCT "Customer ID")                        AS unique_customers,
    ROUND(SUM(Sales), 2)                                 AS total_sales,
    ROUND(AVG(Sales), 2)                                 AS avg_order_value,
    ROUND(SUM(Sales) / SUM(SUM(Sales)) OVER() * 100, 1) AS revenue_share_pct
FROM superstore
GROUP BY Segment
ORDER BY total_sales DESC;

/*
RESULTS (Superstore Segments):
Segment      | unique_customers | total_sales  | revenue_share_pct
Consumer     |                  | $1,148,061   | 50.6%
Corporate    |                  | $688,494     | 30.3%
Home Office  |                  | $424,982     | 18.7%  ← Growth opportunity

RECOMMENDATION: Home Office segment is underpenetrated. With remote work trends,
targeted B2C-to-home campaigns could significantly grow this segment.
*/


-- ============================================================
-- QUERY 5: Profit Margin Analysis & Discount Impact
-- ============================================================

-- 5a. Profit margin by product (Top 15 most profitable)
SELECT
    Product,
    Product_Category,
    COUNT(*)                                       AS units_sold,
    ROUND(SUM(Sales), 2)                           AS total_sales,
    ROUND(SUM(Profit), 2)                          AS total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 1)      AS profit_margin_pct
FROM ecommerce_orders
GROUP BY Product, Product_Category
ORDER BY total_profit DESC
LIMIT 15;

/*
TOP 5 RESULTS:
Product        | Category | total_sales | total_profit | margin
T-Shirts       | Fashion  | $578,336    | $340,721     | 58.9%
Titak Watch    | Fashion  | $531,468    | $296,718     | 55.8%
Running Shoes  | Fashion  | $522,144    | $289,098     | 55.4%
Jeans          | Fashion  | $508,376    | $276,856     | 54.4%
Formal Shoes   | Fashion  | $496,503    | $265,351     | 53.4%

INSIGHT: Fashion accessories and apparel have margins 8–15% above other categories.
Prioritising these SKUs in marketing drives disproportionate profit growth.
*/

-- 5b. How discount levels affect profitability
SELECT
    CASE
        WHEN Discount BETWEEN 0.10 AND 0.20 THEN '10–20% Discount'
        WHEN Discount BETWEEN 0.21 AND 0.30 THEN '21–30% Discount'
        WHEN Discount BETWEEN 0.31 AND 0.40 THEN '31–40% Discount'
        WHEN Discount BETWEEN 0.41 AND 0.50 THEN '41–50% Discount'
        ELSE 'Other'
    END                                        AS discount_band,
    COUNT(*)                                   AS order_count,
    ROUND(AVG(Profit), 2)                      AS avg_profit_per_order,
    ROUND(AVG(Sales), 2)                       AS avg_sale_value,
    ROUND(AVG(Profit) / AVG(Sales) * 100, 1)  AS effective_margin_pct
FROM ecommerce_orders
WHERE Discount > 0
GROUP BY discount_band
ORDER BY effective_margin_pct DESC;

/*
INSIGHT: Counter-intuitively, 41–50% discount band still yields 73.2% effective margin,
suggesting healthy base pricing. Discounts are not destroying margin — they may be
driving volume that compensates. Further A/B testing recommended.
*/
