-- RACE RESULTS
CREATE OR REPLACE VIEW workspace.gold.v_race_results AS
SELECT
    -- Race
    rr.race_key,
    rr.race_date_key,
    rr.season,
    rr.round,
    r.event_name,
    r.official_event_name,
    r.event_format,
    r.event_date,
    r.country,
    r.location,
    -- Driver
    rr.driver_key,
    d.driver_id,
    d.driver_number,
    d.abbreviation,
    d.broadcast_name,
    d.first_name,
    d.last_name,
    d.full_name,
    d.country_code,
    d.headshot_url,
    -- Constructor
    rr.constructor_key,
    c.constructor_id,
    c.constructor_name,
    c.team_color_hex,
    -- Race result
    rr.grid_position,
    rr.finish_position,
    rr.classified_position,
    rr.positions_gained,
    rr.race_time_seconds,
    rr.gap_to_winner_seconds,
    rr.status,
    rr.points,
    rr.laps_completed,
    -- Analytical flags
    rr.is_started,
    rr.is_dnf,
    rr.is_win,
    rr.is_podium,
    -- Useful dashboard ordering
    CONCAT(CAST(rr.season AS STRING), '-', LPAD(CAST(rr.round AS STRING), 2, '0')) AS race_id,
    CONCAT('R', LPAD(CAST(rr.round AS STRING), 2, '0'), ' - ', r.event_name) AS race_label

FROM workspace.gold.fact_race_result rr
JOIN workspace.gold.dim_race r ON rr.race_key = r.race_key
JOIN workspace.gold.dim_driver d ON rr.driver_key = d.driver_key
LEFT JOIN workspace.gold.dim_constructor c ON rr.constructor_key = c.constructor_key
;

-- LAP ANALYSIS
CREATE OR REPLACE VIEW workspace.gold.v_lap_analysis AS
SELECT
    -- Keys
    l.lap_key,
    l.race_key,
    l.race_date_key,
    l.driver_key,
    l.constructor_key,
    -- Race
    l.season,
    l.round,
    r.event_name,
    r.official_event_name,
    r.event_date,
    r.country,
    r.location,
    -- Driver
    d.driver_id,
    d.driver_number,
    d.abbreviation,
    d.full_name,
    d.country_code,
    d.headshot_url,
    -- Constructor
    c.constructor_id,
    c.constructor_name,
    c.team_color_hex,
    -- Lap
    l.lap_number,
    l.stint_number,
    l.lap_time_seconds,
    l.sector_1_seconds,
    l.sector_2_seconds,
    l.sector_3_seconds,
    -- Speed traps
    l.speed_i1_kph,
    l.speed_i2_kph,
    l.speed_fl_kph,
    l.speed_st_kph,
    -- Tyres
    l.compound,
    l.tyre_life_laps,
    l.fresh_tyre,
    -- Race context
    l.position,
    l.track_status,
    -- Flags
    l.is_personal_best,
    l.is_accurate,
    l.is_fastf1_generated,
    l.is_deleted,
    l.deleted_reason,
    l.is_pit_in_lap,
    l.is_pit_out_lap,
    l.is_valid_pace_lap,
    l.is_green_lap,
    -- Used to know if the lap was clean
    (l.is_valid_pace_lap AND l.is_green_lap) AS is_clean_pace_lap,
    CONCAT( CAST(l.season AS STRING), '-', LPAD(CAST(l.round AS STRING), 2, '0')) AS race_id,
    CONCAT('R', LPAD(CAST(l.round AS STRING), 2, '0'), ' - ', r.event_name) AS race_label
FROM workspace.gold.fact_lap l
JOIN workspace.gold.dim_race r ON l.race_key = r.race_key
JOIN workspace.gold.dim_driver d ON l.driver_key = d.driver_key
LEFT JOIN workspace.gold.dim_constructor c ON l.constructor_key = c.constructor_key
;


