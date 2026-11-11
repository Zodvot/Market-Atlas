-- Run in the market_atlas database. All seed prices are fictional demo data.
-- The transaction ensures a failure cannot leave a partially seeded database.
BEGIN;
CREATE TABLE IF NOT EXISTS countries (
    code CHAR(2) PRIMARY KEY CHECK (code ~ '^[A-Z]{2}$'),
    name TEXT NOT NULL UNIQUE,
    region TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS groceries (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(id),
    package_size TEXT NOT NULL,
    UNIQUE (name, package_size)
);
-- One current demo price per grocery, country, and currency.
-- Real store observations and price history can be modeled separately later.
CREATE TABLE IF NOT EXISTS prices (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    grocery_id INTEGER NOT NULL REFERENCES groceries(id),
    country_code CHAR(2) NOT NULL REFERENCES countries(code),
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    currency CHAR(3) NOT NULL DEFAULT 'USD' CHECK (currency ~ '^[A-Z]{3}$'),
    is_sample BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (grocery_id, country_code, currency)
);
CREATE INDEX IF NOT EXISTS prices_country_code_idx ON prices(country_code);
CREATE INDEX IF NOT EXISTS groceries_category_id_idx ON groceries(category_id);
INSERT INTO countries (code, name, region) VALUES ('LB', 'Lebanon', 'Middle East & North Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('JO', 'Jordan', 'Middle East & North Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('AE', 'United Arab Emirates', 'Middle East & North Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('SA', 'Saudi Arabia', 'Middle East & North Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('QA', 'Qatar', 'Middle East & North Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('KW', 'Kuwait', 'Middle East & North Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('EG', 'Egypt', 'Middle East & North Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('MA', 'Morocco', 'Middle East & North Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('FR', 'France', 'Europe') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('GB', 'United Kingdom', 'Europe') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('DE', 'Germany', 'Europe') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('IT', 'Italy', 'Europe') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('ES', 'Spain', 'Europe') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('NL', 'Netherlands', 'Europe') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('SE', 'Sweden', 'Europe') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('TR', 'Türkiye', 'Europe') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('IN', 'India', 'Asia') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('PK', 'Pakistan', 'Asia') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('CN', 'China', 'Asia') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('JP', 'Japan', 'Asia') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('KR', 'South Korea', 'Asia') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('TH', 'Thailand', 'Asia') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('ID', 'Indonesia', 'Asia') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('SG', 'Singapore', 'Asia') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('US', 'United States', 'Americas') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('CA', 'Canada', 'Americas') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('MX', 'Mexico', 'Americas') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('BR', 'Brazil', 'Americas') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('ZA', 'South Africa', 'Sub-Saharan Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('KE', 'Kenya', 'Sub-Saharan Africa') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('AU', 'Australia', 'Oceania') ON CONFLICT DO NOTHING;
INSERT INTO countries (code, name, region) VALUES ('NZ', 'New Zealand', 'Oceania') ON CONFLICT DO NOTHING;
INSERT INTO categories (name) VALUES ('Fruit & vegetables') ON CONFLICT DO NOTHING;
INSERT INTO categories (name) VALUES ('Dairy & eggs') ON CONFLICT DO NOTHING;
INSERT INTO categories (name) VALUES ('Bakery & grains') ON CONFLICT DO NOTHING;
INSERT INTO categories (name) VALUES ('Meat & seafood') ON CONFLICT DO NOTHING;
INSERT INTO categories (name) VALUES ('Pantry essentials') ON CONFLICT DO NOTHING;
INSERT INTO categories (name) VALUES ('Drinks') ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Avocados', id, '2 pieces' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Bananas', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Tomatoes', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Apples', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Oranges', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Lemons', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Potatoes', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Onions', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Carrots', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Broccoli', id, '500 grams' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Cucumbers', id, '1 kilogram' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Lettuce', id, '1 head' FROM categories WHERE name = 'Fruit & vegetables' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Whole milk', id, '1 liter' FROM categories WHERE name = 'Dairy & eggs' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Free-range eggs', id, '12 eggs' FROM categories WHERE name = 'Dairy & eggs' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Plain yogurt', id, '500 grams' FROM categories WHERE name = 'Dairy & eggs' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Butter', id, '250 grams' FROM categories WHERE name = 'Dairy & eggs' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Cheddar cheese', id, '200 grams' FROM categories WHERE name = 'Dairy & eggs' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Labneh', id, '400 grams' FROM categories WHERE name = 'Dairy & eggs' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Sourdough bread', id, '500 grams' FROM categories WHERE name = 'Bakery & grains' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'White rice', id, '1 kilogram' FROM categories WHERE name = 'Bakery & grains' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Pita bread', id, '6 pieces' FROM categories WHERE name = 'Bakery & grains' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Rolled oats', id, '500 grams' FROM categories WHERE name = 'Bakery & grains' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Pasta', id, '500 grams' FROM categories WHERE name = 'Bakery & grains' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'All-purpose flour', id, '1 kilogram' FROM categories WHERE name = 'Bakery & grains' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Chicken breast', id, '1 kilogram' FROM categories WHERE name = 'Meat & seafood' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Ground beef', id, '500 grams' FROM categories WHERE name = 'Meat & seafood' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Salmon fillet', id, '500 grams' FROM categories WHERE name = 'Meat & seafood' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Frozen shrimp', id, '500 grams' FROM categories WHERE name = 'Meat & seafood' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Dried lentils', id, '500 grams' FROM categories WHERE name = 'Pantry essentials' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Canned chickpeas', id, '400 grams' FROM categories WHERE name = 'Pantry essentials' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Olive oil', id, '500 milliliters' FROM categories WHERE name = 'Pantry essentials' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Sunflower oil', id, '1 liter' FROM categories WHERE name = 'Pantry essentials' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Salt', id, '750 grams' FROM categories WHERE name = 'Pantry essentials' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'White sugar', id, '1 kilogram' FROM categories WHERE name = 'Pantry essentials' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Honey', id, '250 grams' FROM categories WHERE name = 'Pantry essentials' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Peanut butter', id, '350 grams' FROM categories WHERE name = 'Pantry essentials' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Ground coffee', id, '250 grams' FROM categories WHERE name = 'Drinks' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Black tea', id, '25 bags' FROM categories WHERE name = 'Drinks' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Bottled water', id, '1.5 liters' FROM categories WHERE name = 'Drinks' ON CONFLICT DO NOTHING;
INSERT INTO groceries (name, category_id, package_size) SELECT 'Orange juice', id, '1 liter' FROM categories WHERE name = 'Drinks' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'LB', 2.40 FROM groceries WHERE name = 'Avocados' AND package_size = '2 pieces' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'LB', 1.25 FROM groceries WHERE name = 'Whole milk' AND package_size = '1 liter' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'LB', 1.10 FROM groceries WHERE name = 'Bananas' AND package_size = '1 kilogram' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'LB', 3.60 FROM groceries WHERE name = 'Free-range eggs' AND package_size = '12 eggs' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'FR', 2.90 FROM groceries WHERE name = 'Avocados' AND package_size = '2 pieces' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'FR', 1.50 FROM groceries WHERE name = 'Whole milk' AND package_size = '1 liter' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'FR', 1.80 FROM groceries WHERE name = 'Bananas' AND package_size = '1 kilogram' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'FR', 4.20 FROM groceries WHERE name = 'Free-range eggs' AND package_size = '12 eggs' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'US', 3.20 FROM groceries WHERE name = 'Avocados' AND package_size = '2 pieces' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'US', 1.10 FROM groceries WHERE name = 'Whole milk' AND package_size = '1 liter' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'US', 1.40 FROM groceries WHERE name = 'Bananas' AND package_size = '1 kilogram' ON CONFLICT DO NOTHING;
INSERT INTO prices (grocery_id, country_code, amount) SELECT id, 'US', 4.50 FROM groceries WHERE name = 'Free-range eggs' AND package_size = '12 eggs' ON CONFLICT DO NOTHING;
COMMIT;

SELECT 'countries' AS table_name, COUNT(*) FROM countries
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'groceries', COUNT(*) FROM groceries
UNION ALL SELECT 'prices', COUNT(*) FROM prices;


CREATE TABLE IF NOT EXISTS users (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT NOT NULL UNIQUE CHECK (email = lower(trim(email))),
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


BEGIN;
ALTER TABLE users ADD COLUMN IF NOT EXISTS username TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS gender TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS date_of_birth DATE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_picture TEXT;
-- Reserved names give older accounts a unique username without changing login.
UPDATE users SET username = 'member-' || id WHERE username IS NULL;
ALTER TABLE users ALTER COLUMN username SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS users_username_unique ON users (lower(username));
COMMIT;


-- Fictional USD prices for development, not estimates of national prices.
-- Base amounts come from the existing grocery cards. Deterministic variation
-- adds test variety without making claims about any country's cost of living.
-- Existing prices are preserved. Safe to rerun.
BEGIN;
WITH base_prices (name, package_size, amount) AS (
    VALUES
    ('Avocados', '2 pieces', 2.40::numeric),
    ('Bananas', '1 kilogram', 1.10::numeric),
    ('Tomatoes', '1 kilogram', 1.65::numeric),
    ('Apples', '1 kilogram', 2.20::numeric),
    ('Oranges', '1 kilogram', 1.80::numeric),
    ('Lemons', '1 kilogram', 2.00::numeric),
    ('Potatoes', '1 kilogram', 1.20::numeric),
    ('Onions', '1 kilogram', 1.00::numeric),
    ('Carrots', '1 kilogram', 1.30::numeric),
    ('Broccoli', '500 grams', 1.70::numeric),
    ('Cucumbers', '1 kilogram', 1.40::numeric),
    ('Lettuce', '1 head', 0.90::numeric),
    ('Whole milk', '1 liter', 1.25::numeric),
    ('Free-range eggs', '12 eggs', 3.60::numeric),
    ('Plain yogurt', '500 grams', 2.10::numeric),
    ('Butter', '250 grams', 2.80::numeric),
    ('Cheddar cheese', '200 grams', 3.20::numeric),
    ('Labneh', '400 grams', 2.60::numeric),
    ('Sourdough bread', '500 grams', 2.80::numeric),
    ('White rice', '1 kilogram', 1.90::numeric),
    ('Pita bread', '6 pieces', 1.20::numeric),
    ('Rolled oats', '500 grams', 1.80::numeric),
    ('Pasta', '500 grams', 1.30::numeric),
    ('All-purpose flour', '1 kilogram', 1.10::numeric),
    ('Chicken breast', '1 kilogram', 6.50::numeric),
    ('Ground beef', '500 grams', 5.00::numeric),
    ('Salmon fillet', '500 grams', 8.50::numeric),
    ('Frozen shrimp', '500 grams', 7.20::numeric),
    ('Dried lentils', '500 grams', 1.40::numeric),
    ('Canned chickpeas', '400 grams', 0.90::numeric),
    ('Olive oil', '500 milliliters', 5.50::numeric),
    ('Sunflower oil', '1 liter', 2.70::numeric),
    ('Salt', '750 grams', 0.70::numeric),
    ('White sugar', '1 kilogram', 1.20::numeric),
    ('Honey', '250 grams', 3.80::numeric),
    ('Peanut butter', '350 grams', 2.90::numeric),
    ('Ground coffee', '250 grams', 4.20::numeric),
    ('Black tea', '25 bags', 1.60::numeric),
    ('Bottled water', '1.5 liters', 0.60::numeric),
    ('Orange juice', '1 liter', 2.30::numeric)
)
INSERT INTO prices (grocery_id, country_code, amount, currency, is_sample)
SELECT g.id, c.code,
       round(b.amount * (0.80 + (ascii(substr(c.code, 1, 1)) + ascii(substr(c.code, 2, 1)) + length(g.name)) % 41 / 100.0), 2),
       'USD', TRUE
FROM groceries g
JOIN base_prices b ON b.name = g.name AND b.package_size = g.package_size
CROSS JOIN countries c
ON CONFLICT (grocery_id, country_code, currency) DO NOTHING;
-- Fail atomically if any grocery/country combination is missing a USD price.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM groceries g CROSS JOIN countries c
        WHERE NOT EXISTS (
            SELECT 1 FROM prices p
            WHERE p.grocery_id = g.id AND p.country_code = c.code AND p.currency = 'USD'
        )
    ) THEN
        RAISE EXCEPTION 'Price coverage is incomplete';
    END IF;
END $$;
COMMIT;


BEGIN;
CREATE TABLE IF NOT EXISTS currencies (code CHAR(3) PRIMARY KEY, name TEXT NOT NULL, units_per_usd NUMERIC(20,8) NOT NULL CHECK (units_per_usd > 0), rate_date TIMESTAMPTZ NOT NULL, source TEXT NOT NULL);
ALTER TABLE countries ADD COLUMN IF NOT EXISTS currency_code CHAR(3) REFERENCES currencies(code);
INSERT INTO currencies VALUES ('LBP', 'Lebanese Pound', 89500, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('JOD', 'Jordanian Dinar', 0.709, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('AED', 'United Arab Emirates Dirham', 3.6725, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('SAR', 'Saudi Riyal', 3.75, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('QAR', 'Qatari Riyal', 3.64, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('KWD', 'Kuwaiti Dinar', 0.310638, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('EGP', 'Egyptian Pound', 54.071553, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('MAD', 'Moroccan Dirham', 9.765084, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('EUR', 'Euro', 0.892449, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('GBP', 'British Pound', 0.744696, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('SEK', 'Swedish Krona', 9.811535, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('TRY', 'Turkish Lira', 50.202087, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('INR', 'Indian Rupee', 93.929192, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('PKR', 'Pakistani Rupee', 276.541346, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('CNY', 'Chinese Yuan', 6.686583, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('JPY', 'Japanese Yen', 158.023471, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('KRW', 'South Korean Won', 1344.786283, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('THB', 'Thai Baht', 33.475647, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('IDR', 'Indonesian Rupiah', 18083.724904, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('SGD', 'Singapore Dollar', 1.279506, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('USD', 'US Dollar', 1, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('CAD', 'Canadian Dollar', 1.411275, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('MXN', 'Mexican Peso', 18.57202, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('BRL', 'Brazilian Real', 5.512234, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('ZAR', 'South African Rand', 16.406164, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('KES', 'Kenyan Shilling', 129.931184, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('AUD', 'Australian Dollar', 1.448015, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
INSERT INTO currencies VALUES ('NZD', 'New Zealand Dollar', 1.777472, to_timestamp(1794268951), 'https://www.exchangerate-api.com') ON CONFLICT (code) DO UPDATE SET units_per_usd=EXCLUDED.units_per_usd, rate_date=EXCLUDED.rate_date, source=EXCLUDED.source;
UPDATE countries SET currency_code='LBP' WHERE code='LB';
UPDATE countries SET currency_code='JOD' WHERE code='JO';
UPDATE countries SET currency_code='AED' WHERE code='AE';
UPDATE countries SET currency_code='SAR' WHERE code='SA';
UPDATE countries SET currency_code='QAR' WHERE code='QA';
UPDATE countries SET currency_code='KWD' WHERE code='KW';
UPDATE countries SET currency_code='EGP' WHERE code='EG';
UPDATE countries SET currency_code='MAD' WHERE code='MA';
UPDATE countries SET currency_code='EUR' WHERE code='FR';
UPDATE countries SET currency_code='GBP' WHERE code='GB';
UPDATE countries SET currency_code='EUR' WHERE code='DE';
UPDATE countries SET currency_code='EUR' WHERE code='IT';
UPDATE countries SET currency_code='EUR' WHERE code='ES';
UPDATE countries SET currency_code='EUR' WHERE code='NL';
UPDATE countries SET currency_code='SEK' WHERE code='SE';
UPDATE countries SET currency_code='TRY' WHERE code='TR';
UPDATE countries SET currency_code='INR' WHERE code='IN';
UPDATE countries SET currency_code='PKR' WHERE code='PK';
UPDATE countries SET currency_code='CNY' WHERE code='CN';
UPDATE countries SET currency_code='JPY' WHERE code='JP';
UPDATE countries SET currency_code='KRW' WHERE code='KR';
UPDATE countries SET currency_code='THB' WHERE code='TH';
UPDATE countries SET currency_code='IDR' WHERE code='ID';
UPDATE countries SET currency_code='SGD' WHERE code='SG';
UPDATE countries SET currency_code='USD' WHERE code='US';
UPDATE countries SET currency_code='CAD' WHERE code='CA';
UPDATE countries SET currency_code='MXN' WHERE code='MX';
UPDATE countries SET currency_code='BRL' WHERE code='BR';
UPDATE countries SET currency_code='ZAR' WHERE code='ZA';
UPDATE countries SET currency_code='KES' WHERE code='KE';
UPDATE countries SET currency_code='AUD' WHERE code='AU';
UPDATE countries SET currency_code='NZD' WHERE code='NZ';
ALTER TABLE countries ALTER COLUMN currency_code SET NOT NULL;
COMMIT;
