# Senior DBA Skills Assessment - PostgreSQL Solution

## 📋 Project Overview
A comprehensive PostgreSQL database assessment demonstrating senior DBA skills including schema design, query optimization, indexing, stored procedures, and automation scripting.

## 🚀 Quick Setup

### Prerequisites
- PostgreSQL client or GUI tool
- Python 3.8+ (for optional scripts)

### Installation
```bash
# Initialize database
psql "postgresql://neondb_owner:npg_gPkLUFD4uc0t@ep-mute-sky-adufxl3p-pooler.c-2.us-east-1.aws.neon.tech:5432/neondb?sslmode=require" -f db/pg/schema.sql

# Seed with data
psql "$DATABASE_URL" -c "SET app.seed_scale='small';" -f db/pg/seed.sql
```

## 📊 Task 1: Schema & Seeding

### Schema Creation
![Database Schema](image.png)

### Sample Data Generated
- Customers: 300 records
- Orders: ~5,000 transactions
- Data skewed: 15% of customers generate 50% of revenue

### Query Results: Total per Customer
![Customer Totals Query](q_total_per_customer.png)

**Query:**
```sql
SELECT c.id, c.name, c.email,
       COALESCE(SUM(o.total_amount),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id
ORDER BY total_spent DESC;
```

## 📈 Task 2: Query Optimization & Indexing

### Performance Analysis

**Before Indexing - Monthly Growth Query:**
![Monthly Growth Before Index](befor_index_q_monthly_growth.png)

**After Indexing - Monthly Growth Query:**
![Monthly Growth After Index](q_monthly_growth.png)

**Indexes Implemented:**
```sql
-- 1. Customer ID index for JOIN operations
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- 2. Order date index for time-based queries  
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- 3. Email index for customer lookups
CREATE INDEX idx_customers_email ON customers(email);
```

**Performance Improvement:**
- Monthly growth query: 68% faster with index
- Inactive customers query: 72% faster

## 🎯 Task 3: Advanced SQL Queries

### Top 3 Customers (Last 90 Days)
![Top 3 Customers](q_top3_customers.png)

**Query Strategy:** Used rolling 90-day window for continuous business analysis.

### Inactive Customers Analysis
**Before Indexing:**
![Inactive Customers Before Index](befor_index_q_inactive_customers.png)

**After Indexing:**
![Inactive Customers After Index](q_inactive_customers.png)

**Query:**
```sql
SELECT c.id, c.name, c.email
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.id
    AND o.order_date >= current_date - INTERVAL '6 months'
WHERE o.id IS NULL;
```

## 📁 Project Structure
```
SeniorDBASkillsAssessment/
├── db/pg/                          # All SQL scripts
├── scripts/                        # Bash automation
├── python/                         # Python scripts
├── .env                           # Configuration
└── screenshots/                   # Query results
```

## 🔧 Key Features Implemented

### ✅ Completed Tasks:
1. **Schema Design** - Normalized with constraints
2. **Data Seeding** - Deterministic with SEED_SCALE parameter
3. **Query Optimization** - Indexes with performance evidence
4. **Advanced Queries** - Time-series and aggregation
5. **Stored Procedures** - With error handling
6. **Automation Scripts** - Bash and Python

### 📊 Performance Metrics:
- Query response time improved by 45-72%
- Data generation: 5k orders (small) / 300k orders (large)
- All scripts idempotent and rerunnable

## 🛠️ Usage

### Export Customer Data
```bash
# Run export script
cd scripts
./export_totals.sh
# Output: totals_YYYYMMDD_HHMMSS.csv
```

### Run All Queries
```bash
# Initialize
psql "$DATABASE_URL" -f db/pg/schema.sql
psql "$DATABASE_URL" -f db/pg/seed.sql

# Run queries
psql "$DATABASE_URL" -f db/pg/q_total_per_customer.sql
psql "$DATABASE_URL" -f db/pg/q_top3_customers.sql
psql "$DATABASE_URL" -f db/pg/q_monthly_growth.sql
psql "$DATABASE_URL" -f db/pg/q_inactive_customers.sql
```

## 📝 Notes

### Design Decisions:
1. Used 90-day rolling window instead of calendar months for business continuity
2. Implemented single-column indexes for query flexibility
3. Chose B-tree indexes for range query support
4. Added transaction wrapping for data consistency

### Validation:
- All foreign key constraints validated
- Data distribution matches expected skew
- Queries return deterministic results
- Performance improvements documented

---

**Assessment Complete**: All tasks implemented with production-ready code, performance optimization, and comprehensive documentation.