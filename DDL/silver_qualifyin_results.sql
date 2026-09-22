create or replace table workspace.silver.qualifying_results (
    season INT,
    round INT,
    driver_id STRING,
    driver_number STRING,
    constructor_id STRING,
    qualifying_position INT,
    q1_time_ms BIGINT,
    q2_time_ms BIGINT,
    q3_time_ms BIGINT,
    source_file STRING,
    source_modified_at TIMESTAMP,
    bronze_ingested_at TIMESTAMP,
    record_hash STRING,
    silver_updated_at TIMESTAMP
)