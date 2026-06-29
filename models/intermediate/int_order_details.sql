with orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

items_with_margin as (
    select
        oi.order_id,
        oi.quantity * oi.unit_price_pence   as line_revenue_pence,
        oi.quantity * p.cost_pence          as line_cost_pence
    from order_items oi
    left join products p on oi.product_id = p.product_id
),

order_totals as (
    select
        order_id,
        sum(line_revenue_pence)                         as total_revenue_pence,
        sum(line_cost_pence)                            as total_cost_pence,
        sum(line_revenue_pence - line_cost_pence)       as total_margin_pence,
        count(*)                                        as total_line_items
    from items_with_margin
    group by 1
)

select
    o.order_id,
    o.customer_id,
    o.cfc_id,
    o.order_date,
    o.delivery_slot,
    o.status,
    o.promised_delivery_date,
    o.actual_delivery_date,
    o.is_on_time,
    o.updated_at,
    t.total_revenue_pence,
    t.total_cost_pence,
    t.total_margin_pence,
    {{ pence_to_pounds('t.total_revenue_pence') }}                                  as total_revenue_gbp,
    {{ pence_to_pounds('t.total_margin_pence') }}                                   as total_margin_gbp,
    {{ safe_divide('t.total_margin_pence', 't.total_revenue_pence') }}              as margin_pct,
    t.total_line_items
from orders o
left join order_totals t on o.order_id = t.order_id
