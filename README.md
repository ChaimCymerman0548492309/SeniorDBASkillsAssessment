# Senior DBA Skills Assessment - PostgreSQL Solution

## 📋 Project Overview
A complete PostgreSQL database assessment for a Senior DBA position. Shows skills in database design, optimization, scripting, and automation.

## 🚀 Quick Setup

### Option A: One Command (Recommended)
```bash
# Run complete setup with small dataset
./setup.sh

# Or with large dataset for performance testing
./setup.sh large
```

### Option B: Step by Step
1. **Set up connection**: Update `.env` with your NeonDB credentials
2. **Create tables**: `psql "$DATABASE_URL" -f db/pg/schema.sql`
3. **Load test data**: `psql "$DATABASE_URL" -c "SET app.seed_scale='small';" -f db/pg/seed.sql`
4. **Add indexes**: `psql "$DATABASE_URL" -f db/pg/indexes.sql`

## 📊 What's Included

### Task 1: Database Design & Test Data ✅
- **schema.sql**: Creates customers and orders tables with proper constraints
- **seed.sql**: Loads realistic test data with two size options
  - Small: ~5,000 orders (default for testing)
  - Large: ~300,000 orders (for performance testing)
- **Data features**: 15% of customers are "heavy buyers" (realistic skew)

**Sample query output**: See `samples/sample_outputs.txt`

### Task 2: Performance Tuning ✅
- **indexes.sql**: Three key indexes with explanations:
  1. `idx_orders_customer_id` - Speeds up customer-order joins
  2. `idx_orders_order_date` - Optimizes date-based queries
  3. `idx_customers_email` - Improves customer lookups

**Performance results**:
- Monthly growth query: 68% faster after indexing
- Inactive customers query: 72% faster after indexing
- **Evidence**: See screenshots `befor_index_q_monthly_growth.png` and `q_monthly_growth.png`

### Task 3: Business Reports ✅
Three ready-to-use SQL reports:

1. **Top 3 customers (90-day rolling window)**: Best for continuous business tracking
2. **Monthly revenue growth**: Shows trends over 6 months with percentage change
3. **Inactive customers**: Finds customers with no orders in 6+ months

**Sample outputs in**: `samples/sample_outputs.txt`

### Task 4: Stored Procedure ✅
- **proc_customer_orders.sql**: Gets all orders for a customer
- **Features**:
  - Returns orders sorted by date (newest first)
  - Includes total spent by the customer
  - Validates customer exists (throws clear error if not)
- **Testing screenshots**: See `proc_error_and_proc_success.png`

### Task 5: Automation Scripting ✅
- **scripts/export_totals.sh**: Bash script that exports customer totals to CSV
- **Features**:
  - Reads database credentials from `.env` file
  - Creates timestamped CSV files
  - Handles errors properly
- **Sample export**: `totals_20251210_150122.csv`

### Task 6: Python Integration (Optional) ✅
- **python/combine_orders.py**: Python script for database operations
- **Can be extended** to connect to multiple database systems

## 📁 Files in This Project

```
SeniorDBASkillsAssessment/
├── db/pg/                          # Database scripts
│   ├── schema.sql                  # Table definitions
│   ├── seed.sql                    # Test data loader
│   ├── indexes.sql                 # Performance indexes
│   ├── q_total_per_customer.sql    # Basic report
│   ├── q_top3_customers.sql       # Top customers (90 days)
│   ├── q_monthly_growth.sql       # Revenue trends
│   ├── q_inactive_customers.sql   # Inactive customers
│   └── proc_customer_orders.sql   # Customer order lookup
├── scripts/
│   └── export_totals.sh           # CSV export script
├── python/
│   └── combine_orders.py          # Python database script
├── samples/                       # Example outputs
│   ├── sample_outputs.txt         # Query results
│   └── sample_totals.csv          # Exported data
├── .env                           # Database connection
├── .env.example                   # Connection template
├── docker-compose.yml             # Docker setup (optional)
├── setup.sh                       # One-command installer
├── SETUP_INSTRUCTIONS.md          # Detailed setup guide
├── PERFORMANCE_REPORT.md          # Index performance analysis
└── README.md                      # This file
```

## 🔧 Key Technical Details

### Database Design
- Uses PostgreSQL-specific features (BIGSERIAL, TIMESTAMPTZ)
- Proper foreign keys with ON DELETE RESTRICT
- Data validation with CHECK constraints
- Email uniqueness enforced

### Data Generation
- **Deterministic**: Same seed produces same data every time
- **Scalable**: SEED_SCALE parameter controls data volume
- **Realistic**: Some customers (15%) place many more orders than others

### Performance Optimization
- Indexes target actual query patterns from the assessment
- B-tree indexes chosen for range query support
- Performance validated with EXPLAIN ANALYZE
- Results documented with before/after screenshots

### Code Quality
- **Idempotent scripts**: Can be run multiple times safely
- **Transaction-safe**: Data loading uses BEGIN/COMMIT
- **Error handling**: Scripts check for common problems
- **Documented**: Each index includes justification

## 🧪 Testing the Solution

### Quick Test
```bash
# Run all main queries
cat samples/sample_outputs.txt

# Test the export script
bash scripts/export_totals.sh

# Test stored procedure
psql "$DATABASE_URL" -c "SELECT * FROM get_customer_orders(29) LIMIT 3;"
```

### Performance Testing
```bash
# Test with large dataset
./setup.sh large

# Check query performance
psql "$DATABASE_URL" -c "EXPLAIN ANALYZE SELECT * FROM q_total_per_customer;"
```

## 📈 Performance Results Summary

| Query | Before Indexes | After Indexes | Improvement |
|-------|---------------|---------------|-------------|
| Monthly Growth | 38ms | 12ms | 68% faster |
| Inactive Customers | 32ms | 9ms | 72% faster |
| Customer Totals | ~350ms | ~330ms | ~5-8% faster* |

*Small dataset shows modest gains; large dataset (300k orders) shows 45-60% improvement

## 🎯 Assessment Requirements Check

✅ **All mandatory tasks completed** (Tasks 1-5)
- Schema design with proper data types
- Test data with SEED_SCALE parameter
- Performance indexes with justification
- Advanced SQL queries with sample outputs
- Stored procedure with error handling
- Bash scripting for operations

✅ **Optional task available** (Task 6)
- Python script for database operations
- Can be extended for cross-platform use

✅ **Documentation provided**
- One-command setup instructions
- Performance analysis report
- Sample outputs for all queries
- Setup and usage instructions

✅ **Code quality standards met**
- Idempotent scripts (safe to rerun)
- Transaction-safe data loading
- Proper error handling
- Clear code organization

## 📞 Support & Questions

If you have questions about this submission:
1. Check `SETUP_INSTRUCTIONS.md` for detailed setup steps
2. Review `PERFORMANCE_REPORT.md` for index analysis
3. Examine sample outputs in the `samples/` directory
4. All scripts include comments explaining their purpose

---

**Submission Status**: Ready for review  
**Database**: PostgreSQL (NeonDB cloud)  
**Files Included**: All required deliverables plus optional enhancements  
**Test Coverage**: Small and large dataset scenarios validated