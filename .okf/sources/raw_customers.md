---
type: dbt Seed
title: raw_customers
description: 30 customer accounts with loyalty tier and acquisition channel. Source for stg_customers.
tags: [customers, seed, source]
timestamp: 2026-06-29T00:00:00Z
---

Seed CSV loaded into `grocery_ops_demo_sources.raw_customers`. 30 rows, one per registered customer.

# Schema

| Column | Type | Description |
|--------|------|-------------|
| `customer_id` | VARCHAR | Unique customer identifier (e.g. `CUS001`). |
| `signup_date` | DATE | Date the customer created their account. |
| `postcode_prefix` | VARCHAR | First segment of the UK delivery postcode (e.g. `SW`, `M`, `LS`). Used for regional cohort analysis. |
| `loyalty_tier` | VARCHAR | Loyalty programme membership: `bronze`, `silver`, or `gold`. |
| `acquisition_channel` | VARCHAR | Marketing channel: `organic`, `paid_search`, `referral`, or `tv_ad`. |

# Downstream

Staged by [stg_customers](/models/stg_customers.md), which normalises tier and channel to lowercase and enforces accepted-value tests.
