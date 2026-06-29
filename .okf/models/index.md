# Models

dbt models across three layers. Staging → Intermediate → Marts.

## Staging (views, schema: `<target>_staging`)

* [stg_customers](stg_customers.md) — cleaned customer records
* [stg_products](stg_products.md) — product catalogue with pence→GBP conversion
* [stg_orders](stg_orders.md) — orders with derived `is_on_time` flag
* [stg_order_items](stg_order_items.md) — line items with historical price
* [stg_fulfilment_centres](stg_fulfilment_centres.md) — CFC reference data

## Intermediate (ephemeral — not written to warehouse)

* [int_order_details](int_order_details.md) — order-level revenue, cost, and margin
* [int_cfc_daily_orders](int_cfc_daily_orders.md) — daily operational summary per CFC

## Marts (tables, schema: `<target>_marts`)

* [fct_orders](fct_orders.md) — incremental fact table; one row per order with commercial context
* [fct_cfc_weekly_performance](fct_cfc_weekly_performance.md) — weekly CFC KPI rollup
