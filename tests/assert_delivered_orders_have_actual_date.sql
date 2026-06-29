-- Delivered orders must have an actual delivery date recorded.
-- Any row returned here indicates a data quality issue in the source system.
select order_id
from {{ ref('fct_orders') }}
where status = 'delivered'
  and actual_delivery_date is null
