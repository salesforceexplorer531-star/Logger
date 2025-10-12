export default {
  getConfig: async () => fetch('/api/search/config').then(r => r.json()),
  search: async (payload) => fetch('/api/search', {
     method:'POST', headers:{'content-type':'application/json'}, body:JSON.stringify(payload)
  }).then(r=>r.json()),
  getFilterOptions: async (id) => fetch(`/api/filters/${id}`).then(r=>r.json())
};
