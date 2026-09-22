CREATE OR REPLACE TABLE workspace.gold.fact_qualifying (
    qualifying_key BIGINT NOT NULL,

    race_key BIGINT NOT NULL,
    race_date_key INT,
    driver_key BIGINT NOT NULL,
    constructor_key BIGINT,

    season INT,
    round INT,

    qualifying_position INT,

    q1_seconds DOUBLE,
    q1_minutes STRING,
    q2_seconds DOUBLE,
    q2_minutes STRING,
    q3_seconds DOUBLE,
    q3_minutes STRING,

    best_qualifying_seconds DOUBLE,
    best_qualifying_minutes STRING,

    source_record_hash STRING,
    source_silver_updated_at TIMESTAMP,
    gold_updated_at TIMESTAMP
)
USING DELTA;