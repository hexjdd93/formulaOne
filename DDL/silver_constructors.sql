create or replace table workspace.silver.constructors (
constructor_id STRING,
constructor_name STRING,
team_color_hex STRING,
source_entity STRING,
source_file STRING,
source_modified_at TIMESTAMP,
bronze_ingested_at TIMESTAMP,
record_hash STRING,
silver_updated_at TIMESTAMP
)