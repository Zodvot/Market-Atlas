const form = document.querySelector('#signup-form');
const message = document.querySelector('#form-message');
const button = form.querySelector('button');

// The browser sends JSON to Node.js. Node.js uses backend/signup.js.
form.addEventListener('submit', async (event) => {
    event.preventDefault();
    button.disabled = true;
    message.dataset.error = 'false';
    message.textContent = 'Creating your account…';
    try {
        const profilePicture = await readPicture();
        const response = await fetch('/api/signup', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: form.email.value, password: form.password.value, username: form.username.value, gender: form.gender.value, dateOfBirth: form.dateOfBirth.value, profilePicture }),
        });
        const result = await response.json().catch(() => ({}));
        if (!response.ok) throw new Error(result.message || 'Unable to sign up. Please try again shortly.');
        form.reset();
        // Signup creates an account; the next step is logging in.
        window.location.assign('login.html?registered=1');
    } catch (error) {
        message.dataset.error = 'true';
        message.textContent = error instanceof TypeError ? 'Cannot reach the server. Check your connection and try again.' : error.message;
    } finally {
        button.disabled = false;
    }
});

// Read the chosen image only after checking its size and file type.
async function readPicture() {
    const file = form.profilePicture.files[0];
    if (!file) return null;
    if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type) || file.size > 2 * 1024 * 1024) {
        throw new Error('Choose a JPEG, PNG, or WebP picture of 2 MB or less.');
    }
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.onerror = () => reject(new Error('Unable to read this picture.'));
        reader.readAsDataURL(file);
    });
}
let previewUrl;
form.profilePicture.addEventListener('change', () => {
    const preview = document.querySelector('#picture-preview');
    if (previewUrl) URL.revokeObjectURL(previewUrl);
    const file = form.profilePicture.files[0];
    preview.hidden = true;
    if (file && ['image/jpeg', 'image/png', 'image/webp'].includes(file.type) && file.size <= 2 * 1024 * 1024) {
        previewUrl = URL.createObjectURL(file);
        preview.src = previewUrl;
        preview.hidden = false;
    }
});
const today = new Date();
form.dateOfBirth.max = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
