-- psql executes the generated command only if the database does not exist.
SELECT 'CREATE DATABASE market_atlas' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'market_atlas')\gexec
