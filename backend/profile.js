const sharp = require('sharp');

function invalid(message) {
    const error = new Error(message);
    error.status = 400;
    throw error;
}

// Validate everything again on the server because browser checks can be bypassed.
async function validateProfile({ username, gender, dateOfBirth, profilePicture }) {
    if (typeof username !== 'string' || !/^[A-Za-z0-9_]{3,30}$/.test(username.trim())) {
        invalid('Use a username with 3–30 letters, numbers, or underscores.');
    }
    if (!['female', 'male', 'nonbinary', 'other', 'prefer_not_to_say'].includes(gender)) {
        invalid('Choose a gender option.');
    }
    const date = typeof dateOfBirth === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(dateOfBirth) ? new Date(dateOfBirth + 'T00:00:00Z') : new Date(NaN);
    if (!Number.isFinite(date.getTime()) || date.toISOString().slice(0, 10) !== dateOfBirth || date > new Date() || date.getUTCFullYear() < 1900) {
        invalid('Enter a valid date of birth from 1900 through today.');
    }
    let picture = null;
    if (profilePicture !== undefined && profilePicture !== null && profilePicture !== '') {
        if (typeof profilePicture !== 'string' || !/^data:image\/(png|jpeg|webp);base64,[A-Za-z0-9+/=]+$/.test(profilePicture)) {
            invalid('Choose a JPEG, PNG, or WebP profile picture.');
        }
        const bytes = Buffer.from(profilePicture.split(',')[1], 'base64');
        if (bytes.length > 2 * 1024 * 1024) invalid('Profile pictures must be 2 MB or smaller.');
        try {
            // Decode and re-encode the image, remove metadata, and save a small avatar.
            const image = sharp(bytes, { limitInputPixels: 16000000 });
            const metadata = await image.metadata();
            if (!['jpeg', 'png', 'webp'].includes(metadata.format)) invalid('Unsupported image format.');
            const avatar = await image.rotate().resize(128, 128, { fit: 'cover' }).webp().toBuffer();
            picture = 'data:image/webp;base64,' + avatar.toString('base64');
        } catch {
            invalid('Choose a valid JPEG, PNG, or WebP image under 16 megapixels.');
        }
    }
    return { username: username.trim(), picture };
}
module.exports = { validateProfile };
