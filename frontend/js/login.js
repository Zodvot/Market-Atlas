const form = document.querySelector('#login-form');
const message = document.querySelector('#form-message');
const button = form.querySelector('button');
const account = document.querySelector('#signed-in');
const logoutButton = document.querySelector('#logout-button');

function showAccount(user) {
    form.reset();
    form.hidden = true;
    account.hidden = false;
    document.querySelector('#account-email').textContent = `Signed in as ${user.username}`;
    message.dataset.error = 'false';
    message.textContent = 'You are logged in.';
    window.dispatchEvent(new Event('account-changed'));
}

if (new URLSearchParams(window.location.search).has('registered')) {
    message.textContent = 'Account created. Log in with your email and password.';
}

// Restore the account display if the browser already has a valid session cookie.
async function checkSession() {
    button.disabled = true;
    try {
        const response = await fetch('/api/me');
        if (response.ok) showAccount((await response.json()).user);
    } catch {
        message.textContent = 'Cannot reach the server. Please try again.';
    } finally {
        button.disabled = false;
    }
}
checkSession();

form.addEventListener('submit', async (event) => {
    event.preventDefault();
    button.disabled = true;
    message.dataset.error = 'false';
    message.textContent = 'Logging in…';
    try {
        const response = await fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: form.email.value, password: form.password.value }),
        });
        const result = await response.json().catch(() => ({}));
        if (!response.ok) throw new Error(result.message || 'Unable to log in. Please try again shortly.');
        // The browser stores the HTTP-only session cookie automatically.
        showAccount(result.user);
    } catch (error) {
        message.dataset.error = 'true';
        message.textContent = error instanceof TypeError ? 'Cannot reach the server. Check your connection and try again.' : error.message;
    } finally {
        button.disabled = false;
    }
});

logoutButton.addEventListener('click', async () => {
    logoutButton.disabled = true;
    try {
        const response = await fetch('/api/logout', { method: 'POST' });
        if (!response.ok) throw new Error('Unable to log out. Please try again.');
        account.hidden = true;
        form.hidden = false;
        message.textContent = 'You have logged out.';
        window.dispatchEvent(new Event('account-changed'));
        message.dataset.error = 'false';
    } catch {
        message.dataset.error = 'true';
        message.textContent = 'Unable to log out. Please try again.';
    } finally {
        logoutButton.disabled = false;
    }
});
