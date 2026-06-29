---
type: Project
title: grocery_ops_demo
description: dbt demo project modelling online grocery order fulfilment on Snowflake, covering the full pipeline from raw seeds to mart tables.
tags: [dbt, snowflake, demo, grocery, fulfilment]
timestamp: 2026-06-29T00:00:00Z
---

A demo dbt project built on Snowflake. Models the operations of an automated online grocery retailer — from customer order placement through robot picking, dispatch, and delivery at customer fulfilment centres (CFCs).

## Stack

| Layer | Tool |
|-------|------|
| Transformation | dbt Core (or dbt platform) |
| Warehouse | Snowflake |
| Packages | `dbt_utils` (surrogate key), `dbt_expectations` (column range tests), `dbt_date` |
| Infrastructure-as-code | Terraform via `dbt-labs/dbtcloud` provider |

## Model layers

| Layer | Materialization | Schema |
|-------|-----------------|--------|
| Seeds (raw) | Table | `grocery_ops_demo_sources` |
| Staging | View | `<target>_staging` |
| Intermediate | Ephemeral | — (never written to warehouse) |
| Marts | Table | `<target>_marts` |

## Key conventions

- **Currency**: all source data stores monetary values as integer pence. The [`pence_to_pounds`](/macros/pence_to_pounds.md) macro converts to GBP at staging; both representations flow through to marts.
- **Schema naming**: [`generate_schema_name`](/macros/generate_schema_name.md) overrides dbt's default to emit exact `custom_schema_name` values rather than `target_schema__custom_schema`.
- **Incremental strategy**: [`fct_orders`](/models/fct_orders.md) uses `updated_at` as the watermark column. New and updated orders are upserted on each run via `unique_key = order_id`.
- **Cancelled orders**: excluded from all CFC operational metrics in the intermediate layer. Revenue/margin calculations in [`fct_orders`](/models/fct_orders.md) retain them with `status = 'cancelled'` for completeness.
- **Historical price capture**: `unit_price_pence` in `raw_order_items` is the price at order time, not the current catalogue price, preserving accurate margin history.

## Lineage summary

```
raw_customers ──────────────────────────────────► stg_customers ──────────────────► fct_orders
raw_products ────────────────────────────────────► stg_products ──► int_order_details ──► fct_orders
raw_orders ──────────────────────────────────────► stg_orders ───► int_order_details ──► fct_orders
raw_order_items ─────────────────────────────────► stg_order_items ► int_order_details
raw_fulfilment_centres ──────────────────────────► stg_fulfilment_centres ──► int_cfc_daily_orders ──► fct_cfc_weekly_performance
                                                                         └──► fct_orders
```

## Business questions answered

| Question | Model |
|----------|-------|
| Weekly gross margin by region and loyalty tier | [`fct_orders`](/models/fct_orders.md) |
| On-time delivery rate per CFC by week | [`fct_cfc_weekly_performance`](/models/fct_cfc_weekly_performance.md) |
| Throughput utilisation (orders vs. capacity) | [`fct_cfc_weekly_performance`](/models/fct_cfc_weekly_performance.md) |
