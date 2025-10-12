import platformAdapter from './platformAdapter';

export default {
  getConfig: () => platformAdapter.getConfig(),
  search: (payload) => platformAdapter.search(payload),
  getFilterOptions: (id) => platformAdapter.getFilterOptions(id)
};
