with source as (
    select * from {{ ref('raw_fulfilment_centres') }}
),

renamed as (
    select
        cfc_id,
        name                                        as cfc_name,
        region,
        cast(capacity_orders_per_day as integer)    as capacity_orders_per_day,
        cast(robot_fleet_size as integer)           as robot_fleet_size,
        cast(opened_date as date)                   as opened_date
    from source
)

select * from renamed
