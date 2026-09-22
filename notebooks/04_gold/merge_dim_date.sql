MERGE INTO workspace.gold.dim_date AS t
USING (

    WITH bounds AS (
        SELECT
            min(to_date(event_date)) AS min_date,
            max(to_date(event_date)) AS max_date
        FROM workspace.silver.races
    )
    , dates AS (
        SELECT explode(
            sequence(
                min_date,
                max_date,
                INTERVAL 1 DAY
            )
        ) AS full_date
        FROM bounds
    )
    SELECT
        CAST(date_format(full_date, 'yyyyMMdd') AS INT) AS date_key,
        full_date,

        year(full_date) AS year,
        quarter(full_date) AS quarter,
        month(full_date) AS month,
        date_format(full_date, 'MMMM') AS month_name,
        weekofyear(full_date) AS week_of_year,
        day(full_date) AS day_of_month,
        dayofweek(full_date) AS day_of_week,
        date_format(full_date, 'EEEE') AS day_name,
        dayofweek(full_date) IN (1,7) AS is_weekend
    FROM dates

) AS s

ON t.date_key = s.date_key

WHEN NOT MATCHED
THEN INSERT *
;