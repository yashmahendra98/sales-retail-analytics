# Power BI — DAX Measures Reference
# ============================================================
# This file documents all DAX measures used in the
# Retail Analytics Dashboard (.pbix).
# Paste these into Power BI Desktop → New Measure.
# ============================================================


# ── KPI CARD MEASURES ─────────────────────────────────────────────────────────

Total Revenue =
    SUM(ecommerce[Sales])

Total Profit =
    SUM(ecommerce[Profit])

Profit Margin % =
    DIVIDE([Total Profit], [Total Revenue], 0) * 100

Total Orders =
    COUNTROWS(ecommerce)

Average Order Value =
    AVERAGE(ecommerce[Sales])

Average Discount % =
    AVERAGE(ecommerce[Discount]) * 100


# ── GROWTH MEASURES ────────────────────────────────────────────────────────────

# Month-over-Month Sales Growth
MoM Sales Growth % =
VAR CurrentMonthSales =
    CALCULATE([Total Revenue],
        DATESMTD(ecommerce[Order_Date]))
VAR PrevMonthSales =
    CALCULATE([Total Revenue],
        PREVIOUSMONTH(ecommerce[Order_Date]))
RETURN
    DIVIDE(CurrentMonthSales - PrevMonthSales, PrevMonthSales, 0) * 100

# Year-over-Year Sales Growth (Superstore)
YoY Sales Growth % =
VAR CurrentYearSales =
    CALCULATE(SUM(superstore[Sales]),
        DATESYTD(superstore[Order Date]))
VAR PrevYearSales =
    CALCULATE(SUM(superstore[Sales]),
        SAMEPERIODLASTYEAR(superstore[Order Date]))
RETURN
    DIVIDE(CurrentYearSales - PrevYearSales, PrevYearSales, 0) * 100

# Running Total Revenue
Running Total Revenue =
    CALCULATE([Total Revenue],
        FILTER(ALL(ecommerce[Order_Date]),
            ecommerce[Order_Date] <= MAX(ecommerce[Order_Date])))


# ── RANKING MEASURES ───────────────────────────────────────────────────────────

# Product Rank by Revenue
Product Revenue Rank =
    RANKX(ALL(ecommerce[Product]),
        [Total Revenue],,
        DESC, Dense)

# Category Rank by Profit
Category Profit Rank =
    RANKX(ALL(ecommerce[Product_Category]),
        [Total Profit],,
        DESC, Dense)

# Region Rank (Superstore)
Region Sales Rank =
    RANKX(ALL(superstore[Region]),
        SUM(superstore[Sales]),,
        DESC, Dense)


# ── SEGMENT & CONDITIONAL MEASURES ────────────────────────────────────────────

# Revenue share per category
Category Revenue Share % =
    DIVIDE([Total Revenue],
        CALCULATE([Total Revenue], ALL(ecommerce[Product_Category])),
        0) * 100

# Highlight underperforming regions (below average)
Is Underperforming Region =
VAR AvgRegionSales =
    AVERAGEX(VALUES(superstore[Region]),
        CALCULATE(SUM(superstore[Sales])))
RETURN
    IF(SUM(superstore[Sales]) < AvgRegionSales, "⚠ Below Average", "✓ Above Average")

# Flag high-margin products (margin > 50%)
High Margin Flag =
    IF(
        DIVIDE(SUM(ecommerce[Profit]), SUM(ecommerce[Sales])) > 0.5,
        "⭐ High Margin",
        "Standard"
    )


# ── DASHBOARD PAGES ────────────────────────────────────────────────────────────
# Recommended Power BI report pages:
#
# Page 1: Executive Summary
#   - KPI Cards: Total Revenue, Profit, Margin %, Orders, AOV
#   - Line chart: Monthly Sales & Profit trend
#   - Bar chart: Sales by Category
#   - Slicer: Year, Category
#
# Page 2: Product Analysis
#   - Bar chart: Top 10 Products by Revenue
#   - Scatter: Sales vs Profit Margin (bubble = order count)
#   - Table: Full product list with rank, margin, trend
#
# Page 3: Regional Performance
#   - Map: Sales by Region / State (filled map)
#   - Bar: Region comparison with benchmark line
#   - Donut: Customer segment split
#
# Page 4: Growth Analysis
#   - Column chart: YoY annual sales (Superstore)
#   - Line chart: MoM growth % (E-commerce)
#   - KPI card: YoY Growth %, MoM Growth %
#
# Page 5: Customer & Channel
#   - Donut: Payment method split
#   - Donut: Device type split (Web vs Mobile)
#   - Bar: Gender × Device breakdown
#   - Slicer: Order Priority, Login Type
