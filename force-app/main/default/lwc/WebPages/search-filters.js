import { LightningElement, api, track } from 'lwc';

export default class SearchFilters extends LightningElement {
  @api filters = [];
  selected = {};

  onCheckboxChange(e) {
    const filterId = e.target.dataset.filterId;
    const val = e.target.value;
    if (!this.selected[filterId]) this.selected[filterId] = new Set();
    if (e.target.checked) this.selected[filterId].add(val);
    else this.selected[filterId].delete(val);

    // convert sets to arrays for event payload
    const payload = {};
    Object.keys(this.selected).forEach(k => {
      payload[k] = Array.from(this.selected[k]);
    });

    this.dispatchEvent(new CustomEvent('filterchange', { detail: { filters: payload } }));
  }
}
