merge into workspace.gold.fact_qualifying AS t
using (

    select  
        xxhash64(
            'QUALIFYING',
            qr.season,
            qr.round,
            qr.driver_id
        ) as qualifying_key,
        r.race_key,
        r.race_date_key,
        d.driver_key,
        c.constructor_key,
        qr.season,
        qr.round,
        qr.qualifying_position,
        qr.q1_time_ms / 1000.0 AS q1_seconds,
        concat(
            lpad(floor((qr.q1_time_ms / 1000.0 % 3600) / 60), 2, '0'), 
            ":",
            round(qr.q1_time_ms / 1000.0 % 60, 3)
        ) as q1_minutes,
        qr.q2_time_ms / 1000.0 AS q2_seconds,
        concat(
            lpad(floor((qr.q2_time_ms / 1000.0 % 3600) / 60), 2, '0'), 
            ":",
            round(qr.q2_time_ms / 1000.0 % 60, 3)
        ) as q2_minutes,
        qr.q3_time_ms / 1000.0 AS q3_seconds,
        concat(
            lpad(floor((qr.q3_time_ms / 1000.0 % 3600) / 60), 2, '0'), 
            ":",
            round(qr.q3_time_ms / 1000.0 % 60, 3)
        ) as q3_minutes,

        LEAST(
            q1_time_ms / 1000.0,
            q2_time_ms / 1000.0,
            q3_time_ms / 1000.0
        ) AS best_qualifying_seconds,
        concat(
            lpad(floor((LEAST(
                        q1_time_ms / 1000.0,
                        q2_time_ms / 1000.0,
                        q3_time_ms / 1000.0
                    ) % 3600) / 60), 2, '0'), 
            ":",
            round(LEAST(
                        q1_time_ms / 1000.0,
                        q2_time_ms / 1000.0,
                        q3_time_ms / 1000.0
                    ) % 60, 3)
        )
        AS best_qualifying_minutes,
        qr.record_hash as source_record_hash,
        qr.silver_updated_at as source_silver_updated_at,
        current_timestamp() as gold_updated_at
    from workspace.silver.qualifying_results qr
    JOIN workspace.gold.dim_race r ON qr.season = r.season AND qr.round = r.round
    JOIN workspace.gold.dim_driver d ON qr.driver_id = d.driver_id
    LEFT JOIN workspace.gold.dim_constructor c ON qr.constructor_id = c.constructor_id

) as s 
ON t.qualifying_key = s.qualifying_key

WHEN MATCHED AND NOT (t.source_record_hash <=> s.source_record_hash)
THEN UPDATE SET *

WHEN NOT MATCHED
THEN INSERT *
;


