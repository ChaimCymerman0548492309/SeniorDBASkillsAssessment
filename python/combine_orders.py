#!/usr/bin/env python3
"""
combine_orders.py - Cross-Platform Database Integration Script
Task 6 (Optional): Demonstrates automation across PostgreSQL and SQL Server
"""

import csv
import psycopg2
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Tuple

def load_environment_variables() -> dict:
    """Load database connection parameters from .env file"""
    env_path = Path(__file__).parent.parent / '.env'
    env_vars = {}
    
    if env_path.exists():
        with open(env_path, 'r') as f:
            for line in f:
                line = line.strip()
                # Skip comments and empty lines
                if line and '=' in line and not line.startswith('#'):
                    key, value = line.split('=', 1)
                    env_vars[key.strip()] = value.strip()
    return env_vars

def connect_postgresql(env_vars: dict):
    """Establish connection to PostgreSQL database"""
    try:
        connection = psycopg2.connect(
            host=env_vars.get('PGHOST'),
            port=env_vars.get('PGPORT', '5432'),
            database=env_vars.get('PGDATABASE'),
            user=env_vars.get('PGUSER'),
            password=env_vars.get('PGPASSWORD'),
            sslmode='require'
        )
        return connection
    except Exception as e:
        print(f"PostgreSQL connection error: {e}")
        return None

def get_postgresql_orders(connection) -> Tuple[List[Tuple], List[str]]:
    """
    Fetch orders from PostgreSQL database using parameterized queries
    Returns: (rows, column_names)
    """
    if not connection:
        return [], []
    
    try:
        with connection.cursor() as cursor:
            # Parameterized query for safety (prevents SQL injection)
            # Get orders from the last 30 days as an example
            query = """
            SELECT id, customer_id, order_date, total_amount 
            FROM orders 
            WHERE order_date >= %s
            ORDER BY order_date DESC, id DESC
            """
            
            # Calculate date 30 days ago for the parameter
            thirty_days_ago = datetime.now().date() - timedelta(days=30)
            
            # Execute with parameter
            cursor.execute(query, (thirty_days_ago,))
            
            rows = cursor.fetchall()
            columns = [desc[0] for desc in cursor.description]
            
            return rows, columns
            
    except Exception as e:
        print(f"Error fetching PostgreSQL orders: {e}")
        return [], []

def get_sql_server_orders():
    """
    Placeholder function for SQL Server integration
    Demonstrates the pattern for connecting to a second database platform
    """
    print("SQL Server integration placeholder - would connect here in production")
    print("Implementation would use: import pyodbc")
    print("Connection string example: 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=...'")
    
    # Return empty data for demonstration
    return [], ['id', 'customer_id', 'order_date', 'total_amount']

def calculate_statistics(rows: List[Tuple]) -> dict:
    """Calculate summary statistics from order data"""
    if not rows:
        return {
            'total_orders': 0,
            'total_revenue': 0,
            'avg_order_value': 0
        }
    
    total_orders = len(rows)
    total_revenue = sum(row[3] for row in rows)  # total_amount is 4th column (index 3)
    avg_order_value = total_revenue / total_orders if total_orders > 0 else 0
    
    return {
        'total_orders': total_orders,
        'total_revenue': total_revenue,
        'avg_order_value': avg_order_value
    }

def write_combined_csv(postgres_rows: List[Tuple], 
                       sql_server_rows: List[Tuple], 
                       output_file: str):
    """Write combined orders from both databases to a CSV file"""
    
    all_rows = []
    
    # Add PostgreSQL orders with source identifier
    for row in postgres_rows:
        all_rows.append(['postgresql'] + list(row))
    
    # Add SQL Server orders with source identifier
    for row in sql_server_rows:
        all_rows.append(['sql_server'] + list(row))
    
    # Write to CSV
    with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        
        # Write header
        writer.writerow(['source_db', 'order_id', 'customer_id', 'order_date', 'total_amount'])
        
        # Write data rows
        writer.writerows(all_rows)
    
    return len(all_rows)

def main():
    """Main execution function"""
    print("=" * 60)
    print("Cross-Platform Database Integration Script")
    print("=" * 60)
    
    # Step 1: Load environment variables
    print("\n1. Loading database configuration...")
    env_vars = load_environment_variables()
    
    if not env_vars:
        print("Error: Could not load environment variables from .env file")
        return
    
    # Step 2: Connect to PostgreSQL
    print("2. Connecting to PostgreSQL database...")
    pg_conn = connect_postgresql(env_vars)
    
    if not pg_conn:
        print("Error: Failed to connect to PostgreSQL")
        return
    
    # Step 3: Fetch orders from PostgreSQL
    print("3. Fetching orders from PostgreSQL...")
    postgres_rows, postgres_columns = get_postgresql_orders(pg_conn)
    
    # Step 4: Demonstrate SQL Server pattern
    print("4. Setting up SQL Server connection pattern...")
    sql_server_rows, sql_server_columns = get_sql_server_orders()
    
    # Step 5: Calculate statistics
    print("5. Calculating statistics...")
    pg_stats = calculate_statistics(postgres_rows)
    
    # Step 6: Create combined output
    print("6. Creating combined output file...")
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    output_file = f'combined_orders_{timestamp}.csv'
    
    total_rows = write_combined_csv(postgres_rows, sql_server_rows, output_file)
    
    # Step 7: Close connections
    if pg_conn:
        pg_conn.close()
    
    # Step 8: Print summary report
    print("\n" + "=" * 60)
    print("SUMMARY REPORT")
    print("=" * 60)
    
    print(f"\nPostgreSQL Statistics:")
    print(f"  - Orders retrieved: {pg_stats['total_orders']:,}")
    print(f"  - Total revenue: ${pg_stats['total_revenue']:,.2f}")
    print(f"  - Average order value: ${pg_stats['avg_order_value']:,.2f}")
    
    print(f"\nSQL Server Statistics:")
    print(f"  - Orders retrieved: {len(sql_server_rows):,}")
    print("  (Note: SQL Server integration is demonstrated but not implemented)")
    
    print(f"\nCombined Output:")
    print(f"  - Total rows in combined file: {total_rows:,}")
    print(f"  - Output file: {output_file}")
    
    print(f"\nFile Structure:")
    print(f"  - Each row includes source database identifier")
    print(f"  - Columns: source_db, order_id, customer_id, order_date, total_amount")
    
    print("\n" + "=" * 60)
    print("Script completed successfully!")
    print("=" * 60)

if __name__ == "__main__":
    main()