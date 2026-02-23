# Online Retail SQL Analytics
**Project Overview**
This project analyzes an online retail dataset using **Google BigQuery and SQL** to answer key commercial questions around **revenue, customer behaviour, product performance, and customer lifetime value (LTV)**.
The project also includes a dimensional-style data model (customers, products, orders, order_items) to reflect real-world analytics and BI workflows. 

The work simulates a real-world analytics workflow:
- Ingest raw transactional data
- Clean and model it into analytics-friendly tables
- Build reusable SQL queries
- Produce business-ready outputs for decision-making

This repository is designed as a **portfolio-grade SQL analytics project** demonstrating data modeling, analytical SQL, and business insight generation.

**Problem Statement**
Online retailers need clear visibility into:
- How revenue is trending over time
- Which product categories and products drive the most value
- How customer behaviour differs between one-time and repeat buyers
- What the average order value looks like
- Which customers contribute the most lifetime value
- How big the returns problem is

The goal of this project is to use **SQL only** to:
- Clean and structure raw transaction data
- Build analytical tables (customers, products, orders, order_items)
- Answer core commercial and growth questions
- Produce metrics that can be used by marketing, finance, and operations teams

**Data Source**
- Dataset: Online Retail Dataset (Kaggle)
- Type: Transaction-level e-commerce data
- Key fields: Invoice, StockCode, Description, Quantity, UnitPrice, CustomerID, Country, InvoiceDate
- Tooling: Google BigQuery for querying and transformation
- Local OutputsL Exce files wuth cleaned data and analysis results

**Data Pipeline & Modeling**
1. **Raw Data Ingestion (BigQuery)**
   - Raw CSV ingested into BigQuery as online_retail_raw

2. **Data Cleaning (SQL)**
   - Removed header rows accidentally ingested as data
   - Filtered out:
     Cancellations (InvoiceNo starting with "C")
     Negative or zero quantities
     Zero or negative prices
     Null customers
  - Added a **derived product category** using keyword rules on product descriptions

3. **Analytics Tables Created**
   Using SQL, the dataset was structured into:
   customers
   products
   orders
   order_items
   customer_ltv
This follows a **star-schema style analytics model** suitable for BI and reporting.

4. **Analysis Layer**
   SQL queries were written to produce:
   - Monthly revenue trends
   - Revenue by category
   - Top products by revenue and volume
   - Customer repeat vs one-time behaviour
   - Average Order Value (AOV)
   - Customer Lifetime Value rankings
   - Return rate analysis
  
**Pipeline Summary**
Raw Retail Data (Kaggle)
        ↓
Google BigQuery (online_retail_raw)
        ↓
SQL Cleaning & Transformation
        ↓
Analytics Tables (customers, products, orders, order_items, customer_ltv)
        ↓
Business Analysis Queries
        ↓
Excel Outputs (SQL Analysis Project 1 - Core Results.xlsx)

**Data Model (Dimensions & Fact Tables)**
To make the dataset analytics-ready and easier to query, the raw transactional data was transformed into a simple star-schema style model using SQL in BigQuery.

**Dimension Tables**
- dim_customers
  1. Contains one row per customer with:
     'customer_id'
     'country'
     This table is used to analyse customer behaviour, geography, and customer-level KPIs.

- dim_products:
  1. Contains one row per customer with:
     'product_id' (StockCode)
     'product_name'
     'category' (derived from product description keywords)
     'unit_price'
     This table supports product, category, and merchandising analysis.

  - dim_orders
    1. Contains one row per order (invoice) with:
       'order_id'
       'customer_id'
       'order_date'
       This table represents the order header level and is used for order-based metrics like AOV and order counts.

    - dim_order_items
      1. Contains one row per product per order with:
         'order_item_id'
         'order_id'
         'product_id'
         'quantity'
         'unit_price_at_purchase'
This acts as the **fact table** for sales and is used to calculate revenue, quantities sold, and returns.

**Why this structure?**
This dimensional model:
- Makes analytical queries simpler and faster
- Separates business entities (customers, products, orders) from transactions
- Mirrors how data is typically structured in BI and data warehouse environments
- Makes the project closer to real-world analytics engineering and BI workflows

