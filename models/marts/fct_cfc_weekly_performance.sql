{{
    config(materialized='table')
}}

with daily_ops as (
    select * from {{ ref('int_cfc_daily_orders') }}
)

select
    cfc_id,
    cfc_name,
    region,
    capacity_orders_per_day,
    robot_fleet_size,
    date_trunc('week', order_date)                                              as week_start,
    sum(orders_fulfilled)                                                       as weekly_orders,
    sum(on_time_deliveries)                                                     as weekly_on_time_deliveries,
    sum(delivered_orders)                                                       as weekly_delivered_orders,
    {{ safe_divide('sum(on_time_deliveries)', 'sum(delivered_orders)') }}       as weekly_on_time_rate,
    avg(throughput_pct)                                                         as avg_daily_throughput_pct
from daily_ops
group by 1, 2, 3, 4, 5, 6
