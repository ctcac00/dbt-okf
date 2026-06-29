---
type: dbt Macro
title: pence_to_pounds
description: Converts an integer pence column to GBP, rounded to 2 decimal places. Used at staging to produce *_gbp derived columns.
tags: [macro, currency, utility]
timestamp: 2026-06-29T00:00:00Z
---

Converts any integer pence expression to pounds sterling, rounded to 2dp.

# Usage

```sql
{{ pence_to_pounds('unit_price_pence') }}
-- expands to: round(cast(unit_price_pence as numeric) / 100.0, 2)
```

# Arguments

| Argument | Description |
|----------|-------------|
| `column` | A column name or SQL expression in pence (integer). |

# Where used

- [stg_products](/models/stg_products.md) — `unit_price_gbp`, `cost_gbp`
- [stg_order_items](/models/stg_order_items.md) — `unit_price_gbp`

Intermediate and mart GBP columns are derived by aggregating the staged GBP values rather than re-applying this macro.
