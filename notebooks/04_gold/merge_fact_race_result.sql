MERGE INTO workspace.gold.fact_race_result AS t

USING (

    SELECT
        xxhash64(
            'RACE_RESULT',
            r.season,
            r.round,
            r.driver_id
        ) AS race_result_key,
        dr.race_key,
        dr.race_date_key,
        dd.driver_key,
        dc.constructor_key,
        r.season,
        r.round,
        r.finish_position,
        r.classified_position,
        r.grid_position,
        r.race_time_ms / 1000.0 AS race_time_seconds,
        r.gap_to_winner_ms / 1000.0 AS gap_to_winner_seconds,
        r.status,
        r.points,
        r.laps_completed,
        CASE
            WHEN r.grid_position > 0
             AND r.finish_position > 0
            THEN r.grid_position - r.finish_position
        END AS positions_gained,
        r.finish_position = 1 AS is_win,
        r.finish_position BETWEEN 1 AND 3 AS is_podium,
        CASE
            WHEN lower(r.status) IN (
                'did not start',
                'did not qualify',
                'did not prequalify',
                'withdrawn'
            )
            THEN false
            ELSE true
        END AS is_started,

        CASE
            WHEN lower(r.status) IN (
                'did not start',
                'did not qualify',
                'did not prequalify',
                'withdrawn',
                'disqualified',
                'excluded'
            )
            THEN false

            WHEN lower(r.status) = 'finished'
              OR lower(r.status) RLIKE '^\\+[0-9]+ laps?$'
            THEN false

            ELSE true
        END AS is_dnf,

        r.record_hash AS source_record_hash,
        r.silver_updated_at AS source_silver_updated_at,

        current_timestamp() AS gold_updated_at

    FROM workspace.silver.race_results r

    JOIN workspace.gold.dim_race dr
      ON r.season = dr.season
     AND r.round = dr.round

    JOIN workspace.gold.dim_driver dd
      ON r.driver_id = dd.driver_id

    LEFT JOIN workspace.gold.dim_constructor dc
      ON r.constructor_id = dc.constructor_id

) AS s

ON t.race_result_key = s.race_result_key

WHEN MATCHED
 AND NOT (
     t.source_record_hash <=> s.source_record_hash
 )
THEN UPDATE SET *

WHEN NOT MATCHED
THEN INSERT *;