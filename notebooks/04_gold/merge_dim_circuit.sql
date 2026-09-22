MERGE INTO workspace.gold.dim_circuit AS t
USING (
    SELECT
        xxhash64('CIRCUIT', lower(trim(country)),lower(trim(location))) AS circuit_key,
        concat(regexp_replace(lower(trim(country)), '[^a-z0-9]+', '_'), '_', regexp_replace(lower(trim(location)), '[^a-z0-9]+', '_')) AS circuit_id,
        country,
        location,
        sha2(
            concat_ws(
                '||',
                coalesce(country, '∅'),
                coalesce(location, '∅')
            )
            , 256
        ) AS attribute_hash,
        
        max(silver_updated_at) AS source_silver_updated_at,
        current_timestamp() AS gold_updated_at
    FROM workspace.silver.races

    GROUP BY
        country,
        location

) AS s

ON t.circuit_key = s.circuit_key

WHEN MATCHED AND NOT (t.attribute_hash <=> s.attribute_hash)
THEN UPDATE SET *

WHEN NOT MATCHED
THEN INSERT *;