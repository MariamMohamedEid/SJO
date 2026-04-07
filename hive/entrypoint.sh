#!/bin/bash
set -e

export JAVA_OPTS="$SERVICE_OPTS"

SCHEMA_TOOL="/opt/hive/bin/schematool"
DB_TYPE="postgres"

echo "Checking if Hive Metastore schema is already initialized..."

$SCHEMA_TOOL -dbType $DB_TYPE \
  -url "jdbc:postgresql://metastore_db:5432/metastore" \
  -driver "org.postgresql.Driver" \
  -userName "hive" \
  -passWord "hive" \
  -info > /dev/null 2>&1 \
  && echo "Schema already exists, skipping init." \
  || (echo "Schema not found, initializing..." && \
      $SCHEMA_TOOL -dbType $DB_TYPE \
        -url "jdbc:postgresql://metastore_db:5432/metastore" \
        -driver "org.postgresql.Driver" \
        -userName "hive" \
        -passWord "hive" \
        -initSchema)

echo "Starting Hive Metastore..."
exec /opt/hive/bin/hive --service metastore