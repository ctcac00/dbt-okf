---
type: dbt Model
title: stg_order_items
description: Individual order line items with price captured at order time for accurate historical margin calculations.
tags: [staging, orders, items]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as a **view** in the `_staging` schema. Source: [raw_order_items](/sources/raw_order_items.md).

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `item_id` | VARCHAR | Unique line item identifier. PK. |
| `order_id` | VARCHAR | FK to [stg_orders](/models/stg_orders.md). |
| `product_id` | VARCHAR | FK to [stg_products](/models/stg_products.md). |
| `quantity` | INTEGER | Units of this product in the order. |
| `unit_price_pence` | INTEGER | Price per unit **at order time**, in pence. Snapshot, not current catalogue price. |
| `unit_price_gbp` | NUMERIC(10,2) | Order-time price in GBP via [`pence_to_pounds`](/macros/pence_to_pounds.md). |
| `picked_at` | TIMESTAMP | When the robot picked this item. Null if not yet picked. |

# Notes

`unit_price_pence` is a historical snapshot — not joined back to `stg_products.unit_price_pence`. Using the snapshotted price in revenue calculations ensures margin history remains accurate even after catalogue repricing.

# Downstream

Aggregated in [int_order_details](/models/int_order_details.md) (joined with product costs from [stg_products](/models/stg_products.md)).
