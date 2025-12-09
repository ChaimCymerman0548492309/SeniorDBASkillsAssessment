#!/usr/bin/env python3
import os
import csv
import psycopg2
from datetime import datetime
from pathlib import Path

# טעינת משתני סביבה
env_path = Path(__file__).parent.parent / '.env'
env_vars = {}
if env_path.exists():
    with open(env_path, 'r') as f:
        for line in f:
            line = line.strip()
            if line and '=' in line and not line.startswith('#'):
                key, value = line.split('=', 1)
                env_vars[key.strip()] = value.strip()

# חיבור ל-DB
conn = psycopg2.connect(
    host=env_vars.get('PGHOST'),
    port=env_vars.get('PGPORT', '5432'),
    database=env_vars.get('PGDATABASE'),
    user=env_vars.get('PGUSER'),
    password=env_vars.get('PGPASSWORD'),
    sslmode='require'
)

# יצירת שם קובץ
timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
output_file = f'totals_{timestamp}.csv'

# שאילתה
query = """
SELECT c.id, c.name, c.email,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name, c.email
ORDER BY total_spent DESC
"""

# הרצה וכתיבה ל-CSV
with conn.cursor() as cur:
    cur.execute(query)
    rows = cur.fetchall()
    columns = [desc[0] for desc in cur.description]
    
    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(columns)
        writer.writerows(rows)

conn.close()
print(f"Exported {len(rows)} rows to {output_file}")