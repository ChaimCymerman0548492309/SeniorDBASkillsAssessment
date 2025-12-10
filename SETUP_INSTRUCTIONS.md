# Senior DBA Assessment - Setup Guide

## Quick Start
1. Configure `.env` with database credentials
2. Run `./setup.sh` for small dataset
3. Test with `./scripts/export_totals.sh`

## Manual Setup
- schema.sql: Creates tables and constraints  
- seed.sql: Loads deterministic test data
- indexes.sql: Creates performance indexes
- proc_customer_orders.sql: Creates stored procedure

## Validation
- Verify table counts
- Run sample queries
- Check performance with EXPLAIN ANALYZE