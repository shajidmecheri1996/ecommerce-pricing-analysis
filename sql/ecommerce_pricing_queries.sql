use Retail;

ALTER TABLE retail_price
ADD id INT IDENTITY(1,1) PRIMARY KEY;

select * from Retail_price;

-- ============================================================
-- 1. BASIC DATA QUALITY CHECK
-- ============================================================

select
   COUNT(*) as total_rows,
   COUNT(distinct product_id) as unique_product,
   COUNT(distinct product_category_name) as unique_categoru,
   MIN(year) as min_year,
   MAX(year) as max_year,
   ROUND(AVG(unit_price),2) as avg_unit_price,
   ROUND(AVG(product_score),2) as avg_score
from retail_price

-- ============================================================
-- 2. REVENUE & QUANTITY BY CATEGORY
-- ============================================================

select
  product_category_name,
  COUNT(*)  as records,
  SUM(qty) as total_qty,
  ROUND(sum(total_price),2) as total_revenue,
  ROUND(AVG(unit_price),2) as avg_price,
  ROUND(AVG(product_score),2) as avg_score
from Retail_price
group by product_category_name
order by total_revenue desc;

-- ============================================================
-- 3. COMPETITOR PRICE COMPARISON (CTE)
-- ============================================================
with comp_avg as (
     select
	    product_id,
		unit_price,
		ROUND(((comp_1 + comp_2 + comp_3) / 3.0),2) as avg_comp_price,
		ROUND((unit_price - ((comp_1 + comp_2 + comp_3)) / 3.0),2) as price_diff
	 From retail_price
	 )
select 
   product_id,
   unit_price,
   avg_comp_price,
   price_diff,
   Case
      When price_diff > 0 Then 'Overpriced'
	  When price_diff < 0 Then 'Underpriced'
	  Else 'Competitive'
   End as pricing_status
From comp_avg
Order by price_diff Desc;

-- ============================================================
-- 4. MONTHLY REVENUE TREND
-- ============================================================

Select
  year,
  month,
  month_year,
  SUM(qty)                  as total_qty,
  ROUND(SUM(total_price),2) as total_revenue,
  ROUND(AVG(unit_price),2)  as avg_price
From retail_price
Group by year,month,month_year
Order by year,month;

-- ============================================================
-- 5. WEEKDAY vs WEEKEND SALES
-- ============================================================


SELECT 
    'Weekday' AS day_type,
    SUM(weekday) AS total_days_in_period,
    SUM(qty)  AS total_qty, 
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND((SUM(total_price) / NULLIF(SUM(weekday), 0)), 2) AS avg_revenue_per_day
FROM retail_price

UNION ALL

SELECT 
    'Weekend' AS day_type,
    SUM(weekend) AS total_days_in_period,
    SUM(qty) AS total_qty,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND((SUM(total_price) / NULLIF(SUM(weekend), 0)), 2) AS avg_revenue_per_day
FROM retail_price;

-- ============================================================
-- 6. HOLIDAY IMPACT ON SALES
-- ============================================================

Select
   holiday,
   COUNT(*)                 as records,
   SUM(qty)                 as total_qty,
   ROUND(AVG(unit_price),2) as avg_unit_price,
   ROUND(AVG(total_price),2)as avg_total_price
From retail_price
Group by holiday
order by holiday;

-- ============================================================
-- 7. TOP 10 PRODUCTS BY REVENUE (WINDOW FUNCTION)
-- ============================================================

Select *
From (
    Select 
	    product_id,
		product_category_name,
		ROUND(SUM(total_price),2)                   as total_revenue,
		SUM(qty)                                    as total_qty,
		RANK() over(Order by SUM(total_price) DESC) as revenue_rank
	From retail_price
	Group by product_id,product_category_name
	)ranked
Where revenue_rank <= 10;

-- ============================================================
-- 8. PRICE ELASTICITY PROXY (lag vs current price)
-- ============================================================

select
  product_id,
  unit_price,
  lag_price,
  qty,
  ROUND((unit_price - lag_price),2) as price_change,
  Case
     When lag_price = 0 Then NULL
	 Else ROUND((( unit_price - lag_price ) / lag_price * 100),2)
	 End As pct_price_change
From retail_price
Where lag_price > 0
Order by pct_price_change Desc

-- ============================================================
-- 9. CREATE ANALYTICAL VIEW FOR BI / PYTHON USE
-- ============================================================

-- ============================================================
-- 1. CREATE TABLE
-- ============================================================
CREATE TABLE ecommerce_pricing (
    product_id               VARCHAR(50),
    product_category_name    VARCHAR(100),
    month_year               VARCHAR(10),
    qty                      INT,
    total_price              FLOAT,
    freight_price            FLOAT,
    unit_price               FLOAT,
    product_name_lenght      INT,
    product_description_lenght INT,
    product_photos_qty       INT,
    product_weight_g         INT,
    product_score            FLOAT,
    customers                INT,
    weekday                  INT,
    weekend                  INT,
    holiday                  INT,
    month                    INT,
    year                     INT,
    s                        FLOAT,
    volume                   INT,
    comp_1                   FLOAT,
    ps1                      FLOAT,
    fp1                      FLOAT,
    comp_2                   FLOAT,
    ps2                      FLOAT,
    fp2                      FLOAT,
    comp_3                   FLOAT,
    ps3                      FLOAT,
    fp3                      FLOAT,
    lag_price                FLOAT
);

