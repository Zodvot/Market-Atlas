const { validateProfile } = require('./profile');
const { randomBytes, scrypt } = require("node:crypto");
const { promisify } = require("node:util");

// promisify lets us wait for password hashing with the await keyword.
const scryptAsync = promisify(scrypt);

// Requires users.sql and profile.sql. database is a node-postgres Pool.
async function signup(database, details) {
    const { email, password, username, gender, dateOfBirth, profilePicture } = details ?? {};
    const profile = await validateProfile({ username, gender, dateOfBirth, profilePicture });

    if (typeof email !== "string" || typeof password !== "string") {
        throw new Error("Email and password must be text.");
    }

    // Normalizing email prevents separate accounts for different capitalization.
    const normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalizedEmail)) {
        throw new Error("Enter a valid email address.");
    }

    // Preserve the exact password, including spaces. Bound input size too.
    if (password.length < 12 || password.length > 128) {
        throw new Error("Use a password between 12 and 128 characters.");
    }

    // A unique random salt makes identical passwords produce different hashes.
    const salt = randomBytes(16).toString("hex");
    const derivedKey = await scryptAsync(password, salt, 64, {
        N: 131072,
        r: 8,
        p: 1,
        maxmem: 256 * 1024 * 1024,
    });
    const passwordHash = `scrypt-v1:${salt}:${derivedKey.toString("hex")}`;

    // $1 and $2 keep user input separate from SQL instructions.
    // The UNIQUE constraint also protects against simultaneous signups.
    const result = await database.query(
        `INSERT INTO users (email, password_hash, username, gender, date_of_birth, profile_picture)
         VALUES ($1, $2, $3, $4, $5, $6)
         ON CONFLICT DO NOTHING
         RETURNING id, email, username, profile_picture, created_at`,
        [normalizedEmail, passwordHash, profile.username, gender, dateOfBirth, profile.picture]
    );

    if (result.rows.length === 0) {
        throw new Error("This email or username is already registered.");
    }

    // Return public account details. Never send the password hash to the browser.
    return result.rows[0];
}

module.exports = { signup };
