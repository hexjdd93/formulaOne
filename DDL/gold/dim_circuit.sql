CREATE TABLE IF NOT EXISTS workspace.gold.dim_circuit (
    circuit_key BIGINT NOT NULL,

    circuit_id_derived STRING NOT NULL,
    country STRING,
    location STRING,

    attribute_hash STRING,
    source_silver_updated_at TIMESTAMP,
    gold_updated_at TIMESTAMP
)
USING DELTA;