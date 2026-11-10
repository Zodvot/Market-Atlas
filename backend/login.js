const { scrypt, timingSafeEqual } = require("node:crypto");
const { promisify } = require("node:util");
const scryptAsync = promisify(scrypt);

// This function verifies credentials. The HTTP server must create a session
// after success, set its cookie, and limit repeated authentication attempts.
// It uses the users table documented in signup.js.
async function login(database, details) {
    const { email, password } = details ?? {};

    if (typeof email !== "string" || typeof password !== "string") {
        throw new Error("Invalid email or password.");
    }

    const normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.length > 254 || password.length > 128 || password.length === 0) {
        throw new Error("Invalid email or password.");
    }

    const result = await database.query(
        "SELECT id, email, username, profile_picture, password_hash, created_at FROM users WHERE email = $1",
        [normalizedEmail]
    );
    const user = result.rows[0];

    // Perform hashing even when the account does not exist, to reduce timing
    // differences between an unknown email and an incorrect password.
    const dummyHash = `scrypt-v1:${"0".repeat(32)}:${"0".repeat(128)}`;
    const storedHash = user ? user.password_hash : dummyHash;
    if (!/^scrypt-v1:[a-f0-9]{32}:[a-f0-9]{128}$/.test(storedHash)) {
        throw new Error("Invalid email or password.");
    }

    const [, salt, hash] = storedHash.split(":");
    const expectedKey = Buffer.from(hash, "hex");
    const submittedKey = await scryptAsync(password, salt, 64, {
        N: 131072,
        r: 8,
        p: 1,
        maxmem: 256 * 1024 * 1024,
    });

    // Constant-time comparison avoids stopping at the first different byte.
    const passwordMatches = timingSafeEqual(expectedKey, submittedKey);
    if (!user || !passwordMatches) {
        throw new Error("Invalid email or password.");
    }

    return { id: user.id, email: user.email, username: user.username, profile_picture: user.profile_picture, created_at: user.created_at };
}

module.exports = { login };
