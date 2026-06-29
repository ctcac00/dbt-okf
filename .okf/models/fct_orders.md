---
type: dbt Model
title: fct_orders
description: Incremental fact table — one row per order enriched with customer and CFC context, revenue, and gross margin. Primary commercial reporting table.
tags: [mart, orders, incremental, commercial]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as an incremental **table** in the `_marts` schema. `unique_key = order_id` — new and updated orders are upserted on each run.

**Incremental strategy**: filters `int_order_details` on `updated_at > MAX(updated_at)` of the existing table, making daily refreshes efficient regardless of total order volume.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `order_key` | VARCHAR | Surrogate PK generated via `dbt_utils.generate_surrogate_key(['order_id'])`. Stable for BI joins. |
| `order_id` | VARCHAR | Natural order identifier from the source system. |
| `customer_id` | VARCHAR | FK to stg_customers. |
| `cfc_id` | VARCHAR | FK to stg_fulfilment_centres. |
| `order_date` | DATE | Date the order was placed. |
| `delivery_slot` | VARCHAR | `morning`, `afternoon`, or `evening`. |
| `status` | VARCHAR | `placing`, `picking`, `dispatched`, `delivered`, or `cancelled`. |
| `promised_delivery_date` | DATE | Delivery date shown at checkout. |
| `actual_delivery_date` | DATE | Confirmed delivery date. Null if undelivered. |
| `is_on_time` | BOOLEAN | `true` = on time, `false` = late, `null` = not yet delivered. |
| `updated_at` | TIMESTAMP | Status-change watermark — also used by the incremental filter. |
| `total_revenue_pence` | INTEGER | Gross order revenue in pence. |
| `total_cost_pence` | INTEGER | Total supplier cost in pence. |
| `total_margin_pence` | INTEGER | Gross margin in pence. |
| `total_revenue_gbp` | NUMERIC(10,2) | Gross revenue in GBP. |
| `total_margin_gbp` | NUMERIC(10,2) | Gross margin in GBP. |
| `margin_pct` | FLOAT | Margin as proportion of revenue. Null for zero-item orders. Validated between 0 and 1. |
| `total_line_items` | INTEGER | Number of distinct product lines. |
| `loyalty_tier` | VARCHAR | Customer loyalty tier at load time: `bronze`, `silver`, or `gold`. |
| `acquisition_channel` | VARCHAR | Customer acquisition channel. |
| `postcode_prefix` | VARCHAR | Delivery area postcode prefix. |
| `cfc_name` | VARCHAR | Name of the fulfilment centre. |
| `region` | VARCHAR | Geographic region of the CFC. |

# Metrics defined on this model

| Metric | Type | Description |
|--------|------|-------------|
| `order_count` | simple count | Total orders placed. |
| `total_revenue_gbp` | simple sum | Sum of gross revenue. |
| `total_margin_gbp` | simple sum | Sum of gross margin. |
| `avg_order_value_gbp` | simple average | Average revenue per order. |
| `on_time_delivery_rate` | ratio | [`on_time_deliveries`](/metrics/on_time_delivery_rate.md) / `delivered_orders`. |
| `gross_margin_rate` | ratio | [`gross_margin_rate`](/metrics/gross_margin_rate.md) = `total_margin_gbp / total_revenue_gbp`. |

# Notes

`order_key` exists for BI tool join stability; `order_id` is the natural key and is the `unique_key` driving the incremental upsert. Do not use `order_key` as the incremental key.

# Upstream

[int_order_details](/models/int_order_details.md), [stg_customers](/models/stg_customers.md), [stg_fulfilment_centres](/models/stg_fulfilment_centres.md).
