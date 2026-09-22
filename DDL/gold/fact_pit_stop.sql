CREATE TABLE IF NOT EXISTS workspace.gold.fact_pit_stop (
    pit_stop_key BIGINT NOT NULL,

    race_key BIGINT NOT NULL,
    race_date_key INT,
    driver_key BIGINT NOT NULL,
    constructor_key BIGINT,

    season INT,
    round INT,
    stop_number INT,

    pit_in_lap INT,
    pit_out_lap INT,

    pit_lane_seconds DOUBLE,

    stint_before INT,
    stint_after INT,

    compound_before STRING,
    compound_after STRING,

    tyre_life_before_laps INT,
    tyre_life_after_laps INT,

    is_complete BOOLEAN,
    is_accurate BOOLEAN,

    source_record_hash STRING,
    source_silver_updated_at TIMESTAMP,
    gold_updated_at TIMESTAMP
)
USING DELTA;