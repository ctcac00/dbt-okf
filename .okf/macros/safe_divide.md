---
type: dbt Macro
title: safe_divide
description: Divides numerator by denominator, returning null when the denominator is zero or null instead of raising a division-by-zero error.
tags: [macro, utility, null-safe]
timestamp: 2026-06-29T00:00:00Z
---

A null-safe division wrapper. Returns `null` — not zero — when the denominator is zero or null, preserving the distinction between "no data" and "zero".

# Usage

```sql
{{ safe_divide('sum(on_time_deliveries)', 'sum(delivered_orders)') }}
-- expands to:
-- case
--   when sum(delivered_orders) = 0 or sum(delivered_orders) is null then null
--   else cast(sum(on_time_deliveries) as float) / sum(delivered_orders)
-- end
```

# Arguments

| Argument | Description |
|----------|-------------|
| `numerator` | SQL expression for the top of the division. |
| `denominator` | SQL expression for the bottom. Checked for zero and null. |

# Where used

- [int_order_details](/models/int_order_details.md) — `margin_pct` (guards against zero-item orders)
- [int_cfc_daily_orders](/models/int_cfc_daily_orders.md) — `on_time_rate` (guards against days with no confirmed deliveries)
- [fct_cfc_weekly_performance](/models/fct_cfc_weekly_performance.md) — `weekly_on_time_rate`
