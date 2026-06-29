---
type: dbt Seed
title: raw_order_items
description: 94 order line items linking orders to products, with price captured at the time of order.
tags: [orders, items, seed, source, currency]
timestamp: 2026-06-29T00:00:00Z
---

Seed CSV loaded into `grocery_ops_demo_sources.raw_order_items`. 94 rows, one per product line within an order.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `item_id` | VARCHAR | Unique line item identifier. |
| `order_id` | VARCHAR | FK to [raw_orders](/sources/raw_orders.md). |
| `product_id` | VARCHAR | FK to [raw_products](/sources/raw_products.md). |
| `quantity` | INTEGER | Units of this product in the order. |
| `unit_price_pence` | INTEGER | Price per unit **at order time**, in pence. May differ from current catalogue price. |
| `picked_at` | TIMESTAMP | When the robot picked this item. Null if not yet picked. |

# Notes

`unit_price_pence` is a point-in-time snapshot, not a reference to the current catalogue price. This preserves accurate historical margin calculations even after catalogue prices change.

# Downstream

Staged by [stg_order_items](/models/stg_order_items.md) and joined with product costs in [int_order_details](/models/int_order_details.md) to compute per-order revenue and margin.
