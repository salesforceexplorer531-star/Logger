// pseudocode: if running under platform, the adapter will call an @AuraEnabled Apex method or fetch a platform-provided endpoint.
export default {
  getConfig: async () => {
    // call a small Apex REST endpoint: /services/apexrest/SearchConfig
    return fetch('/services/apexrest/SearchConfig').then(r=>r.json());
  },
  search: async (payload) => {
    return fetch('/services/apexrest/Search', {method:'POST', body: JSON.stringify(payload)})
      .then(r=>r.json());
  },
  getFilterOptions: async id => fetch(`/services/apexrest/Filters/${id}`).then(r=>r.json())
};
