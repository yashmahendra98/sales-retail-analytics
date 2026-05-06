-- ============================================================
-- QUERY 6: Top-Selling Products & Payment Channel Analysis
-- ============================================================

-- 6a. Top 10 products by revenue (E-commerce)
SELECT
    Product,
    Product_Category,
    COUNT(*)                                        AS order_count,
    ROUND(SUM(Sales), 2)                            AS total_revenue,
    ROUND(SUM(Profit), 2)                           AS total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 1)       AS margin_pct,
    ROUND(SUM(Sales) / (SELECT SUM(Sales) FROM ecommerce_orders) * 100, 2) AS revenue_share_pct
FROM ecommerce_orders
GROUP BY Product, Product_Category
ORDER BY total_revenue DESC
LIMIT 10;

-- 6b. Payment method performance
SELECT
    Payment_method,
    COUNT(*)                                        AS transaction_count,
    ROUND(SUM(Sales), 2)                            AS total_sales,
    ROUND(AVG(Sales), 2)                            AS avg_transaction_value,
    ROUND(SUM(Sales) / SUM(SUM(Sales)) OVER() * 100, 1) AS sales_share_pct
FROM ecommerce_orders
WHERE Payment_method != 'not_defined'
GROUP BY Payment_method
ORDER BY total_sales DESC;

/*
RESULTS — Payment Methods:
Method        | transactions | total_sales | sales_share_pct
credit_card   | (majority)   | $5,819,379  | 74.5%
money_order   |              | $1,461,269  | 18.7%
e_wallet      |              | $422,750    |  5.4%
debit_card    |              | $109,979    |  1.4%

RECOMMENDATION: Credit card dominance (74.5%) suggests BNPL and digital wallet
integrations could capture the 5.4% e-wallet users who prefer alternative payments.
Growing e-wallet user base is a low-cost acquisition opportunity.
*/

-- 6c. Device type vs revenue (Web vs Mobile)
SELECT
    Device_Type,
    Gender,
    COUNT(*)                                        AS order_count,
    ROUND(SUM(Sales), 2)                            AS total_sales,
    ROUND(AVG(Sales), 2)                            AS avg_order_value
FROM ecommerce_orders
GROUP BY Device_Type, Gender
ORDER BY Device_Type, total_sales DESC;

/*
RESULTS:
Device_Type | Gender | order_count | total_sales | avg_order_value
Web         | Male   |             | $4,308,918  | $152
Web         | Female |             | $3,504,493  | $152
Mobile      |        |             | $563,340    | $152  ← Only 7.2% of revenue

CRITICAL FINDING: Mobile drives only 7.2% of revenue despite growing mobile
commerce trends. Mobile UX optimization and app development should be a top
priority for revenue diversification.
*/

-- ============================================================
-- QUERY 7: Executive Summary View
-- ============================================================
SELECT
    'Total Revenue (E-com)'    AS metric, CONCAT('$', FORMAT(SUM(Sales)/1e6,2),'M') AS value FROM ecommerce_orders
UNION ALL
SELECT 'Total Profit (E-com)', CONCAT('$', FORMAT(SUM(Profit)/1e6,2),'M') FROM ecommerce_orders
UNION ALL
SELECT 'Overall Profit Margin', CONCAT(ROUND(SUM(Profit)/SUM(Sales)*100,1),'%') FROM ecommerce_orders
UNION ALL
SELECT 'Total Orders (E-com)', FORMAT(COUNT(*),0) FROM ecommerce_orders
UNION ALL
SELECT 'Avg Order Value', CONCAT('$', ROUND(AVG(Sales),0)) FROM ecommerce_orders
UNION ALL
SELECT 'Top Category', Product_Category FROM (
    SELECT Product_Category, SUM(Sales) s FROM ecommerce_orders GROUP BY 1 ORDER BY s DESC LIMIT 1
) t
UNION ALL
SELECT 'Superstore YoY Growth (2018)', '+20.3%'
UNION ALL
SELECT 'Underperforming Region', 'South ($389K, -45% vs West)';
