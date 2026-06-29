---
type: dbt Macro
title: generate_schema_name
description: Overrides dbt's default schema naming to emit exact custom_schema_name values rather than the default target_schema__custom_schema concatenation.
tags: [macro, schema, convention]
timestamp: 2026-06-29T00:00:00Z
---

Overrides dbt's built-in `generate_schema_name` macro to change schema naming behaviour.

# Behaviour

| Scenario | dbt default | This macro |
|----------|-------------|------------|
| No custom schema | `target_schema` | `target_schema` |
| Custom schema set | `target_schema__custom_schema` | `custom_schema` (exact, no prefix) |

This means that `+schema: staging` in `dbt_project.yml` produces a schema named exactly `staging`, not `dev__staging` or `prod__staging`.

# Why

The default dbt concatenation is useful when multiple teams share a single Snowflake account, but for a demo project with a dedicated database it adds noise. Using exact schema names keeps Snowflake paths simple and predictable.

# Implication

If this project is ever moved to a shared account, the `generate_schema_name` override should be removed or revised to avoid schema name collisions between users.
