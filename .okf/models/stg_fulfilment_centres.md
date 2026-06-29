---
type: dbt Model
title: stg_fulfilment_centres
description: Reference data for 6 automated CFCs including capacity and robot fleet size used for throughput utilisation calculations.
tags: [staging, cfc, fulfilment, operations]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as a **view** in the `_staging` schema. Source: [raw_fulfilment_centres](/sources/raw_fulfilment_centres.md).

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `cfc_id` | VARCHAR | Unique CFC identifier. PK. |
| `cfc_name` | VARCHAR | Human-readable centre name for dashboards. |
| `region` | VARCHAR | Geographic region served. |
| `capacity_orders_per_day` | INTEGER | Maximum daily throughput at full robot utilisation. |
| `robot_fleet_size` | INTEGER | Number of autonomous picking robots. |
| `opened_date` | DATE | Date the centre became operationally live. |

# Downstream

Joined into [int_cfc_daily_orders](/models/int_cfc_daily_orders.md) to provide capacity context for `throughput_pct`. Also joined into [fct_orders](/models/fct_orders.md) for `cfc_name` and `region` dimension columns.
