# Databricks notebook source
# MAGIC %md
# MAGIC # Imports
# MAGIC

# COMMAND ----------

import matplotlib.pyplot as plt
from pathlib import Path
import numpy as np
import pandas as pd
import fastf1

# COMMAND ----------

# MAGIC %md
# MAGIC # Variables

# COMMAND ----------

# YEAR variables must be setted before running
YEAR = 2025
DIRECTORIO_ACTUAL = Path(__file__).resolve().parent

carpeta_destino = DIRECTORIO_ACTUAL / "landing" / 'events' /f'season={YEAR}'

print(DIRECTORIO_ACTUAL)

# COMMAND ----------

# MAGIC %md
# MAGIC # Creación del scheduling

# COMMAND ----------

schedule = fastf1.get_event_schedule(YEAR)
# # Crea la carpeta y todas sus carpetas superiores si no existen
carpeta_destino.mkdir(parents=True, exist_ok=True)

# # Define la ruta completa del ARCHIVO uniendo la carpeta con el nombre
ruta_final_archivo = carpeta_destino / "events.parquet"

# # Seleccionar las columnas a guardar
schedule = schedule[[
    'RoundNumber', 'Country', 'Location', 'OfficialEventName', 'EventDate',
    'EventName', 'EventFormat', 'Session1', 'Session1DateUtc', 'Session2', 'Session2DateUtc',
    'Session3', 'Session3DateUtc', 'Session4', 'Session4DateUtc', 'Session5', 'Session5DateUtc', 'F1ApiSupport'
]]

schedule = schedule[schedule['EventName'].str.contains('Grand Prix', na=False)]

# # 5. Guarda el DataFrame usando la ruta correcta
schedule.to_parquet(
    ruta_final_archivo,
    index=False,
    engine="pyarrow",
    coerce_timestamps="us",
    allow_truncated_timestamps=True
)



# COMMAND ----------

# MAGIC %md
# MAGIC # Creación de cada carrera

# COMMAND ----------

count = 0

for fila in schedule.itertuples():
    if count >= 3:
        break

    print(f"Ronda: {fila.RoundNumber}, País: {fila.Country}, Ubicación: {fila.Location}")
    race_number = f'{fila.RoundNumber:02d}'

    carpeta_race = DIRECTORIO_ACTUAL / "landing" / 'race_results' /f'season={YEAR}' / f"round={race_number}"
    carpeta_race.mkdir(parents=True, exist_ok=True)

    carpeta_qualifying = DIRECTORIO_ACTUAL / "landing" / 'qualifying_results' /f'season={YEAR}' / f"round={race_number}"
    carpeta_qualifying.mkdir(parents=True, exist_ok=True)

    carpeta_laps = DIRECTORIO_ACTUAL / "landing" / 'laps' /f'season={YEAR}' / f"round={race_number}"
    carpeta_laps.mkdir(parents=True, exist_ok=True)

    carpeta_weather = DIRECTORIO_ACTUAL / "landing" / 'weather' /f'season={YEAR}' / f"round={race_number}"
    carpeta_weather.mkdir(parents=True, exist_ok=True)

    try:
        session = fastf1.get_session(YEAR,fila.RoundNumber,"R")

        session.load(
            laps=True,
            telemetry=False,
            weather=True,
            messages=False
        )

        session.laps.to_parquet(
            carpeta_laps / 'laps_results.parquet',
            index=False,
            engine="pyarrow",
            coerce_timestamps="us",
            allow_truncated_timestamps=True
        )
        session.results.to_parquet(
            carpeta_race / 'race_results.parquet',
            index=False,
            engine="pyarrow",
            coerce_timestamps="us",
            allow_truncated_timestamps=True
        )
        session.weather_data.to_parquet(
            carpeta_weather / 'weather_data.parquet',
            index=False,
            engine="pyarrow",
            coerce_timestamps="us",
            allow_truncated_timestamps=True
        )

        print(f"✅ Carrera {race_number}, {fila.Country}")
    except Exception as e:
        print(f"❌ Carrera {race_number}: {e}")
        count += 1
        continue

    try:
        session = fastf1.get_session(YEAR,fila.RoundNumber,"Q")

        session.load(
            laps=True,
            telemetry=False,
            weather=False,
            messages=False
        )

        session.results.to_parquet(
            carpeta_qualifying / 'qualifying_results.parquet',
            index=False,
            engine="pyarrow",
            coerce_timestamps="us",
            allow_truncated_timestamps=True
        )

        print(f"✅ Qualifying {race_number}, {fila.Country}")
    except Exception as e:
        print(f"❌ Qualifyin {race_number}: {e}")
        count += 1
        continue

    count += 1