**SQL Structure in this Repository**

- **Retail Analytics for Project 1.sql**
  This file contains the **full end-to-end SQL script**, including:
  - Data cleaning from the raw table
  - Creation of dimension and fact tables
  - All analytical queries used in the project

- **/sql folder**
Inside the 'sql' folder, the SQL has been **broken down into smaller, focused scripts**, each representing a specific business output:
- 'monthly_revenue.sql' - Monthly revenue trend analysis
- 'category_revenue.sql' - Revenue by product category
- 'top_products.sql' - Top products by revenue and quantity
- 'repeat_vs_onetime_customers.sql' - Customer repeat vs one-time analysis
- 'aov.sql' - Average Order Value calculation
- 'Customer LTV' - Customer lifetime value calculation

This structure mirrors how SQL is often organized in real analytics projects:
- One master script for full reproducibility
- Modular query files for specific business questions and outputs

**Business Questions Answered**
1. How does revenue evolve month by month?
2. Which product categories generate the most revenue?
3. What are the top products by revenue and quantity sold?
4. What percentage of customers are repeat vs one-time buyers?
5. What is the Average Order Value (AOV)?
6. Who are the highest-value customers by lifetime revenue?
7. How concentrated is revenue among top customers?
8. What is the overall product return rate?

**KPIs Produced/Impacted**
- Total revenue
- Monthly revenue trend
- Revenue by category
- Top products by revenue and volume
- Average Order Value (AOV)
- Repeat customer rate
- One-time vs repeat customer split
- Customer lifetime value (LTV)
- Return rate

These KPIs are directly relevant to:
- E-commerce performance monitoring
- Marketing and retention strategy
- Merchandising and product strategy
- Finance and revenue forecasting

**Key Analysis & Insights**
Based on the SQL outputs:
- Revenue is highly concentrated in a small subset of products and customers
- A meaningful share of customers are one-time buyers, indicating retention opportunities
- AOV provides a baseline for basket-size optimization strategies
- LTV analysis highlights a small group of high-value customers driving disproportionate revenue
- Certain categories dominate revenue, suggesting focus areas for merchandising and promotions
- Return rate is measurable and can be tracked as an operational efficiency KPI

(All supporting results are included in SQL Analysis Project 1 - Core Results.xlsx)

**Recommendations**
From a business perspective, this analysis supports:
- **Customer retention:**
  Focus marketing efforts on converting one-time buyers into repeat customers.

- **Revenue growth:**
  Use LTV segmentation to design targeted campaigns for high-value customers.

- **Merchandising Strategy:**
  Prioritize high-performing categories and top products in promotions and inventory planning.

- **Operational efficiency:**
  Monitor and reduce return rates to protect margins.

- **Executive Reporting:**
  The modeled tables and KPIs can be directly plugged into BI tools (Power BI, Looker, Tableau).


**Repository Structure**
├── sql/
│   ├── monthly_revenue.sql
│   ├── category_revenue.sql
│   ├── top_products.sql
│   ├── repeat_vs_onetime_customers.sql
│   ├── aov.sql
│   └── Customer LTV
│
├── Online_Retail_Cleaned.xlsx
├── SQL Analysis Project 1 - Core Results.xlsx
├── dim_customers.xlsx
├── dim_products.xlsx
├── dim_orders.xlsx
├── dim_order_items.xlsx
├── Retail Analytics for Project 1.sql
└── README.md

**Tools & Technologies**
- SQL (Google BigQuery)
- Kaggle Dataset
- Excel (for result exports and review)
- Github (version control & portfolio presentation)

**Why this project matters**
This project demonstrates:
- Real-world SQL data cleaning and transformation
- Analytical data modeling (fact/dimension style tables)
- Business-focused KPI development
- Commerical thinking applied to data
- End-to-end analytics workflow using SQL in a cloud warehouse environment

It reflects the kind of work done in a **data analyst, analytics engineer, and business intellgience roles**.

**Author - Imaya Kehelkaduwa (Analytics and Data Engineering portfolio)**

