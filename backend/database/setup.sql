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
