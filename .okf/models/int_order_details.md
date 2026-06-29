---
type: dbt Model
title: int_order_details
description: Ephemeral order enrichment joining orders, line items, and product costs. Computes per-order revenue, cost, and gross margin in both pence and GBP.
tags: [intermediate, orders, margin, ephemeral]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as **ephemeral** — compiled into downstream CTEs; never written to the Snowflake warehouse.

Joins [stg_orders](/models/stg_orders.md) with [stg_order_items](/models/stg_order_items.md) and [stg_products](/models/stg_products.md) to produce financial aggregates per order.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `order_id` | VARCHAR | Unique order identifier. PK. |
| `customer_id` | VARCHAR | FK to stg_customers. |
| `cfc_id` | VARCHAR | FK to stg_fulfilment_centres. |
| `order_date` | DATE | Date the order was placed. |
| `delivery_slot` | VARCHAR | Requested delivery window. |
| `status` | VARCHAR | Current fulfilment status. |
| `promised_delivery_date` | DATE | Committed delivery date. |
| `actual_delivery_date` | DATE | Confirmed delivery date. Null if undelivered. |
| `is_on_time` | BOOLEAN | Punctuality flag from stg_orders. |
| `updated_at` | TIMESTAMP | Status-change watermark. |
| `total_revenue_pence` | INTEGER | SUM(quantity × order-time unit_price_pence) across all line items. |
| `total_cost_pence` | INTEGER | SUM(quantity × catalogue cost_pence) across all line items. |
| `total_margin_pence` | INTEGER | `total_revenue_pence − total_cost_pence`. |
| `total_revenue_gbp` | NUMERIC(10,2) | Revenue converted to GBP. |
| `total_margin_gbp` | NUMERIC(10,2) | Margin converted to GBP. |
| `margin_pct` | FLOAT | `total_margin_pence / total_revenue_pence` via [`safe_divide`](/macros/safe_divide.md). Null for zero-item orders. |
| `total_line_items` | INTEGER | Count of distinct product lines in the order. |

# Notes

Revenue uses `stg_order_items.unit_price_pence` (historical order-time price). Cost uses `stg_products.cost_pence` (current catalogue cost). This reflects standard gross-margin accounting for grocery retail.

`margin_pct` delegates to [`safe_divide`](/macros/safe_divide.md) to return null instead of crashing on zero-denominator (orders with no line items).

# Downstream

Consumed only by [fct_orders](/models/fct_orders.md).
