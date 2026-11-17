select
    restaurantinspectionid as inspection_id,
    date(inspectedon) as inspection_date,
    nullif(upper(trim(borough)), '') as borough,
    nullif(trim(postcode), '') as zip_code,
    nullif(trim(communityboard), '') as community_board,
    nullif(trim(restaurantname), '') as restaurant_name,
    nullif(trim(legalbusinessname), '') as legal_business_name,
    nullif(trim(businessaddress), '') as business_address,
    nullif(lower(trim(seatingchoice)), '') as seating_choice,
    nullif(trim(isroadwaycompliant), '') as roadway_compliance_status,
    nullif(trim(skippedreason), '') as skipped_reason,
    latitude,
    longitude
from {{ source("group10_raw", "source_nyc_open_restaurant_inspections") }}
