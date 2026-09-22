MERGE INTO workspace.gold.dim_constructor AS t
USING (
    SELECT
        xxhash64('CONSTRUCTOR', constructor_id) AS constructor_key,
        constructor_id,
        constructor_name,
        team_color_hex,
        sha2(
            concat_ws(
                '|',
                coalesce(constructor_name, '∅'),
                coalesce(team_color_hex, '∅')
            )
            , 256
        ) AS attribute_hash,
        silver_updated_at AS source_silver_updated_at,
        current_timestamp() AS gold_updated_at
    FROM workspace.silver.constructors
) AS s

ON t.constructor_id = s.constructor_id

WHEN MATCHED
 AND NOT (t.attribute_hash <=> s.attribute_hash)
THEN UPDATE SET *

WHEN NOT MATCHED
THEN INSERT *;