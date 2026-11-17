{{ config(materialized='table', schema='nyc_project_marts_dev') }}

with complaints as (
    select distinct *
    from {{ ref('stg_311_noise_complaints') }}
),

normalized as (
    select
        * replace (
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
        )
    from complaints
)

select
    c.request_id,
    d.date_key as complaint_date_key,
    l.location_key,
    n.noise_type_key,
    r.resolution_key,
    c.latitude,
    c.longitude
from normalized as c
left join {{ ref('dim_group10_date') }} as d
    on c.complaint_date = d.full_date
left join {{ ref('dim_group10_location') }} as l
    on c.zip_code is not distinct from l.zip_code
    and c.borough is not distinct from l.borough
    and c.community_board is not distinct from l.community_board
left join {{ ref('dim_group10_noise_type') }} as n
    on c.complaint_type is not distinct from n.problem
    and c.descriptor is not distinct from n.problem_detail
left join {{ ref('dim_group10_resolution') }} as r
    on c.status is not distinct from r.status
    and c.resolution_description is not distinct from r.resolution_description
    