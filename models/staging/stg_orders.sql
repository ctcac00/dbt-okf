with source as (
    select * from {{ ref('raw_orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        cfc_id,
        cast(order_date as date)                as order_date,
        lower(delivery_slot)                    as delivery_slot,
        lower(status)                           as status,
        cast(promised_delivery_date as date)    as promised_delivery_date,
        cast(actual_delivery_date as date)      as actual_delivery_date,
        cast(updated_at as timestamp)           as updated_at,
        case
            when actual_delivery_date is not null
                and actual_delivery_date <= promised_delivery_date
            then true
            when actual_delivery_date is not null
                and actual_delivery_date > promised_delivery_date
            then false
            else null
        end                                     as is_on_time
    from source
)

select * from renamed
