# Market Atlas

A grocery comparison website built with HTML, CSS, JavaScript, Node.js, Express, and PostgreSQL.

Explore **40 groceries across 32 countries**, compare selected products between two countries, and display prices in **28 currencies**.

**Grocery prices are fictional sample data.** Exchange rates are a stored snapshot with a date displayed on the website. Rates do not update automatically.

## Features

- Country and grocery directories backed by PostgreSQL.
- Custom comparisons between two countries and selected groceries.
- Local currency and selected-currency display options.
- Signup, login, and logout with password hashing and cookie sessions.
- Usernames, gender, date of birth, and optional profile pictures.
- Account badges showing username, avatar, and account age.

## Project structure

```text
backend/
  database/       Database schema, migrations, and sample data
  server.js       Express server and API routes
  signup.js       Account creation and password hashing
  login.js        Credential verification
  profile.js      Profile validation and image processing
  .env.example    Example database settings
frontend/
  pages/          HTML pages
  css/            Page styles and shared account styles
  js/             Browser forms, account display, and price comparisons
  assets/flags/   Country flag images
```

Each page has its own stylesheet. Shared browser modules handle account display and currency conversion. Express serves the frontend and API from the same address.

## Local setup

Install Node.js 22 or newer and PostgreSQL. Development used PostgreSQL 18. The following commands use Windows PowerShell.

### Install dependencies

From the repository root, run these commands.

```powershell
cd backend
npm.cmd ci
Copy-Item .env.example .env
cd ..
```

Copy the example only when creating your configuration for the first time. Edit `backend/.env` with your PostgreSQL connection details.

```dotenv
PGHOST=localhost
PGPORT=5432
PGDATABASE=market_atlas
PGUSER=postgres
PGPASSWORD=your_local_database_password
```

Keep real credentials private. Git ignores `.env` and installed dependencies.

### Set up PostgreSQL

In pgAdmin, create a database named `market_atlas`. Open its Query Tool and execute each of these SQL files in order.

1. `backend/database/setup.sql`
2. `backend/database/users.sql`
3. `backend/database/profile.sql`
4. `backend/database/all-prices.sql`
5. `backend/database/currencies.sql`

The completed setup contains 32 countries, 6 categories, 40 groceries, 1,280 sample prices, and 28 currencies. Signup creates account records. The profile migration assigns older accounts a unique `member-ID` username.

The optional `setup.ps1` helper assumes PostgreSQL 18 at its default Windows installation path. It creates the database and runs only `setup.sql`; the other four files must still be applied. `create-database.sql` uses psql-specific syntax, so use pgAdmin's database creation interface when following the steps above.

### Start the application

```powershell
cd backend
npm.cmd start
```

Open [Market Atlas locally](http://127.0.0.1:3000/pages/index.html). Keep the terminal open while using the app. Press Ctrl+C to stop it.

Use the HTTP address so the pages can communicate with the backend. PostgreSQL must be running for account and catalog features to work.

## Database tables

| Table | Purpose |
| --- | --- |
| `categories` | Groups groceries |
| `groceries` | Product names, package sizes, and category references |
| `countries` | Country codes, regions, and currency references |
| `prices` | Grocery-country prices and sample-data flags |
| `currencies` | Currency names, units per USD, rate dates, and sources |
| `users` | Account details, password hashes, profile images, and creation dates |

Grocery prices are stored in USD. The browser converts them using the selected currency's rate. Countries sharing a currency reference the same currency record.

## API

| Method | Route | Purpose |
| --- | --- | --- |
| GET | `/api/health` | Check server and account-table connectivity |
| GET | `/api/countries` | Countries, currency information, and basket totals |
| GET | `/api/currencies` | Supported currencies and exchange rates |
| GET | `/api/groceries?country=LB` | Grocery prices for a country |
| POST | `/api/signup` | Create an account |
| POST | `/api/login` | Verify credentials and establish a session |
| GET | `/api/me` | Return the signed-in account |
| POST | `/api/logout` | End the session |

Signup accepts JSON fields `email`, `password`, `username`, `gender`, `dateOfBirth`, and optional `profilePicture`. Login accepts `email` and `password`. The frontend form handlers demonstrate these requests.

## Current scope

- This is a local learning project. Public hosting still requires deployment configuration.
- Sessions are held in memory and reset when the backend restarts. Public deployment needs persistent sessions, a stable private session secret, and appropriate HTTPS cookie settings.
- The server currently listens on `127.0.0.1:3000`. Hosting needs an appropriate listening address and provider-supplied port.
- Countries, groceries, and comparison pages query PostgreSQL. Home, product-detail, and basket pages retain fixed illustrative prices with currency conversion.
- AI integration and automatic grocery price collection are future features.
- There is no configured automated test suite. The default `npm test` command is a placeholder.

## Sources

Exchange-rate snapshots come from [ExchangeRate-API](https://www.exchangerate-api.com).

Country flag assets come from [FlagCDN](https://flagcdn.com).
