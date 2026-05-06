-- ============================================================
-- QUERY 1: Sales & Profit Aggregation by Product Category
-- Dataset: E-commerce Dataset (51,290 orders, 2018)
-- ============================================================

SELECT
    Product_Category,
    COUNT(*)                                         AS total_orders,
    ROUND(SUM(Sales), 2)                             AS total_sales,
    ROUND(SUM(Profit), 2)                            AS total_profit,
    ROUND(AVG(Sales), 2)                             AS avg_order_value,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 1)        AS profit_margin_pct,
    ROUND(AVG(Discount) * 100, 1)                   AS avg_discount_pct
FROM ecommerce_orders
GROUP BY Product_Category
ORDER BY total_sales DESC;

/*
RESULTS:
Product_Category     | total_orders | total_sales  | total_profit | profit_margin_pct
Fashion              | 25,646       | $4,345,914   | $2,072,624   | 47.7%
Home & Furniture     | 15,438       | $1,975,831   | $880,059     | 44.5%
Auto & Accessories   | 7,504        | $1,096,928   | $484,313     | 44.2%
Electronic           | 2,701        | $394,738     | $174,191     | 44.1%

INSIGHT: Fashion drives 55.6% of total revenue with the highest margin (47.7%).
Electronic has the lowest order volume but comparable margin—scaling opportunity.
*/
