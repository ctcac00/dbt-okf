---
type: dbt Model
title: fct_cfc_weekly_performance
description: Weekly operational KPI summary per CFC — order throughput, on-time delivery rate, and capacity utilisation. Intended for operations leadership dashboards.
tags: [mart, cfc, operations, weekly]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as a **table** in the `_marts` schema. Rebuilt fully on each run (not incremental).

Aggregates [int_cfc_daily_orders](/models/int_cfc_daily_orders.md) to the weekly grain using `date_trunc('week', order_date)`.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `cfc_id` | VARCHAR | Fulfilment centre identifier. |
| `cfc_name` | VARCHAR | Human-readable centre name. |
| `region` | VARCHAR | Geographic region. |
| `capacity_orders_per_day` | INTEGER | Designed daily throughput. |
| `robot_fleet_size` | INTEGER | Number of picking robots. |
| `week_start` | DATE | Monday of the reporting week (ISO week). |
| `weekly_orders` | INTEGER | Total non-cancelled orders processed during the week. |
| `weekly_on_time_deliveries` | INTEGER | Orders delivered on or before promised date. |
| `weekly_delivered_orders` | INTEGER | Orders with a confirmed delivery date. |
| `weekly_on_time_rate` | FLOAT | `weekly_on_time_deliveries / weekly_delivered_orders`. Null if no deliveries confirmed. |
| `avg_daily_throughput_pct` | FLOAT | Average of `throughput_pct` across days in the week. Values > 1.0 indicate above-capacity operation. |

# Notes

`avg_daily_throughput_pct` is the average of daily ratios (not a ratio of weekly sums), so it correctly weights each day equally regardless of varying daily order counts.

`weekly_on_time_rate` uses [`safe_divide`](/macros/safe_divide.md) and returns null for weeks with no confirmed deliveries — this typically occurs at CFCs that are still very new and have only orders in `dispatched` status.

# Upstream

[int_cfc_daily_orders](/models/int_cfc_daily_orders.md).
