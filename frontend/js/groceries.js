import { element, getData, money, groupSection, priceText, currencyControl, rateNote } from './catalog.js';
const content = document.querySelector('#catalog-content');
const status = document.querySelector('#catalog-status');
const select = document.querySelector('#country-select');
let icons = {};
currencyControl(loadGroceries);
let requestNumber = 0;
async function loadGroceries() {
    const currentRequest = ++requestNumber;
    content.replaceChildren();
    status.textContent = 'Loading prices…';
    try {
        const data = await getData(`/api/groceries?country=${encodeURIComponent(select.value)}`);
        if (currentRequest !== requestNumber) return;
        const groups = new Map();
        for (const grocery of data.groceries) {
            if (!groups.has(grocery.category)) {
                const group = groupSection(grocery.category, 'grid');
                groups.set(grocery.category, group);
                content.append(group.section);
            }
            const card = element('article', undefined, 'card');
            const icon = element('div', icons[grocery.name] || '🛒', 'produce');
            icon.setAttribute('aria-hidden', 'true');
            card.append(icon, element('h3', grocery.name), element('p', grocery.package_size));
            card.append(element('div', grocery.amount === null ? 'Price unavailable' : priceText(grocery.amount, data.country), 'price'));
            card.append(element('span', `${grocery.is_sample ? 'Sample price · ' : ''}${data.country.name} · ${data.country.currency_code}`, 'small'));
            groups.get(grocery.category).grid.append(card);
        }
        status.textContent = `${data.groceries.length} groceries · ${data.country.name} · Database prices`;
        history.replaceState(null, '', `?country=${encodeURIComponent(select.value)}`);
    } catch (error) { if (currentRequest === requestNumber) status.textContent = error.message; }
}
try {
    const data = await getData('/api/countries');
    rateNote(data.countries);
    icons = await getData('../js/catalog-icons.json');
    for (const country of data.countries) {
        const option = element('option', `${country.name} (${country.currency_code})`);
        option.value = country.code;
        select.append(option);
    }
    const requested = (new URLSearchParams(location.search).get('country') || 'LB').toUpperCase();
    select.value = data.countries.some(country => country.code === requested) ? requested : 'LB';
    select.disabled = false;
    select.addEventListener('change', loadGroceries);
    await loadGroceries();
} catch (error) { status.textContent = error.message; }
