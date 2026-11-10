import { element, getData, money, groupSection, priceText, currencyControl, rateNote } from './catalog.js';
const content = document.querySelector('#catalog-content');
const status = document.querySelector('#catalog-status');
try {
    const { countries } = await getData('/api/countries');
    const prices = [];
    currencyControl(() => prices.forEach(({node, country}) => node.textContent = priceText(country.basket_total, country)));
    rateNote(countries);
    const groups = new Map();
    for (const country of countries) {
        if (!groups.has(country.region)) {
            const group = groupSection(country.region, 'country-grid');
            groups.set(country.region, group);
            content.append(group.section);
        }
        const card = element('article', undefined, 'card');
        const flag = element('div', undefined, 'country-flag');
        const image = element('img');
        image.src = `../assets/flags/${country.code.toLowerCase()}.svg`;
        image.alt = `Flag of ${country.name}`;
        image.width = 120;
        image.height = 80;
        image.loading = 'lazy';
        flag.append(image);
        card.append(flag, element('h3', country.name), element('p', `${country.price_count} groceries priced`));
        if (country.basket_total !== null) {
            const node = element('div', priceText(country.basket_total, country), 'price');
            prices.push({node, country});
            card.append(node, element('p', `${country.currency_name} (${country.currency_code}) · ${country.is_sample ? 'Sample' : 'Listed'} basket`, 'small'));
        }
        const link = element('a', 'View grocery prices →');
        link.href = `groceries.html?country=${encodeURIComponent(country.code)}`;
        card.append(link);
        groups.get(country.region).grid.append(card);
    }
    status.textContent = `${countries.length} countries · Prices loaded from the database`;
} catch (error) { status.textContent = error.message; }
