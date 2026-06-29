---
type: dbt Seed
title: raw_fulfilment_centres
description: Reference data for 6 automated customer fulfilment centres (CFCs) with capacity and robot fleet size.
tags: [cfc, fulfilment, seed, source, operations]
timestamp: 2026-06-29T00:00:00Z
---

Seed CSV loaded into `grocery_ops_demo_sources.raw_fulfilment_centres`. 6 rows, one per CFC.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `cfc_id` | VARCHAR | Unique CFC identifier (e.g. `CFC001`). |
| `name` | VARCHAR | Human-readable centre name (e.g. `Northern Hub`). |
| `region` | VARCHAR | Geographic region served. |
| `capacity_orders_per_day` | INTEGER | Designed daily order throughput at full robot utilisation. |
| `robot_fleet_size` | INTEGER | Number of autonomous picking robots deployed. |
| `opened_date` | DATE | Date the centre became operationally live. |

# Data snapshot

| CFC | Name | Region | Capacity/day | Robots | Opened |
|-----|------|--------|-------------|--------|--------|
| CFC001 | Northern Hub | North West | 8,000 | 1,050 | 2018-03-01 |
| CFC002 | Southern Hub | South East | 12,000 | 1,800 | 2019-11-01 |
| CFC003 | Midlands Hub | West Midlands | 6,500 | 900 | 2021-06-01 |
| CFC004 | Eastern Hub | East of England | 5,000 | 600 | 2022-09-01 |
| CFC005 | Scottish Hub | Scotland | 4,000 | 500 | 2023-04-01 |
| CFC006 | Western Hub | Wales | 3,000 | 400 | 2024-01-01 |

# Downstream

Staged by [stg_fulfilment_centres](/models/stg_fulfilment_centres.md). `capacity_orders_per_day` is used to calculate `throughput_pct` in [int_cfc_daily_orders](/models/int_cfc_daily_orders.md) and surfaces in [fct_cfc_weekly_performance](/models/fct_cfc_weekly_performance.md).
