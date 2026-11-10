// Each page asks the backend which account owns the current session cookie.
(() => {
    const area = document.querySelector('header .account');
    async function refreshAccount() {
        try {
            const response = await fetch('/api/me', { cache: 'no-store' });
            if (!response.ok && response.status !== 401) return;
            const basket = document.createElement('a');
            basket.href = 'basket.html';
            basket.textContent = 'Basket ↗';
            if (response.status === 401) {
                const login = document.createElement('a');
                login.href = 'login.html';
                login.textContent = 'Log in / Sign up';
                area.replaceChildren(basket, login);
                return;
            }
            const { user } = await response.json();
            const badge = document.createElement('a');
            badge.href = 'login.html';
            badge.className = 'account-badge';
            let avatar;
            if (user.profile_picture) {
                avatar = document.createElement('img');
                avatar.src = user.profile_picture;
                avatar.alt = '';
            } else {
                avatar = document.createElement('span');
                avatar.textContent = user.username.slice(0, 1).toUpperCase();
                avatar.setAttribute('aria-hidden', 'true');
            }
            avatar.className = 'account-avatar';
            const copy = document.createElement('span');
            const name = document.createElement('strong');
            name.textContent = `Logged in as ${user.username}`;
            const age = document.createElement('small');
            const days = Math.max(0, Math.floor((Date.now() - new Date(user.created_at).getTime()) / 86400000));
            age.textContent = days === 0 ? 'Account age: less than a day' : `Account age: ${days} ${days === 1 ? 'day' : 'days'}`;
            copy.append(name, age);
            badge.append(avatar, copy);
            area.replaceChildren(basket, badge);
        } catch {
            // Keep the existing navigation if the connection is temporarily lost.
        }
    }
    window.addEventListener('account-changed', refreshAccount);
    window.addEventListener('pageshow', refreshAccount);
    refreshAccount();
})();
