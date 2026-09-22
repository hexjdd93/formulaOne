merge into workspace.gold.fact_lap as t 
using (


    SELECT
        xxhash64(
            'LAP',
            l.season,
            l.round,
            l.driver_id,
            l.lap_number
        ) AS lap_key,

        r.race_key,
        r.race_date_key,
        d.driver_key,
        c.constructor_key,

        l.season,
        l.round,
        l.lap_number,
        l.stint_number,

        l.lap_time_ms / 1000.0 AS lap_time_seconds,

        l.sector_1_time_ms / 1000.0 AS sector_1_seconds,
        l.sector_2_time_ms / 1000.0 AS sector_2_seconds,
        l.sector_3_time_ms / 1000.0 AS sector_3_seconds,

        l.speed_i1_kph,
        l.speed_i2_kph,
        l.speed_fl_kph,
        l.speed_st_kph,

        l.compound,
        l.tyre_life_laps,
        l.fresh_tyre,

        l.position,
        l.track_status,

        l.is_personal_best,
        l.is_accurate,
        l.is_fastf1_generated,

        l.is_deleted,
        l.deleted_reason,

        l.pit_in_time_ms IS NOT NULL AS is_pit_in_lap,
        l.pit_out_time_ms IS NOT NULL AS is_pit_out_lap,

        (
            NOT coalesce(l.is_deleted, false)
            AND coalesce(l.is_accurate, false)
            AND l.lap_time_ms > 0
            AND l.pit_in_time_ms IS NULL
            AND l.pit_out_time_ms IS NULL
        ) AS is_valid_pace_lap,

        l.track_status = '1' AS is_green_lap,

        l.record_hash AS source_record_hash,
        l.silver_updated_at AS source_silver_updated_at,

        current_timestamp() AS gold_updated_at

    FROM workspace.silver.laps l

    JOIN workspace.gold.dim_race r ON l.season = r.season AND l.round = r.round

    JOIN workspace.gold.dim_driver d ON l.driver_id = d.driver_id

    LEFT JOIN workspace.gold.dim_constructor c ON l.constructor_id = c.constructor_id
) as s


ON t.lap_key = s.lap_key

WHEN MATCHED AND NOT (t.source_record_hash = s.source_record_hash) 
THEN UPDATE SET *

WHEN NOT MATCHED
THEN INSERT *
;