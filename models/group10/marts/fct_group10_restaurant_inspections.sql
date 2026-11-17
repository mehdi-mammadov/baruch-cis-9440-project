{{ config(materialized='table', schema='nyc_project_marts_dev') }}

select
    i.inspection_id,
    d.date_key as inspection_date_key,
    l.location_key,
    r.restaurant_key,
    ir.inspection_result_key,
    i.latitude,
    i.longitude
from {{ ref('stg_restaurant_inspections') }} as i

left join {{ ref('dim_group10_date') }} as d
    on i.inspection_date = d.full_date

left join {{ ref('dim_group10_location') }} as l
    on i.zip_code is not distinct from l.zip_code
    and nullif(i.borough, 'UNSPECIFIED') is not distinct from l.borough
    and i.community_board is not distinct from l.community_board

left join {{ ref('dim_group10_restaurant') }} as r
    on i.legal_business_name is not distinct from r.legal_business_name
    and i.business_address is not distinct from r.business_address
    and i.restaurant_name is not distinct from r.restaurant_name

left join {{ ref('dim_group10_inspection_result') }} as ir
    on i.seating_choice is not distinct from ir.seating_choice
    and i.roadway_compliance_status is not distinct from ir.roadway_compliance_status
    and i.skipped_reason is not distinct from ir.skipped_reason
    