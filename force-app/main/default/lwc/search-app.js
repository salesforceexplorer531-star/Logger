import { LightningElement, track } from 'lwc';
import { debounce } from './utils'; // small helper or use lodash

export default class SearchApp extends LightningElement {
  @track heading = 'Salesforce productivity'; // could be driven by config
  @track availableFilters = [];
  @track results = [];
  @track loading = false;
  @track page = 1;
  @track pageSize = 24;
  query = '';
  selectedFilters = {};

  connectedCallback() {
    this.init();
  }

  async init() {
    try {
      const config = await fetch('/api/search/config').then(r => r.json());
      this.availableFilters = config.availableFilters || [];
      this.pageSize = config.resultsPerPage || this.pageSize;
      this.searchEndpoint = config.searchEndpoint;
      // optional: prefetch filter options that require endpoints
    } catch (e) {
      console.error('Failed to load config', e);
    }
    // initial search
    this.doSearch();
  }

  handleSearch = (ev) => {
    this.query = ev.detail?.query || '';
    this.page = 1;
    this.doSearch();
  }

  handleFilterChange = (ev) => {
    this.selectedFilters = ev.detail.filters;
    this.page = 1;
    this.doSearch();
  }

  handlePageChange = (ev) => {
    this.page = ev.detail.page;
    this.doSearch();
  }

  async doSearch() {
    this.loading = true;
    try {
      const body = {
        q: this.query,
        filters: this.selectedFilters,
        page: this.page,
        pageSize: this.pageSize
      };
      const resp = await fetch(this.searchEndpoint, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(body)
      });
      const json = await resp.json();
      this.results = json.results || [];
      this.total = json.total || 0;
    } catch (e) {
      console.error('Search failed', e);
      this.results = [];
    } finally {
      this.loading = false;
    }
  }
}
