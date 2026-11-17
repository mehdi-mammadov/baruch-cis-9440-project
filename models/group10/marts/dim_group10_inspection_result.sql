{{ config(materialized='table', schema='nyc_project_marts_dev') }}

with inspection_results as (
    select distinct
        seating_choice,
        roadway_compliance_status,
        skipped_reason
    from {{ ref('stg_restaurant_inspections') }}
)

select
    farm_fingerprint(concat(
        coalesce(seating_choice, ''), '|',
        coalesce(roadway_compliance_status, ''), '|',
        coalesce(skipped_reason, '')
    )) as inspection_result_key,
    seating_choice,
    roadway_compliance_status,
    skipped_reason
from inspection_results
