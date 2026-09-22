MERGE INTO workspace.gold.dim_driver AS t
USING (

    SELECT
        xxhash64('DRIVER', driver_id) AS driver_key,
        driver_id,
        driver_number,
        abbreviation,
        broadcast_name,
        first_name,
        last_name,
        full_name,
        country_code,
        headshot_url,
        sha2(
            concat_ws(
                '|',
                coalesce(driver_number, '∅'),
                coalesce(abbreviation, '∅'),
                coalesce(broadcast_name, '∅'),
                coalesce(first_name, '∅'),
                coalesce(last_name, '∅'),
                coalesce(full_name, '∅'),
                coalesce(country_code, '∅'),
                coalesce(headshot_url, '∅')
            )
            , 256
        ) AS attribute_hash,
        silver_updated_at AS source_silver_updated_at,
        current_timestamp() AS gold_updated_at
    FROM workspace.silver.drivers
) AS s

ON t.driver_id = s.driver_id

WHEN MATCHED AND NOT (t.attribute_hash <=> s.attribute_hash)
THEN UPDATE SET *
WHEN NOT MATCHED
THEN INSERT *;