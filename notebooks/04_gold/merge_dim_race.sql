MERGE INTO workspace.gold.dim_race AS t
USING (

    SELECT
        xxhash64('RACE', season, round) AS race_key,
        season,
        round,
        xxhash64(
            'CIRCUIT',
            lower(trim(country)),
            lower(trim(location))
        ) AS circuit_key,
        CAST(
            date_format(to_date(event_date), 'yyyyMMdd')
            AS INT
        ) AS race_date_key,
        country,
        location,
        official_event_name,
        event_name,
        event_date,
        event_format,
        session_1_name,
        session_1_start_utc,
        session_2_name,
        session_2_start_utc,
        session_3_name,
        session_3_start_utc,
        session_4_name,
        session_4_start_utc,
        session_5_name,
        session_5_start_utc,
        f1_api_support,
        record_hash AS attribute_hash,
        silver_updated_at AS source_silver_updated_at,
        current_timestamp() AS gold_updated_at

    FROM workspace.silver.races

) AS s

ON t.season = s.season
AND t.round = s.round

WHEN MATCHED AND NOT (t.attribute_hash <=> s.attribute_hash)
THEN UPDATE SET *

WHEN NOT MATCHED
THEN INSERT *
;