# Power BI Dashboard — E-Commerce Dynamic Pricing

## Overview
Interactive 5-page dashboard built in Power BI Desktop analyzing
676 e-commerce product records across 9 categories (2017–2018).

## Dashboard Pages

### Page 1 — Executive Overview
- 6 KPI cards: Total Revenue, Total Qty, Avg Unit Price,
  Total Customers, Avg Product Score, Revenue per Customer
- Line chart: Monthly revenue trend
- Bar chart: Revenue by category (all 9 categories)
- Donut chart: Price position split
  (Overpriced 46.3% / Underpriced 30.9% / Competitive 22.8%)
- Slicers: Year, Category, Price Position

### Page 2 — Competitor Analysis
- Scatter: Our price vs avg competitor price
- Bar chart: Price gap by category
- Line chart: Our price vs 3 competitors over time
- Table: Product pricing detail with conditional formatting
- KPI cards: Avg Comp Price, Price Gap, Overpriced %

### Page 3 — Demand & Time Analysis
- Line & column chart: Price vs demand over time
- Scatter: Holiday count vs revenue
- Scatter: Weekday count vs revenue
- Bar chart: Revenue by month
- Bar chart: Day type counts by month
- KPI cards: Revenue per Weekday, Weekend, Holiday

### Page 4 — ML Predictions
- Scatter: Predicted vs actual price (XGBoost)
- Scatter: Predicted vs actual demand (Gradient Boosting)
- Bar chart: Prediction error by category
- Table: Prediction detail
- KPI cards: Avg Predicted Price, Price Accuracy %, Errors

### Page 5 — Product Segmentation
- Scatter: Clusters by price and score (4 clusters)
- Scatter: Clusters by weight and volume
- Bar chart: Avg price per cluster
- Bar chart: Avg score per cluster
- Tile slicer: Filter by cluster
- KPI cards: Count per cluster (0=362, 1=199, 2=28, 3=87)

## DAX Measures Created
- Total Revenue, Total Qty, Avg Unit Price
- Avg Comp Price, Avg Price Gap, Overpriced %
- Revenue per Weekday, Weekend Day, Holiday Day
- Holiday Impact %, Avg Predicted Price, Price Accuracy %
- Revenue MoM Growth %, Cluster counts

## Color Theme Used
| Purpose | Hex |
|---|---|
| Primary / Revenue | #1B4F8A |
| Quantity / Demand | #0E8C7A |
| Overpriced | #C0392B |
| Competitive | #27AE60 |
| Underpriced | #E67E22 |
| Weekend | #7D3C98 |
| Holiday | #D4AC0D |

## How to Open
1. Download Power BI Desktop free from microsoft.com/power-bi
2. Download the .pbix file from this folder
3. Open it in Power BI Desktop
4. Update data source path to your local E_Commerse.csv
5. Click Refresh
