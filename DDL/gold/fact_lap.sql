CREATE TABLE IF NOT EXISTS workspace.gold.fact_lap (
    lap_key BIGINT NOT NULL,

    race_key BIGINT NOT NULL,
    race_date_key INT,
    driver_key BIGINT NOT NULL,
    constructor_key BIGINT,

    season INT,
    round INT,
    lap_number INT,
    stint_number INT,

    lap_time_seconds DOUBLE,

    sector_1_seconds DOUBLE,
    sector_2_seconds DOUBLE,
    sector_3_seconds DOUBLE,

    speed_i1_kph DOUBLE,
    speed_i2_kph DOUBLE,
    speed_fl_kph DOUBLE,
    speed_st_kph DOUBLE,

    compound STRING,
    tyre_life_laps INT,
    fresh_tyre BOOLEAN,

    position INT,
    track_status STRING,

    is_personal_best BOOLEAN,
    is_accurate BOOLEAN,
    is_fastf1_generated BOOLEAN,

    is_deleted BOOLEAN,
    deleted_reason STRING,

    is_pit_in_lap BOOLEAN,
    is_pit_out_lap BOOLEAN,

    is_valid_pace_lap BOOLEAN,
    is_green_lap BOOLEAN,

    source_record_hash STRING,
    source_silver_updated_at TIMESTAMP,
    gold_updated_at TIMESTAMP
)
USING DELTA;