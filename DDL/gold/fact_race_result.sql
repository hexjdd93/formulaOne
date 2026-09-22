CREATE TABLE IF NOT EXISTS workspace.gold.fact_race_result (
    race_result_key BIGINT NOT NULL,

    race_key BIGINT NOT NULL,
    race_date_key INT,
    driver_key BIGINT NOT NULL,
    constructor_key BIGINT,

    season INT,
    round INT,

    finish_position INT,
    classified_position STRING,
    grid_position INT,

    race_time_seconds DOUBLE,
    gap_to_winner_seconds DOUBLE,

    status STRING,
    points DECIMAL(6,2),
    laps_completed INT,

    positions_gained INT,

    is_win BOOLEAN,
    is_podium BOOLEAN,
    is_started BOOLEAN,
    is_dnf BOOLEAN,

    source_record_hash STRING,
    source_silver_updated_at TIMESTAMP,
    gold_updated_at TIMESTAMP
)
USING DELTA;