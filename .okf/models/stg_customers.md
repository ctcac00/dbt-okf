---
type: dbt Model
title: stg_customers
description: Cleaned and typed customer records. One row per registered customer. Loyalty tier and acquisition channel are normalised to lowercase.
tags: [staging, customers]
timestamp: 2026-06-29T00:00:00Z
---

Materialized as a **view** in the `_staging` schema. Source: [raw_customers](/sources/raw_customers.md).

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `customer_id` | VARCHAR | Unique customer identifier. PK. |
| `signup_date` | DATE | Date the customer created their account. |
| `postcode_prefix` | VARCHAR | Delivery area postcode prefix for regional cohort analysis. |
| `loyalty_tier` | VARCHAR | `bronze`, `silver`, or `gold`. |
| `acquisition_channel` | VARCHAR | `organic`, `paid_search`, `referral`, or `tv_ad`. |

# Downstream

Joined into [fct_orders](/models/fct_orders.md) to bring `loyalty_tier`, `acquisition_channel`, and `postcode_prefix` onto each order row.
