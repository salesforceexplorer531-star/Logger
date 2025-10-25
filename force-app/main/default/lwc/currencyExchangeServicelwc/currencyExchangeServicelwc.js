import { LightningElement, track } from 'lwc';
import getExchangeRates from '@salesforce/apex/CurrencyExchangeService.getExchangeRate';

export default class CurrencyExchangeLwc extends LightningElement {
    @track baseCurrency = 'USD';
    @track rates;
    @track rateEntries = [];
    @track error;

    handleCurrencyChange(event) {
        this.baseCurrency = event.target.value;
    }

    getRates() {
        this.error = null;
        this.rates = null;

        getExchangeRates({ baseCode: this.baseCurrency })
            .then((result) => {
                this.rates = result.conversion_rates;
                this.rateEntries = Object.entries(result.conversion_rates).map(([key, value]) => ({
                    key,
                    value
                }));
            })
            .catch((error) => {
                this.error = 'Error fetching rates: ' + (error.body ? error.body.message : error.message);
            });
    }
}
