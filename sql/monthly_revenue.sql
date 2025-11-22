SELECT
  FORMAT_DATE('%Y-%m',
              PARSE_DATE('%d/%m/%Y', InvoiceDate)) AS month,
  SUM(Quantity * UnitPrice) AS revenue
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`
GROUP BY month
ORDER BY month;

SELECT
  Category,
  SUM(Quantity * UnitPrice) AS revenue,
  COUNT(DISTINCT InvoiceNo) AS orders
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`
GROUP BY Category
ORDER BY revenue DESC;
