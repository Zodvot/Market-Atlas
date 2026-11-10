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
