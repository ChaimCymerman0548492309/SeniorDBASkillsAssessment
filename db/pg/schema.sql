-- Active: 1765301442865@@ep-mute-sky-adufxl3p-pooler.c-2.us-east-1.aws.neon.tech@5432@neondb@public
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id          BIGSERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT UNIQUE NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE orders (
    id            BIGSERIAL PRIMARY KEY,
    customer_id   BIGINT NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    order_date    DATE NOT NULL,
    total_amount  NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0)
);
