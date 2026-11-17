{{ config(materialized='table', schema='nyc_project_marts_dev') }}

with event_dates as (
    select inspection_date as full_date
    from {{ ref('stg_restaurant_inspections') }}

    union distinct

    select complaint_date as full_date
    from {{ ref('stg_311_noise_complaints') }}
)

select
    cast(format_date('%Y%m%d', full_date) as int64) as date_key,
    full_date,
    extract(year from full_date) as year,
    extract(quarter from full_date) as quarter,
    extract(month from full_date) as month,
    format_date('%B', full_date) as month_name,
    format_date('%A', full_date) as day_of_week,
    extract(dayofweek from full_date) in (1, 7) as is_weekend
from event_dates
where full_date is not null
