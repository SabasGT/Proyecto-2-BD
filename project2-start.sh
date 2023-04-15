#!/bin/bash

# Obtener la lista de Ciudades de USA

FILE1=./us_cities_full.csv
if ! test -f "$FILE1"; then
    wget -O us_cities_full.csv "https://data.opendatasoft.com/api/explore/v2.1/catalog/datasets/georef-united-states-of-america-zc-point@public/exports/csv?lang=en&timezone=America%2FSanto_Domingo&use_labels=true&delimiter=%3B"
fi

# Procesar la lista para solo dejar las columnas que se requieren

FILE2=./us_cities.csv
if ! test -f "$FILE2"; then
    python3 procesar_cities.py
fi

psql -d USGroceriesSabasPedro -f "db-drop-tables_dump.sql"
psql -d USGroceriesSabasPedro -f "db-drop-tables.sql"
psql -d USGroceriesSabasPedro -f "db-creation-psql.sql"
psql -d USGroceriesSabasPedro -c "\copy city_dump FROM './us_cities.csv' WITH DELIMITER ',' CSV HEADER;"
#psql -d USGroceriesSabasPedro -f "db-fill-psql.sql"