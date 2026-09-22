CREATE TABLE IF NOT EXISTS workspace.gold.dim_race (
    race_key BIGINT NOT NULL,

    season INT NOT NULL,
    round INT NOT NULL,

    circuit_key BIGINT,
    race_date_key INT,

    country STRING,
    location STRING,
    official_event_name STRING,
    event_name STRING,
    event_date TIMESTAMP_NTZ,
    event_format STRING,

    session_1_name STRING,
    session_1_start_utc TIMESTAMP_NTZ,
    session_2_name STRING,
    session_2_start_utc TIMESTAMP_NTZ,
    session_3_name STRING,
    session_3_start_utc TIMESTAMP_NTZ,
    session_4_name STRING,
    session_4_start_utc TIMESTAMP_NTZ,
    session_5_name STRING,
    session_5_start_utc TIMESTAMP_NTZ,

    f1_api_support BOOLEAN,

    attribute_hash STRING,
    source_silver_updated_at TIMESTAMP,
    gold_updated_at TIMESTAMP
)
USING DELTA;