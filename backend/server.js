const express = require('express');
const session = require('express-session');
const { rateLimit } = require('express-rate-limit');
const { Pool } = require('pg');
const { randomBytes } = require('node:crypto');
const path = require('node:path');
const { signup } = require('./signup');
const { login } = require('./login');

// Load local database settings if you have created backend/.env.
const envPath = path.join(__dirname, '.env');
if (require('node:fs').existsSync(envPath)) process.loadEnvFile(envPath);
const database = new Pool({
    host: process.env.PGHOST || 'localhost',
    port: Number(process.env.PGPORT || 5432),
    database: process.env.PGDATABASE || 'market_atlas',
    user: process.env.PGUSER || 'postgres',
    password: process.env.PGPASSWORD,
    connectionTimeoutMillis: 3000,
});
database.on('error', () => console.error('The database connection was interrupted.'));
const app = express();
app.disable('x-powered-by');
app.use(express.json({ limit: '3mb' }));
// This local learning server keeps sessions in memory. Restarting logs users out.
app.use(session({
    secret: randomBytes(32).toString('hex'),
    resave: false,
    saveUninitialized: false,
    cookie: { httpOnly: true, sameSite: 'strict', maxAge: 3600000 },
}));
app.get('/api/health', async (request, response) => {
    try {
        await database.query('SELECT 1 FROM users LIMIT 1');
        response.json({ server: 'running', database: 'ready' });
    } catch {
        response.status(503).json({ server: 'running', database: 'unavailable', message: 'Check backend/.env and create the users table.' });
    }
});
const authenticationLimit = rateLimit({ windowMs: 60000, limit: 10 });
app.use('/api/signup', authenticationLimit);
app.use('/api/login', authenticationLimit);
const inputErrors = new Set([
    'Email and password must be text.', 'Enter a valid email address.',
    'Use a password between 12 and 128 characters.',
    'This email or username is already registered.', 'Invalid email or password.',
]);
app.post('/api/signup', async (request, response, next) => {
    try {
        const user = await signup(database, request.body);
        response.status(201).json({ user });
    } catch (error) { next(error); }
});
app.post('/api/login', async (request, response, next) => {
    try {
        const user = await login(database, request.body);
        request.session.regenerate((error) => {
            if (error) return next(error);
            request.session.user = user;
            request.session.save((error) => {
                if (error) return next(error);
                response.json({ user });
            });
        });
    } catch (error) { next(error); }
});
app.get('/api/me', async (request, response, next) => {
    response.set('Cache-Control', 'no-store');
    if (!request.session.user) return response.status(401).json({ message: 'Please log in.' });
    try {
        const result = await database.query(
            'SELECT id, email, username, profile_picture, created_at FROM users WHERE id = $1',
            [request.session.user.id]
        );
        if (!result.rows[0]) return response.status(401).json({ message: 'Please log in.' });
        response.json({ user: result.rows[0] });
    } catch (error) { next(error); }
});
app.post('/api/logout', (request, response, next) => {
    request.session.destroy((error) => {
        if (error) return next(error);
        response.clearCookie('connect.sid');
        response.sendStatus(204);
    });
});
// Public catalog data comes directly from PostgreSQL.
app.get('/api/currencies', async (request, response, next) => {
    try {
        const result = await database.query(`
            SELECT fx.code, fx.name, fx.units_per_usd, fx.rate_date,
                   array_agg(c.name ORDER BY c.name) AS countries
            FROM currencies fx JOIN countries c ON c.currency_code = fx.code
            GROUP BY fx.code ORDER BY fx.code`);
        response.set('Cache-Control', 'no-store').json({ currencies: result.rows });
    } catch (error) { next(error); }
});
app.get('/api/countries', async (request, response, next) => {
    try {
        const result = await database.query(`
            SELECT c.code, c.name, c.region, c.currency_code, fx.name AS currency_name, fx.units_per_usd, fx.rate_date, COUNT(p.id)::int AS price_count,
                   SUM(p.amount) AS basket_total, COALESCE(bool_or(p.is_sample), false) AS is_sample
            FROM countries c JOIN currencies fx ON fx.code=c.currency_code LEFT JOIN prices p ON p.country_code = c.code AND p.currency = 'USD'
            GROUP BY c.code, fx.code ORDER BY c.region, c.name`);
        response.set('Cache-Control', 'no-store').json({ countries: result.rows });
    } catch (error) { next(error); }
});
app.get('/api/groceries', async (request, response, next) => {
    const country = String(request.query.country || 'LB').toUpperCase();
    if (!/^[A-Z]{2}$/.test(country)) return response.status(400).json({ message: 'Choose a valid country.' });
    try {
        const market = await database.query('SELECT c.code, c.name, c.currency_code, fx.units_per_usd, fx.rate_date FROM countries c JOIN currencies fx ON fx.code=c.currency_code WHERE c.code = $1', [country]);
        if (!market.rows.length) return response.status(404).json({ message: 'Country not found.' });
        const result = await database.query(`
            SELECT g.id, g.name, g.package_size, c.name AS category, p.amount, p.currency, p.is_sample
            FROM groceries g JOIN categories c ON c.id = g.category_id
            LEFT JOIN prices p ON p.grocery_id = g.id AND p.country_code = $1 AND p.currency = 'USD'
            ORDER BY c.id, g.id`, [country]);
        response.set('Cache-Control', 'no-store').json({ country: market.rows[0], groceries: result.rows });
    } catch (error) { next(error); }
});
// Serve the existing frontend from the same address as the API.
app.get('/', (request, response) => response.redirect('/pages/index.html'));
app.use(express.static(path.join(__dirname, '../frontend')));
app.use((error, request, response, next) => {
    if (error.status === 400 || inputErrors.has(error.message)) {
        const status = error.message === 'Invalid email or password.' ? 401 : 400;
        return response.status(status).json({ message: error.message });
    }
    if (error.type === 'entity.parse.failed') return response.status(400).json({ message: 'Send valid JSON.' });
    if (error.type === 'entity.too.large') return response.status(413).json({ message: 'Request is too large.' });
    response.status(503).json({ message: 'Account service unavailable. Check database setup.' });
});
app.listen(3000, '127.0.0.1', () => console.log('Market Atlas running at http://127.0.0.1:3000'));