-- PIT STOP ANALYSIS
CREATE OR REPLACE VIEW workspace.gold.v_pit_stop_analysis AS
SELECT
    -- Keys
    p.pit_stop_key,
    p.race_key,
    p.race_date_key,
    p.driver_key,
    p.constructor_key,
    -- Race
    p.season,
    p.round,
    r.event_name,
    r.official_event_name,
    r.event_date,
    r.country,
    r.location,
    -- Driver
    d.driver_id,
    d.driver_number,
    d.abbreviation,
    d.full_name,
    d.headshot_url,
    -- Constructor
    c.constructor_id,
    c.constructor_name,
    c.team_color_hex,
    -- Stop
    p.stop_number,
    p.pit_in_lap,
    p.pit_out_lap,
    p.pit_lane_seconds,
    -- Stints
    p.stint_before,
    p.stint_after,
    -- Tyres
    p.compound_before,
    p.compound_after,
    p.tyre_life_before_laps,
    p.tyre_life_after_laps,
    -- Flags
    p.is_complete,
    p.is_accurate,
    (p.is_complete AND p.is_accurate AND p.pit_lane_seconds IS NOT NULL AND p.pit_lane_seconds > 0) AS is_valid_pit_stop,
    CONCAT(CAST(p.season AS STRING),'-',LPAD(CAST(p.round AS STRING), 2, '0')) AS race_id,
    CONCAT('R',LPAD(CAST(p.round AS STRING), 2, '0'),' - ',r.event_name) AS race_label
FROM workspace.gold.fact_pit_stop p
JOIN workspace.gold.dim_race r ON p.race_key = r.race_key
JOIN workspace.gold.dim_driver d ON p.driver_key = d.driver_key
LEFT JOIN workspace.gold.dim_constructor c ON p.constructor_key = c.constructor_key
;

-- QUALIFYING ANALYSIS
CREATE OR REPLACE VIEW workspace.gold.v_qualifying_analysis AS
SELECT
    -- Keys
    q.qualifying_key,
    q.race_key,
    q.race_date_key,
    q.driver_key,
    q.constructor_key,
    -- Race
    q.season,
    q.round,
    r.event_name,
    r.official_event_name,
    r.event_date,
    r.country,
    r.location,
    -- Driver
    d.driver_id,
    d.driver_number,
    d.abbreviation,
    d.full_name,
    d.headshot_url,
    -- Constructor
    c.constructor_id,
    c.constructor_name,
    c.team_color_hex,
    -- Qualifying
    q.qualifying_position,
    q.q1_seconds,
    q.q2_seconds,
    q.q3_seconds,
    q.best_qualifying_seconds,
    -- Session reached
    CASE
        WHEN q.q3_seconds IS NOT NULL THEN 'Q3'
        WHEN q.q2_seconds IS NOT NULL THEN 'Q2'
        WHEN q.q1_seconds IS NOT NULL THEN 'Q1'
        ELSE NULL
    END AS qualifying_session_reached,
    -- Pole
    q.qualifying_position = 1 AS is_pole,
    CONCAT(CAST(q.season AS STRING),'-',LPAD(CAST(q.round AS STRING), 2, '0')) AS race_id,
    CONCAT('R',LPAD(CAST(q.round AS STRING), 2, '0'),' - ',r.event_name) AS race_label
FROM workspace.gold.fact_qualifying q
JOIN workspace.gold.dim_race r ON q.race_key = r.race_key
JOIN workspace.gold.dim_driver d ON q.driver_key = d.driver_key
LEFT JOIN workspace.gold.dim_constructor c ON q.constructor_key = c.constructor_key
;

-- QUALIFYING VS RACE
CREATE OR REPLACE VIEW workspace.gold.v_qualifying_vs_race AS
SELECT
    rr.season,
    rr.round,
    r.event_name,
    r.country,
    r.location,
    d.driver_id,
    d.full_name,
    d.abbreviation,
    c.constructor_name,
    c.team_color_hex,
    q.qualifying_position,
    rr.grid_position,
    rr.finish_position,
    q.qualifying_position - rr.finish_position AS qualifying_to_race_delta,
    rr.points,
    rr.is_win,
    rr.is_podium,
    rr.is_dnf
FROM workspace.gold.fact_race_result rr
JOIN workspace.gold.fact_qualifying q ON rr.race_key = q.race_key AND rr.driver_key = q.driver_key
JOIN workspace.gold.dim_race r ON rr.race_key = r.race_key
JOIN workspace.gold.dim_driver d ON rr.driver_key = d.driver_key
LEFT JOIN workspace.gold.dim_constructor c ON rr.constructor_key = c.constructor_key;