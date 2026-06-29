---
type: dbt Seed
title: raw_orders
description: 40 orders spanning the full fulfilment lifecycle from placement to delivery. Source for stg_orders.
tags: [orders, seed, source, fulfilment]
timestamp: 2026-06-29T00:00:00Z
---

Seed CSV loaded into `grocery_ops_demo_sources.raw_orders`. 40 rows, one per order.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `order_id` | VARCHAR | Unique order identifier. |
| `customer_id` | VARCHAR | FK to [raw_customers](/sources/raw_customers.md). |
| `cfc_id` | VARCHAR | Fulfilment centre assigned to pick this order. FK to [raw_fulfilment_centres](/sources/raw_fulfilment_centres.md). |
| `order_date` | DATE | Calendar date the customer placed the order. |
| `delivery_slot` | VARCHAR | Requested delivery window: `morning`, `afternoon`, or `evening`. |
| `status` | VARCHAR | Current position in the lifecycle: `placing`, `picking`, `dispatched`, `delivered`, `cancelled`. |
| `promised_delivery_date` | DATE | Delivery date shown to the customer at checkout. |
| `actual_delivery_date` | DATE | Date physically delivered. Null until confirmed. |
| `updated_at` | TIMESTAMP | Most recent status-change timestamp. Used as the incremental watermark in [fct_orders](/models/fct_orders.md). |

# Downstream

Staged by [stg_orders](/models/stg_orders.md), which derives the `is_on_time` flag (`actual_delivery_date <= promised_delivery_date`).
