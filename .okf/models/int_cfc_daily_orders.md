---
type: dbt Model
title: int_cfc_daily_orders
description: Ephemeral daily operational summary per CFC, aggregating order counts, on-time delivery metrics, and throughput utilisation. Cancelled orders are excluded.
tags: [intermediate, cfc, operations, ephemeral]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as **ephemeral** — compiled into the CTE of [fct_cfc_weekly_performance](/models/fct_cfc_weekly_performance.md).

Aggregates [stg_orders](/models/stg_orders.md) by `cfc_id` and `order_date`, then joins [stg_fulfilment_centres](/models/stg_fulfilment_centres.md) for capacity context.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `cfc_id` | VARCHAR | Fulfilment centre identifier. |
| `cfc_name` | VARCHAR | Human-readable centre name. |
| `region` | VARCHAR | Geographic region. |
| `capacity_orders_per_day` | INTEGER | Centre's designed maximum daily throughput. |
| `robot_fleet_size` | INTEGER | Number of picking robots deployed. |
| `order_date` | DATE | Calendar date these metrics cover. |
| `orders_fulfilled` | INTEGER | Non-cancelled orders processed on this date. |
| `on_time_deliveries` | INTEGER | Orders delivered on or before promised date on this date. |
| `delivered_orders` | INTEGER | Orders with a confirmed `actual_delivery_date` on this date. |
| `on_time_rate` | FLOAT | `on_time_deliveries / delivered_orders` via [`safe_divide`](/macros/safe_divide.md). Null if no confirmed deliveries. |
| `throughput_pct` | FLOAT | `orders_fulfilled / capacity_orders_per_day`. Values > 1.0 indicate above-capacity operation. |

# Notes

Cancelled orders are excluded from `orders_fulfilled` — they never enter the picking pipeline. This is a deliberate operational convention: capacity utilisation is measured only against active fulfilment pipeline work.

# Downstream

Consumed only by [fct_cfc_weekly_performance](/models/fct_cfc_weekly_performance.md).
