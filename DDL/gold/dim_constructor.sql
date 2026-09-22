CREATE TABLE IF NOT EXISTS workspace.gold.dim_constructor (
    constructor_key BIGINT NOT NULL,
    constructor_id STRING NOT NULL,

    constructor_name STRING,
    team_color_hex STRING,

    attribute_hash STRING,
    source_silver_updated_at TIMESTAMP,
    gold_updated_at TIMESTAMP
)
USING DELTA;