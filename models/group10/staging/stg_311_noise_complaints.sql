select distinct
    unique_key as request_id,
    created_date as created_at,
    date(created_date) as complaint_date,
    nullif(trim(complaint_type), '') as complaint_type,
    nullif(trim(descriptor), '') as descriptor,
    nullif(upper(trim(status)), '') as status,
    nullif(trim(resolution_description), '') as resolution_description,
    nullif(trim(incident_zip), '') as zip_code,
    nullif(upper(trim(borough)), '') as borough,
    nullif(trim(community_board), '') as community_board,
    latitude,
    longitude
from {{ source('group10_raw', 'source_nyc_311_noise_complaints') }}
where lower(trim(complaint_type)) = 'noise - commercial'

