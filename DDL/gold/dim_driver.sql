CREATE TABLE IF NOT EXISTS workspace.gold.dim_driver (
    driver_key BIGINT NOT NULL,
    driver_id STRING NOT NULL,

    driver_number STRING,
    abbreviation STRING,
    broadcast_name STRING,
    first_name STRING,
    last_name STRING,
    full_name STRING,
    country_code STRING,
    headshot_url STRING,

    attribute_hash STRING,
    source_silver_updated_at TIMESTAMP,
    gold_updated_at TIMESTAMP
)
USING DELTA;