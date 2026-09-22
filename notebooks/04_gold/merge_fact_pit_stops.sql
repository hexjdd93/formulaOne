merge into workspace.gold.fact_pit_stop AS t

using (

    select 
        xxhash64(
            'PIT_STOP',
            ps.season,
            ps.round,
            ps.driver_id,
            ps.stop_number
        ) as pit_stop_key,
        r.race_key,
        r.race_date_key,
        d.driver_key,
        c.constructor_key,
        ps.season,
        ps.round,
        ps.stop_number,
        ps.pit_in_lap,
        ps.pit_out_lap,
        ps.pit_lane_duration_ms / 1000.0 AS pit_lane_seconds,
        ps.stint_before,
        ps.stint_after,
        ps.compound_before,
        ps.compound_after,
        ps.tyre_life_before_laps,
        ps.tyre_life_after_laps,
        ps.is_complete,
        ps.is_accurate,
        ps.record_hash as source_record_hash,
        ps.source_silver_updated_at,
        current_timestamp() as gold_updated_at
    from workspace.silver.pit_stops ps
    JOIN workspace.gold.dim_race r ON ps.season = r.season AND ps.round = r.round
    JOIN workspace.gold.dim_driver d ON ps.driver_id = d.driver_id
    LEFT JOIN workspace.gold.dim_constructor c ON ps.constructor_id = c.constructor_id
) as s 
ON t.pit_stop_key = s.pit_stop_key

WHEN MATCHED
 AND NOT (
     t.source_record_hash <=> s.source_record_hash
 )
THEN UPDATE SET *

WHEN NOT MATCHED
THEN INSERT *
;