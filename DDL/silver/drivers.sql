create or replace table workspace.silver.drivers (
    driver_id string not null,
    driver_number string, 
    abbreviation string,
    broadcast_name string,
    first_name string, 
    last_name string, 
    full_name string, 
    country_code string,
    headshot_url string, 

    source_entity string,
    source_file string,
    source_modified_at timestamp,
    bronze_ingested_at timestamp,
   
    silver_updated_at timestamp,
    record_hash string
)