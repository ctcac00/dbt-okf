---
type: dbt Model
title: stg_products
description: Cleaned product catalogue with pence-to-GBP price conversion and boolean chilled flag. Source for margin calculations.
tags: [staging, products, currency]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as a **view** in the `_staging` schema. Source: [raw_products](/sources/raw_products.md).

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `product_id` | VARCHAR | Unique product identifier. PK. |
| `sku` | VARCHAR | Stock-keeping unit code. Unique. |
| `product_name` | VARCHAR | Consumer-facing product name. |
| `category` | VARCHAR | Top-level product category. |
| `subcategory` | VARCHAR | Granular classification within a category. |
| `unit_price_pence` | INTEGER | Retail selling price in pence. |
| `cost_pence` | INTEGER | Supplier cost price in pence. |
| `unit_price_gbp` | NUMERIC(10,2) | Retail price in GBP, derived via [`pence_to_pounds`](/macros/pence_to_pounds.md). |
| `cost_gbp` | NUMERIC(10,2) | Supplier cost in GBP, derived via [`pence_to_pounds`](/macros/pence_to_pounds.md). |
| `weight_g` | INTEGER | Product weight in grams. |
| `is_chilled` | BOOLEAN | True if cold-chain handling is required. |

# Notes

`unit_price_gbp` and `cost_gbp` are derived columns that flow into [int_order_details](/models/int_order_details.md) for margin calculations. Both pence and GBP representations are retained throughout the pipeline.

# Downstream

Used in [int_order_details](/models/int_order_details.md) to calculate per-item cost contribution.
