---
type: dbt Model
title: stg_orders
description: Cleaned order records with derived is_on_time punctuality flag. Covers the full fulfilment lifecycle.
tags: [staging, orders, fulfilment]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as a **view** in the `_staging` schema. Source: [raw_orders](/sources/raw_orders.md).

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `order_id` | VARCHAR | Unique order identifier. PK. |
| `customer_id` | VARCHAR | FK to [stg_customers](/models/stg_customers.md). |
| `cfc_id` | VARCHAR | FK to [stg_fulfilment_centres](/models/stg_fulfilment_centres.md). |
| `order_date` | DATE | Date the customer placed the order. |
| `delivery_slot` | VARCHAR | Requested window: `morning`, `afternoon`, or `evening`. |
| `status` | VARCHAR | Lifecycle position: `placing`, `picking`, `dispatched`, `delivered`, or `cancelled`. |
| `promised_delivery_date` | DATE | Date shown to customer at checkout. |
| `actual_delivery_date` | DATE | Date delivered. Null until confirmed. |
| `updated_at` | TIMESTAMP | Most recent status-change timestamp. Incremental watermark for [fct_orders](/models/fct_orders.md). |
| `is_on_time` | BOOLEAN | Derived: `true` if `actual_delivery_date <= promised_delivery_date`, `false` if late, `null` if not yet delivered or cancelled. |

# Notes

`is_on_time` is derived here at staging and propagated unchanged to [int_order_details](/models/int_order_details.md) and [fct_orders](/models/fct_orders.md). The null-means-pending convention is important: filters on `is_on_time IS NOT NULL` isolate the delivered subset.

# Downstream

Joins into [int_order_details](/models/int_order_details.md) and [int_cfc_daily_orders](/models/int_cfc_daily_orders.md).
