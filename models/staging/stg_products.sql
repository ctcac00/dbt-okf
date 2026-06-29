with source as (
    select * from {{ ref('raw_products') }}
),

renamed as (
    select
        product_id,
        sku,
        name                                            as product_name,
        category,
        subcategory,
        cast(unit_price_pence as integer)               as unit_price_pence,
        cast(cost_pence as integer)                     as cost_pence,
        {{ pence_to_pounds('unit_price_pence') }}       as unit_price_gbp,
        {{ pence_to_pounds('cost_pence') }}             as cost_gbp,
        cast(weight_g as integer)                       as weight_g,
        case when upper(is_chilled) = 'Y' then true else false end as is_chilled
    from source
)

select * from renamed
