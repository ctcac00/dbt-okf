with source as (
    select * from {{ ref('raw_customers') }}
),

renamed as (
    select
        customer_id,
        cast(signup_date as date)   as signup_date,
        postcode_prefix,
        lower(loyalty_tier)         as loyalty_tier,
        lower(acquisition_channel)  as acquisition_channel
    from source
)

select * from renamed
