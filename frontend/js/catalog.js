// Build elements with textContent so database text is never interpreted as HTML.
export function element(tag, text, className) {
    const node = document.createElement(tag);
    if (text !== undefined) node.textContent = text;
    if (className) node.className = className;
    return node;
}
export async function getData(url) {
    const response = await fetch(url, { cache: 'no-store' });
    if (!response.ok) throw new Error('Unable to load prices. Please refresh to try again.');
    return response.json();
}
export const money = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });
export function groupSection(title, gridClass) {
    const section = element('section', undefined, 'directory-section');
    section.append(element('h2', title));
    const grid = element('div', undefined, gridClass);
    section.append(grid);
    return { section, grid };
}

// Load the supported currencies once before any page renders converted prices.
let currencies = [];
try {
    ({ currencies } = await getData('/api/currencies'));
} catch {
    // Country-local and USD display still work if the currency list is unavailable.
}
const rates = new Map(currencies.map(currency => [currency.code, Number(currency.units_per_usd)]));
rates.set('USD', 1);
let selectedCurrency = localStorage.getItem('currency-mode') || 'local';
if (selectedCurrency === 'usd') selectedCurrency = 'USD';
if (selectedCurrency !== 'local' && !rates.has(selectedCurrency)) selectedCurrency = 'local';
localStorage.setItem('currency-mode', selectedCurrency);

// Stored grocery prices are USD. Multiply by the selected currency's rate.
export function priceText(amount, country, mode = selectedCurrency) {
    if (amount === null) return 'Price unavailable';
    const code = mode === 'local' ? country.currency_code : mode;
    const rate = mode === 'local' ? Number(country.units_per_usd) : rates.get(code);
    if (!Number.isFinite(rate)) return 'Conversion unavailable';
    return new Intl.NumberFormat('en-US', {
        style: 'currency', currency: code, currencyDisplay: 'code'
    }).format(Number(amount) * rate);
}
export function currencyControl(onChange) {
    const label = element('label', 'Display prices in ');
    const select = element('select');
    const local = element('option', "Each country's local currency");
    local.value = 'local'; select.append(local);
    const options = currencies.length ? currencies : [{ code: 'USD', name: 'US Dollar' }];
    for (const currency of options) {
        const option = element('option', `${currency.code} — ${currency.name}`);
        option.value = currency.code;
        select.append(option);
    }
    select.value = selectedCurrency;
    select.addEventListener('change', () => {
        selectedCurrency = select.value;
        localStorage.setItem('currency-mode', selectedCurrency);
        onChange();
    });
    label.append(select);
    document.querySelector('main .notice').after(label);
    if (!currencies.length) label.after(element('p', 'Full currency list unavailable. Refresh to try again.', 'notice'));
    return select;
}
export function rateNote(countries) {
    const note = element('p', `Currency conversions use stored rates dated ${new Date(countries[0].rate_date).toLocaleDateString()}. `, 'small');
    const link = element('a', 'Rates by ExchangeRate-API'); link.href = 'https://www.exchangerate-api.com';
    note.append(link); document.querySelector('main').append(note);
}
