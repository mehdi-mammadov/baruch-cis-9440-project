{{ config(materialized='table', schema='nyc_project_marts_dev') }}

with resolutions as (
    select distinct
        status,
        resolution_description
    from {{ ref('stg_311_noise_complaints') }}
)

select
    farm_fingerprint(concat(
        coalesce(status, ''), '|',
        coalesce(resolution_description, '')
    )) as resolution_key,
    status,
    resolution_description
from resolutions
