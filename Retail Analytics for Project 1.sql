SELECT
  string_field_0 AS InvoiceNo,
  string_field_1 AS StockCode,
  string_field_2 AS Description,
  SAFE_CAST(string_field_3 AS INT64) AS Quantity,
  string_field_4 AS InvoiceDate,
  SAFE_CAST(string_field_5 AS BIGNUMERIC) AS UnitPrice,
  string_field_6 AS CustomerID,
  string_field_7 AS Country,
  CASE
    WHEN string_field_2 LIKE '%CLOCK%' THEN 'Home & Living'
    WHEN string_field_2 LIKE '%MUG%' THEN 'Kitchen'
    WHEN string_field_2 LIKE '%PEN%' THEN 'Stationery'
    WHEN string_field_2 LIKE '%PAPER%' THEN 'Stationery'
    WHEN string_field_2 LIKE '%TOY%' THEN 'Kids'
    WHEN string_field_2 LIKE '%LIGHT%' THEN 'Home Decor'
    WHEN string_field_2 LIKE '%BAG%' THEN 'Accessories'
    ELSE 'Other'
  END AS Category
FROM
  `retail-analytics-478402`.retail_analytics.online_retail_raw
WHERE
  string_field_0 != 'InvoiceNo' AND string_field_1 != 'StockCode' AND string_field_2 != 'Description' AND
  string_field_3 != 'Quantity' AND string_field_4 != 'InvoiceDate' AND string_field_5 != 'UnitPrice' AND
  string_field_6 != 'CustomerID' AND string_field_7 != 'Country' AND SAFE_CAST(string_field_3 AS INT64) >
  0 AND SAFE_CAST(string_field_5 AS BIGNUMERIC) > 0 AND string_field_0 NOT LIKE 'C%' AND string_field_6 IS NOT NULL;

  CREATE OR REPLACE TABLE
  `retail-analytics-478402.retail_analytics.customers` AS
SELECT DISTINCT
  CustomerID AS customer_id,
  Country    AS country
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`;

CREATE OR REPLACE TABLE
  `retail-analytics-478402.retail_analytics.products` AS
SELECT DISTINCT
  StockCode    AS product_id,
  Description  AS product_name,
  Category,
  UnitPrice    AS unit_price
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`;

CREATE OR REPLACE TABLE
  `retail-analytics-478402.retail_analytics.orders` AS
SELECT DISTINCT
  InvoiceNo   AS order_id,
  CustomerID  AS customer_id,
  InvoiceDate AS order_date
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`;

CREATE OR REPLACE TABLE
  `retail-analytics-478402.retail_analytics.order_items` AS
SELECT
  CONCAT(InvoiceNo, '-', ROW_NUMBER() OVER (PARTITION BY InvoiceNo)) AS order_item_id,
  InvoiceNo   AS order_id,
  StockCode   AS product_id,
  Quantity,
  UnitPrice   AS unit_price_at_purchase
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`;

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

SELECT
  Description AS product_name,
  Category,
  SUM(Quantity * UnitPrice) AS revenue,
  SUM(Quantity) AS total_quantity
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`
GROUP BY product_name, Category
ORDER BY revenue DESC
LIMIT 10;

WITH order_counts AS (
  SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS orders
  FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`
  GROUP BY CustomerID
)
SELECT
  SUM(CASE WHEN orders = 1 THEN 1 ELSE 0 END) AS one_time_customers,
  SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
  ROUND(SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*), 2) AS repeat_customer_pct
FROM order_counts;

SELECT
  ROUND(SUM(Quantity * UnitPrice)
        / COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`;

CREATE OR REPLACE TABLE
  `retail-analytics-478402.retail_analytics.customer_ltv` AS
SELECT
  CustomerID AS customer_id,
  SUM(Quantity * UnitPrice) AS total_revenue,
  COUNT(DISTINCT InvoiceNo) AS total_orders
FROM `retail-analytics-478402.retail_analytics.online_retail_cleaned`
GROUP BY CustomerID;

SELECT *
FROM `retail-analytics-478402.retail_analytics.customer_ltv`
ORDER BY total_revenue DESC
LIMIT 10;

SELECT *
FROM `retail-analytics-478402.retail_analytics.customer_ltv`
ORDER BY total_orders DESC
LIMIT 10;

SELECT *
FROM `retail-analytics-478402.retail_analytics.customer_ltv`
ORDER BY total_revenue ASC
LIMIT 10;

WITH sales AS (
  SELECT
    -- total units sold (positive quantities)
    SUM(
      CASE
        WHEN SAFE_CAST(string_field_3 AS INT64) > 0
          THEN SAFE_CAST(string_field_3 AS INT64)
        ELSE 0
      END
    ) AS total_sold,

    -- total units returned (negative quantities)
    SUM(
      CASE
        WHEN SAFE_CAST(string_field_3 AS INT64) < 0
          THEN ABS(SAFE_CAST(string_field_3 AS INT64))
        ELSE 0
      END
    ) AS total_returned
  FROM `retail-analytics-478402.retail_analytics.online_retail_raw`
)

SELECT
  total_sold,
  total_returned,
  SAFE_DIVIDE(total_returned, total_sold) AS return_rate
FROM sales;
