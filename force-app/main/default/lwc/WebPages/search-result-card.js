import { LightningElement, api } from 'lwc';
export default class SearchResultCard extends LightningElement {
  @api title;
  @api excerpt;
  @api url;
  @api badge;
}
