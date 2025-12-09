#!/usr/bin/env bash
set -euo pipefail

# טעינת משתני סביבה
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

# טעינת .env
if [[ -f "$ENV_FILE" ]]; then
    # טעינת משתנים מהקובץ
    while IFS='=' read -r key value; do
        # התעלם משורות הערה ושורות ריקות
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z $key ]] && continue
        
        # הסר ציטוטים
        value="${value%%#*}"  # הסר הערות בסוף שורה
        value="${value%"${value##*[![:space:]]}"}"  # trim trailing spaces
        value="${value#\"}"  # הסר " מהתחלה
        value="${value%\"}"  # הסר " מסוף
        
        export "$key=$value"
    done < "$ENV_FILE"
else
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

# נתיב מלא ל-psql
PSQL_CMD="C:/Users/chaim/.dbclient/dependency/postgresql/psql.exe"

# יצירת שם קובץ
OUTPUT_FILE="totals_$(date +%Y%m%d_%H%M%S).csv"

# בניית חיבור
CONNECTION_STRING="postgresql://${PGUSER}:${PGPASSWORD}@${PGHOST}:${PGPORT}/${PGDATABASE}?sslmode=${PGSSLMODE}"

echo "📊 Exporting customer totals to: $OUTPUT_FILE"
echo "🔗 Connection: $CONNECTION_STRING"

# הרצת השאילתה ישירות
QUERY="SELECT c.id, c.name, c.email,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name, c.email
ORDER BY total_spent DESC"

# הרצה עם psql וייצוא ל-CSV
echo "$QUERY" | "$PSQL_CMD" "$CONNECTION_STRING" \
    --csv \
    --quiet \
    --no-align \
    --tuples-only \
    --field-separator=',' \
    > "$OUTPUT_FILE"

# הוספת headers
echo "id,name,email,total_spent" > temp.csv
cat "$OUTPUT_FILE" >> temp.csv
mv temp.csv "$OUTPUT_FILE"

# בדיקה אם הצליח
if [[ $? -eq 0 ]] && [[ -f "$OUTPUT_FILE" ]] && [[ -s "$OUTPUT_FILE" ]]; then
    ROW_COUNT=$(($(wc -l < "$OUTPUT_FILE") - 1))
    echo "✅ Success! Exported $ROW_COUNT rows"
    echo ""
    echo "📋 First 3 rows:"
    echo "----------------"
    head -n 4 "$OUTPUT_FILE" | column -t -s ','
else
    echo "❌ Export failed or file is empty"
    exit 1
fi