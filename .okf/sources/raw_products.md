---
type: dbt Seed
title: raw_products
description: 25 product SKUs across 7 categories with retail and supplier costs in integer pence. Source for stg_products.
tags: [products, seed, source, currency]
timestamp: 2026-06-29T00:00:00Z
---

Seed CSV loaded into `grocery_ops_demo_sources.raw_products`. 25 rows, one per SKU.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `product_id` | VARCHAR | Unique product identifier. |
| `sku` | VARCHAR | Stock-keeping unit code. Unique. |
| `product_name` | VARCHAR | Consumer-facing product name. |
| `category` | VARCHAR | Top-level product category. 7 categories total. |
| `subcategory` | VARCHAR | Granular classification within a category. |
| `unit_price_pence` | INTEGER | Retail selling price in pence sterling. |
| `cost_pence` | INTEGER | Supplier cost price in pence sterling. |
| `weight_g` | INTEGER | Product weight in grams. |
| `is_chilled` | BOOLEAN | `1` if refrigerated storage and cold-chain delivery are required. |

# Notes

Prices are stored as integers in pence to avoid floating-point rounding errors. The [`pence_to_pounds`](/macros/pence_to_pounds.md) macro converts them to GBP in [stg_products](/models/stg_products.md).

# Downstream

Staged by [stg_products](/models/stg_products.md), which converts pence to GBP and casts `is_chilled` to boolean.
