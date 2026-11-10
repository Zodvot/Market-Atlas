import { getData, priceText, currencyControl, rateNote, element } from './catalog.js';
try {
    const {countries}=await getData('/api/countries');
    const markets=new Map(countries.map(country=>[country.code,country]));
    const nodes=document.querySelectorAll('[data-usd]');
    function render() {
        for(const node of nodes) node.textContent=priceText(node.dataset.usd,markets.get(node.dataset.country));
    }
    currencyControl(render);rateNote(countries);render();
} catch {
    const note=element('p','Currency conversion is unavailable. Prices shown are the original USD samples.','notice');
    document.querySelector('main').prepend(note);
}
