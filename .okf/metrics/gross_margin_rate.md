---
type: Metric
title: gross_margin_rate
description: Gross margin as a proportion of revenue — total_margin_gbp divided by total_revenue_gbp. The primary commercial profitability KPI.
tags: [metric, margin, commercial, kpi]
timestamp: 2026-06-29T00:00:00Z
---

The fraction of gross revenue retained after deducting supplier cost. Expressed as a decimal (0.0–1.0); a value of 0.30 means 30p of every £1 of revenue is gross margin.

# Definition

```
gross_margin_rate = total_margin_gbp / total_revenue_gbp
```

| Component | Definition |
|-----------|-----------|
| `total_margin_gbp` | SUM of `(revenue − cost)` in GBP per order |
| `total_revenue_gbp` | SUM of order revenue in GBP |

# Type

`ratio` metric in dbt Semantic Layer. Numerator and denominator are each simple sum metrics.

# Revenue vs. cost basis

Revenue uses `stg_order_items.unit_price_pence` — the price actually charged at order time. Cost uses `stg_products.cost_pence` — current catalogue supplier cost. This means cost figures may drift slightly if supplier costs are renegotiated after orders are placed.

# Grain

Defined on [fct_orders](/models/fct_orders.md) with `agg_time_dimension = order_date`. Can be sliced by `loyalty_tier`, `region`, `cfc_name`, `acquisition_channel`, and `postcode_prefix`.

# Row-level equivalent

`margin_pct` on [fct_orders](/models/fct_orders.md) is the per-order margin percentage, validated to be between 0 and 1. `gross_margin_rate` is the aggregated form suitable for period-level reporting.
