# Databricks notebook source

# MAGIC %md
# MAGIC # Imports


# COMMAND ----------
import matplotlib.pyplot as plt
from pathlib import Path
import numpy as np
import pandas as pd
import fastf1

# MAGIC %md
# MAGIC # Variables
# COMMAND ----------

# Variable mas importante, aqui se debe de especificar que año se necesita
YEAR = 2025
DIRECTORIO_ACTUAL = Path(__file__).resolve().parent

carpeta_destino = DIRECTORIO_ACTUAL / "landing" / str(YEAR) / "schedule"

print(DIRECTORIO_ACTUAL)

schedule = fastf1.get_event_schedule(YEAR)
# COMMAND ----------

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
schedule.to_parquet(ruta_final_archivo, index=False, engine='fastparquet')

count = 0

for fila in schedule.itertuples():
    if count >= 3:
        break

    print(f"Ronda: {fila.RoundNumber}, País: {fila.Country}, Ubicación: {fila.Location}")
    race_number = f'{fila.RoundNumber:02d}'

    # carpeta_race = Path(f"C:/coursera/formula1/landing/{YEAR}/race_{race_number:02d}")
    carpeta_race = DIRECTORIO_ACTUAL / "landing" / str(YEAR) / f"race_{race_number}"
    carpeta_race.mkdir(parents=True, exist_ok=True)

    try:
        session = fastf1.get_session(YEAR,fila.RoundNumber,"R")

        session.load(
            laps=True,
            telemetry=False,
            weather=True,
            messages=False
        )

        session.laps.to_parquet(
            carpeta_race / 'laps_results.parquet',
            index=False,
            engine='fastparquet'
        )
        session.results.to_parquet(
            carpeta_race / 'race_results.parquet',
            index=False,
            engine='fastparquet'
        )
        session.weather_data.to_parquet(
            carpeta_race / 'weather_data.parquet',
            index=False,
            engine='fastparquet'
        )

        print(f"✅ Carrera {race_number}, {fila.Country}")
    except Exception as e:
        print(f"❌ Carrera {race_number}: {e}")
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
            carpeta_race / 'qualifying_results.parquet',
            index=False,
            engine='fastparquet'
        )

        print(f"✅ Qualifying {race_number}, {fila.Country}")
    except Exception as e:
        print(f"❌ Qualifyin {race_number}: {e}")
        continue

    count += 1

