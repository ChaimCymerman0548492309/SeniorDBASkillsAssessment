#!/bin/bash
set -euo pipefail

echo "Setting up Senior DBA Assessment..."

PSQL_CMD="C:/Users/chaim/.dbclient/dependency/postgresql/psql.exe"
DB_URL="postgresql://neondb_owner:npg_gPkLUFD4uc0t@ep-mute-sky-adufxl3p-pooler.c-2.us-east-1.aws.neon.tech:5432/neondb?sslmode=require"

# פתרון: הרץ כל פקודה בנפרד עם echo
echo "Creating schema..."
echo "\i db/pg/schema.sql" | "$PSQL_CMD" "$DB_URL"

SCALE=${1:-small}
echo "Seeding with $SCALE dataset..."
echo "SET app.seed_scale='$SCALE'; \i db/pg/seed.sql" | "$PSQL_CMD" "$DB_URL"

echo "Creating indexes..."
echo "\i db/pg/indexes.sql" | "$PSQL_CMD" "$DB_URL"

echo "✅ Setup complete with $SCALE dataset"