-- ============================================================
-- 2. BASIC DATA QUALITY CHECK
-- ============================================================
SELECT
    COUNT(*)                        AS total_rows,
    COUNT(DISTINCT product_id)      AS unique_products,
    COUNT(DISTINCT product_category_name) AS unique_categories,
    MIN(year) AS min_year,
    MAX(year) AS max_year,
    ROUND(AVG(unit_price)::NUMERIC, 2) AS avg_unit_price,
    ROUND(AVG(product_score)::NUMERIC, 2) AS avg_score
FROM ecommerce_pricing;

-- ============================================================
-- 3. REVENUE & QUANTITY BY CATEGORY
-- ============================================================
SELECT
    product_category_name,
    COUNT(*)                                  AS records,
    SUM(qty)                                  AS total_qty,
    ROUND(SUM(total_price)::NUMERIC, 2)       AS total_revenue,
    ROUND(AVG(unit_price)::NUMERIC, 2)        AS avg_price,
    ROUND(AVG(product_score)::NUMERIC, 2)     AS avg_score
FROM ecommerce_pricing
GROUP BY product_category_name
ORDER BY total_revenue DESC;

-- ============================================================
-- 4. COMPETITOR PRICE COMPARISON (CTE)
-- ============================================================
WITH comp_avg AS (
    SELECT
        product_id,
        unit_price,
        ROUND(((comp_1 + comp_2 + comp_3) / 3.0)::NUMERIC, 2) AS avg_comp_price,
        ROUND((unit_price - ((comp_1 + comp_2 + comp_3) / 3.0))::NUMERIC, 2) AS price_diff
    FROM ecommerce_pricing
)
SELECT
    product_id,
    unit_price,
    avg_comp_price,
    price_diff,
    CASE
        WHEN price_diff > 0  THEN 'Overpriced'
        WHEN price_diff < 0  THEN 'Underpriced'
        ELSE 'Competitive'
    END AS pricing_status
FROM comp_avg
ORDER BY price_diff DESC;

-- ============================================================
-- 5. MONTHLY REVENUE TREND
-- ============================================================
SELECT
    year,
    month,
    month_year,
    SUM(qty)                            AS total_qty,
    ROUND(SUM(total_price)::NUMERIC, 2) AS total_revenue,
    ROUND(AVG(unit_price)::NUMERIC, 2)  AS avg_price
FROM ecommerce_pricing
GROUP BY year, month, month_year
ORDER BY year, month;

-- ============================================================
-- 6. WEEKDAY vs WEEKEND SALES
-- ============================================================
SELECT
    CASE WHEN weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(*)                            AS records,
    SUM(qty)                            AS total_qty,
    ROUND(AVG(unit_price)::NUMERIC, 2)  AS avg_price,
    ROUND(SUM(total_price)::NUMERIC, 2) AS total_revenue
FROM ecommerce_pricing
GROUP BY weekend;

-- ============================================================
-- 7. HOLIDAY IMPACT ON SALES
-- ============================================================
SELECT
    holiday,
    COUNT(*)                            AS records,
    SUM(qty)                            AS total_qty,
    ROUND(AVG(unit_price)::NUMERIC, 2)  AS avg_unit_price,
    ROUND(AVG(total_price)::NUMERIC, 2) AS avg_total_price
FROM ecommerce_pricing
GROUP BY holiday
ORDER BY holiday;

-- ============================================================
-- 8. TOP 10 PRODUCTS BY REVENUE (WINDOW FUNCTION)
-- ============================================================
SELECT *
FROM (
    SELECT
        product_id,
        product_category_name,
        ROUND(SUM(total_price)::NUMERIC, 2) AS total_revenue,
        SUM(qty)                            AS total_qty,
        RANK() OVER (ORDER BY SUM(total_price) DESC) AS revenue_rank
    FROM ecommerce_pricing
    GROUP BY product_id, product_category_name
) ranked
WHERE revenue_rank <= 10;

-- ============================================================
-- 9. PRICE ELASTICITY PROXY (lag vs current price)
-- ============================================================
SELECT
    product_id,
    unit_price,
    lag_price,
    qty,
    ROUND((unit_price - lag_price)::NUMERIC, 2)   AS price_change,
    CASE
        WHEN lag_price = 0 THEN NULL
        ELSE ROUND(((unit_price - lag_price) / lag_price * 100)::NUMERIC, 2)
    END AS pct_price_change
FROM ecommerce_pricing
WHERE lag_price > 0
ORDER BY pct_price_change DESC;

-- ============================================================
-- 10. CREATE ANALYTICAL VIEW FOR BI / PYTHON USE
-- ============================================================
CREATE OR ALTER VIEW v_pricing_analysis AS
SELECT
    product_id,
    product_category_name,
    month_year,
    year,
    month,
    qty,
    total_price,
    unit_price,
    freight_price,
    product_score,
    customers,
    weekend,
    holiday,
    lag_price,
    ROUND(((comp_1 + comp_2 + comp_3) / 3.0), 2) AS avg_comp_price,
    ROUND((unit_price - ((comp_1 + comp_2 + comp_3) / 3.0)), 2) AS vs_competitor,
    CASE
        WHEN unit_price > ((comp_1 + comp_2 + comp_3) / 3.0) THEN 'Overpriced'
        WHEN unit_price < ((comp_1 + comp_2 + comp_3) / 3.0) THEN 'Underpriced'
        ELSE 'Competitive'
    END AS price_position
FROM retail_price;

Select * From v_pricing_analysis;




