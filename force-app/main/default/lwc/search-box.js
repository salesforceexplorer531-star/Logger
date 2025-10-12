import { LightningElement, api, track } from 'lwc';
export default class SearchBox extends LightningElement {
  @track value = '';
  debounceTimer;

  onInput(e) {
    this.value = e.target.value;
    clearTimeout(this.debounceTimer);
    // debounce 300ms
    this.debounceTimer = setTimeout(() => {
      this.dispatchEvent(new CustomEvent('search', {
        detail: { query: this.value }
      }));
    }, 300);
  }
}
