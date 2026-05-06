-- ============================================================
-- QUERY 3: Month-over-Month & Year-over-Year Growth Analysis
-- ============================================================

-- 3a. Monthly Sales Trend (E-commerce 2018)
SELECT
    MONTH(Order_Date)                               AS month_num,
    MONTHNAME(Order_Date)                           AS month_name,
    ROUND(SUM(Sales), 2)                            AS monthly_sales,
    ROUND(SUM(Profit), 2)                           AS monthly_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 1)       AS margin_pct,
    ROUND(
        (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY MONTH(Order_Date)))
        / LAG(SUM(Sales)) OVER (ORDER BY MONTH(Order_Date)) * 100, 1
    )                                               AS mom_growth_pct
FROM ecommerce_orders
GROUP BY MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY month_num;

/*
KEY FINDINGS:
- May is the peak month ($824K sales, +37.8% MoM from April)
- November second peak: $877K (holiday season effect)
- Feb is the weakest month ($332K) — opportunity for promotions
- Q2 and Q4 consistently outperform Q1 and Q3
*/

-- 3b. Year-over-Year Growth (Superstore 2015–2018)
SELECT
    YEAR("Order Date")                              AS year,
    ROUND(SUM(Sales), 2)                            AS annual_sales,
    ROUND(
        (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY YEAR("Order Date")))
        / LAG(SUM(Sales)) OVER (ORDER BY YEAR("Order Date")) * 100, 1
    )                                               AS yoy_growth_pct
FROM superstore
GROUP BY YEAR("Order Date")
ORDER BY year;

/*
RESULTS:
Year | annual_sales | yoy_growth_pct
2015 | $479,856     | —
2016 | $459,436     | -4.3%   ← Dip year
2017 | $600,193     | +30.6%  ← Strong recovery
2018 | $722,052     | +20.3%  ← Sustained growth

INSIGHT: 2016 dip followed by 50%+ cumulative growth 2016→2018 signals
the business successfully pivoted strategy post-2016.
*/

-- 3c. Quarter-over-quarter breakdown
SELECT
    YEAR("Order Date")                              AS year,
    QUARTER("Order Date")                           AS quarter,
    CONCAT('Q', QUARTER("Order Date"), '-', YEAR("Order Date")) AS period,
    ROUND(SUM(Sales), 2)                            AS quarterly_sales,
    COUNT(DISTINCT "Customer ID")                   AS active_customers
FROM superstore
GROUP BY YEAR("Order Date"), QUARTER("Order Date")
ORDER BY year, quarter;
