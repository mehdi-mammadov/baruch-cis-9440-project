{{ config(materialized='table', schema='nyc_project_marts_dev') }}

with restaurants as (
    select distinct
        legal_business_name,
        business_address,
        restaurant_name
    from {{ ref('stg_restaurant_inspections') }}
)


select
    farm_fingerprint(concat(
        coalesce(legal_business_name, ''), '|',
        coalesce(business_address, ''), '|',
        coalesce(restaurant_name, '')
    )) as restaurant_key,
    legal_business_name,
    business_address,
    restaurant_name
from restaurants