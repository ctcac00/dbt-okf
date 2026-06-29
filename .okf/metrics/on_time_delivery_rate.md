---
type: Metric
title: on_time_delivery_rate
description: Proportion of delivered orders that arrived on or before their promised delivery date. The primary customer-experience KPI.
tags: [metric, delivery, operations, kpi]
timestamp: 2026-06-29T00:00:00Z
---

The fraction of orders with a confirmed delivery that were delivered on or before the date promised at checkout.

# Definition

```
on_time_delivery_rate = on_time_deliveries / delivered_orders
```

| Component | Definition |
|-----------|-----------|
| `on_time_deliveries` | COUNT of orders where `is_on_time = true` |
| `delivered_orders` | COUNT of orders where `is_on_time IS NOT NULL` (i.e. has a confirmed delivery date) |

# Type

`ratio` metric in dbt Semantic Layer — numerator (`on_time_deliveries`) and denominator (`delivered_orders`) are each simple count metrics.

# Denominator scope

Only orders with a confirmed `actual_delivery_date` are included. Orders still in `placing`, `picking`, or `dispatched` status have `is_on_time = null` and are excluded. Cancelled orders are also excluded.

# Grain

Defined on [fct_orders](/models/fct_orders.md) with `agg_time_dimension = order_date`. Can be sliced by `loyalty_tier`, `region`, `cfc_name`, `delivery_slot`, and `postcode_prefix`.

# Related metric

See also [gross_margin_rate](/metrics/gross_margin_rate.md) for the commercial counterpart. Weekly CFC-level on-time rate is precomputed in [fct_cfc_weekly_performance](/models/fct_cfc_weekly_performance.md).
