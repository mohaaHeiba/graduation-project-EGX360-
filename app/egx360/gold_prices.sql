    CREATE TABLE IF NOT EXISTS gold_prices (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    price_24k NUMERIC(10, 2),
    price_22k NUMERIC(10, 2),
    price_21k NUMERIC(10, 2),
    price_18k NUMERIC(10, 2)
);
