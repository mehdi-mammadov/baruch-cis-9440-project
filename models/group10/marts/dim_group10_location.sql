{{ config(materialized='table', schema='nyc_project_marts_dev') }}

with complaints as (
    select
        zip_code,
        nullif(borough, 'UNSPECIFIED') as borough,
        case
            when regexp_contains(upper(community_board), r'^[0-9]{2} ') then
                concat(
                    case substr(upper(community_board), 4)
                        when 'MANHATTAN' then '1'
                        when 'BRONX' then '2'
                        when 'BROOKLYN' then '3'
                        when 'QUEENS' then '4'
                        when 'STATEN ISLAND' then '5'
                    end,
                    substr(community_board, 1, 2)
                )
        end as community_board
    from {{ ref('stg_311_noise_complaints') }}
),

locations as (
    select zip_code, nullif(borough, 'UNSPECIFIED') as borough, community_board
    from {{ ref('stg_restaurant_inspections') }}

    union distinct

    select zip_code, borough, community_board
    from complaints
)

select
    farm_fingerprint(concat(
        coalesce(zip_code, ''), '|',
        coalesce(borough, ''), '|',
        coalesce(community_board, '')
    )) as location_key,
    zip_code,
    borough,
    community_board
from locations
