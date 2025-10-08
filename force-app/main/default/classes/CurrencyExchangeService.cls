public with sharing class CurrencyExchangeService {
  private static final String CLASS_NAME = 'CurrencyExchangeService';
  private static final String BASE_URL = 'https://v6.exchangerate-api.com/v6/';
  private static final String API_KEY = 'ca7c3c1dc4f425c2a0ac3eda';

  public static HttpResponse getExchangeRates(String baseCurrency) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res;
    LogWrapper lw = new LogWrapper();

    //  Build endpoint
    String endpoint = BASE_URL + API_KEY + '/latest/' + baseCurrency;
    req.setEndpoint(endpoint);
    req.setMethod('GET');
    req.setTimeout(20000);

    //  Perform API callout
    res = http.send(req);

    //  Log API request and response
    lw.populateFromApi(req, res, CLASS_NAME, 'API');
    ApiLoggerService.addLog(lw);
    ApiLoggerService.insertLogs();

    //  Handle successful response
    if (res.getStatusCode() == 200) {
      Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );
      String baseCode = (String) result.get('base_code');
      Map<String, Object> rates = (Map<String, Object>) result.get(
        'conversion_rates'
      );

      System.debug('Base Currency: ' + baseCode);
      System.debug('Exchange Rates:');

      for (String currencyCode : rates.keySet()) {
        System.debug(currencyCode + ' : ' + rates.get(currencyCode));
      }
    } else {
      System.debug(
        'Currency Exchange API call failed. Status: ' + res.getStatusCode()
      );
    }

    return res;
  }
}
