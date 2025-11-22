# Online-Retail-SQL-Analytics
End-to-End Data Analysis using Google BigQuery & SQL

This project showcases a complete analytical workflow using SQL on the Online Retail dataset. It demonstrates strong capabilities in data cleaning, dimensional modelling, writing modular analytical SQL scripts, and extracting actionable business insights.

All SQL work was completed in Google BigQuery, and the repository contains structured SQL scripts, dimensional models, and key analytical outputs.

# Project Overview
The goal of this project is to analyse e-commerce sales data to uncover trends, customer behaviour patterns, and product performance insights. This includes:

Cleaning and transforming raw retail data

Designing and generating dimensional tables

Running in-depth SQL analyses

Extracting insights for business stakeholders

Documenting the analytical workflow and final recommendations

# Data Cleaning & Preparation
The raw dataset was first uploaded to BigQuery and cleaned using SQL. Cleaning steps included:

✔ Converting Quantity and UnitPrice into numeric formats
✔ Creating a valid InvoiceDate timestamp
✔ Removing cancelled transactions (InvoiceNo LIKE 'C%')
✔ Removing zero/negative price artefacts
✔ Filtering rows with missing Customer IDs
✔ Deriving a product category using SQL CASE logic

A cleaned version of the dataset was stored as:

online_retail_cleaned

# Dimensional Modelling
To support analytical queries, the following dimensional tables were created:

📌 2.1 customers

customer_id

country

📌 2.2 products

stockcode

description

category

📌 2.3 orders

invoice_no

invoice_date

customer_id

📌 2.4 order_items

invoice_no

stockcode

quantity

unit_price

These tables follow a star-schema-style structure, improving performance and simplifying analytics.

