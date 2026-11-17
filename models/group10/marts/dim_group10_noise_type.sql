{{ config(materialized='table', schema='nyc_project_marts_dev') }}

with noise_types as (
    select distinct
        complaint_type as problem,
        descriptor as problem_detail
    from {{ ref('stg_311_noise_complaints') }}
)

select
    farm_fingerprint(concat(
        coalesce(problem, ''), '|',
        coalesce(problem_detail, '')
    )) as noise_type_key,
    problem,
    problem_detail
from noise_types
