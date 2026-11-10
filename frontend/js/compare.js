import { element, getData, priceText, currencyControl, rateNote, money } from './catalog.js';
const first = document.querySelector('#country-a');
const second = document.querySelector('#country-b');
const options = document.querySelector('#grocery-options');
const results = document.querySelector('#comparison-results');
const status = document.querySelector('#comparison-status');
let pair = null;
let generation = 0;
const selected = new Set();
currencyControl(render);
function render() {
    results.replaceChildren();
    if (!pair) return;
    if (!selected.size) { status.textContent = 'Select at least one grocery.'; return; }
    const [a,b] = pair;
    const table = element('table');
    table.append(element('caption', 'Selected grocery prices · one package per item'));
    const head = element('thead'); const headings = element('tr');
    for (const name of ['Grocery / quantity', a.country.name, b.country.name, 'Difference in USD']) {
        const cell = element('th', name); cell.scope = 'col'; headings.append(cell);
    }
    head.append(headings); table.append(head);
    const body = element('tbody'); let totalA = 0; let totalB = 0; let complete = true;
    const right = new Map(b.groceries.map(item => [item.id, item]));
    for (const item of a.groceries.filter(item => selected.has(item.id))) {
        const other = right.get(item.id);
        const row = element('tr'); const title = element('th', `${item.name} · ${item.package_size}`); title.scope = 'row';
        row.append(title, element('td', priceText(item.amount, a.country)), element('td', priceText(other?.amount ?? null, b.country)));
        if (item.amount === null || other?.amount == null) { complete = false; row.append(element('td', 'Unavailable')); }
        else {
            const difference = Number(other.amount) - Number(item.amount);
            row.append(element('td', difference === 0 ? 'Same price' : `${money.format(Math.abs(difference))} less in ${difference > 0 ? a.country.name : b.country.name}`));
            totalA += Number(item.amount); totalB += Number(other.amount);
        }
        body.append(row);
    }
    const total = element('tr'); const label = element('th', 'Selected basket total'); label.scope = 'row';
    total.append(label, element('td', complete ? priceText(totalA, a.country) : 'Incomplete'), element('td', complete ? priceText(totalB, b.country) : 'Incomplete'), element('td', complete ? money.format(Math.abs(totalA-totalB)) : 'Unavailable'));
    body.append(total); table.append(body); results.append(table);
    status.textContent = `${selected.size} selected groceries · ${a.country.name} vs ${b.country.name}`;
}
async function loadPair() {
    const version = ++generation; pair = null; results.replaceChildren();
    if (first.value === second.value) { status.textContent = 'Choose two different countries.'; return; }
    status.textContent = 'Loading comparison…';
    try {
        const data = await Promise.all([first.value,second.value].map(code => getData(`/api/groceries?country=${code}`)));
        if (version !== generation) return;
        pair = data; render();
    } catch(error) { if (version === generation) status.textContent = error.message; }
}
try {
    const {countries} = await getData('/api/countries'); rateNote(countries);
    for (const select of [first,second]) {
        for (const country of countries) { const option = element('option', `${country.name} (${country.currency_code})`); option.value=country.code; select.append(option); }
        select.disabled=false; select.addEventListener('change',loadPair);
    }
    first.value='LB';second.value='FR';
    const {groceries} = await getData('/api/groceries?country=LB');
    for (const item of groceries) {
        const label=element('label'); const check=element('input'); check.type='checkbox';check.value=item.id;
        check.addEventListener('change',()=>{if(check.checked) selected.add(item.id);else selected.delete(item.id);render();});
        label.append(check,document.createTextNode(`${item.name} · ${item.package_size}`));options.append(label);
    }
    document.querySelector('#select-all').addEventListener('click',()=>{for(const check of options.querySelectorAll('input')){check.checked=true;selected.add(Number(check.value));}render();});
    document.querySelector('#clear-all').addEventListener('click',()=>{selected.clear();for(const check of options.querySelectorAll('input'))check.checked=false;render();});
    await loadPair();
} catch(error) {status.textContent=error.message;}
