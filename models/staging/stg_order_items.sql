with source as (
    select * from {{ ref('raw_order_items') }}
),

renamed as (
    select
        item_id,
        order_id,
        product_id,
        cast(quantity as integer)               as quantity,
        cast(unit_price_pence as integer)       as unit_price_pence,
        {{ pence_to_pounds('unit_price_pence') }} as unit_price_gbp,
        cast(picked_at as timestamp)            as picked_at
    from source
)

select * from renamed
