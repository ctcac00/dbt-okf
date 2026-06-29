with orders as (
    select * from {{ ref('stg_orders') }}
    where status != 'cancelled'
),

cfcs as (
    select * from {{ ref('stg_fulfilment_centres') }}
),

daily_agg as (
    select
        cfc_id,
        order_date,
        count(order_id)                                             as orders_fulfilled,
        sum(case when is_on_time = true then 1 else 0 end)         as on_time_deliveries,
        sum(case when is_on_time is not null then 1 else 0 end)    as delivered_orders
    from orders
    group by 1, 2
)

select
    d.cfc_id,
    c.cfc_name,
    c.region,
    c.capacity_orders_per_day,
    c.robot_fleet_size,
    d.order_date,
    d.orders_fulfilled,
    d.on_time_deliveries,
    d.delivered_orders,
    {{ safe_divide('d.on_time_deliveries', 'd.delivered_orders') }}                     as on_time_rate,
    {{ safe_divide('d.orders_fulfilled', 'c.capacity_orders_per_day') }}                as throughput_pct
from daily_agg d
left join cfcs c on d.cfc_id = c.cfc_id
