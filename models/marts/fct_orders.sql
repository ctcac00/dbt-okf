{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

with order_details as (
    select * from {{ ref('int_order_details') }}

    {% if is_incremental() %}
    where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

cfcs as (
    select * from {{ ref('stg_fulfilment_centres') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['order_id']) }}    as order_key,
    od.order_id,
    od.customer_id,
    od.cfc_id,
    od.order_date,
    od.delivery_slot,
    od.status,
    od.promised_delivery_date,
    od.actual_delivery_date,
    od.is_on_time,
    od.updated_at,
    od.total_revenue_pence,
    od.total_cost_pence,
    od.total_margin_pence,
    od.total_revenue_gbp,
    od.total_margin_gbp,
    od.margin_pct,
    od.total_line_items,
    c.loyalty_tier,
    c.acquisition_channel,
    c.postcode_prefix,
    cf.cfc_name,
    cf.region
from order_details od
left join customers c on od.customer_id = c.customer_id
left join cfcs cf on od.cfc_id = cf.cfc_id
