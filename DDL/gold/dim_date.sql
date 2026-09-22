CREATE TABLE IF NOT EXISTS workspace.gold.dim_date (
    date_key INT NOT NULL,
    full_date DATE NOT NULL,

    year INT,
    quarter INT,
    month INT,
    month_name STRING,
    week_of_year INT,
    day_of_month INT,
    day_of_week INT,
    day_name STRING,
    is_weekend BOOLEAN
)
USING DELTA;