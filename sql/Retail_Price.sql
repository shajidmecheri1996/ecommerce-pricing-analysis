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


