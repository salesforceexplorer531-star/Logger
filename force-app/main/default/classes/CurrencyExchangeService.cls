public class CurrencyExchangeService {
  // Call the Exchange Rate API
  public static HttpResponse getExchangeRates(String baseCurrency) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    String endpoint =
      'https://v6.exchangerate-api.com/v6/1247d34e2dad4d71dc9dbaef/latest/' +
      baseCurrency;

    request.setEndpoint(endpoint);
    request.setMethod('GET');

    HttpResponse response = http.send(request);
    Boolean isSuccess = false;

    if (response.getStatusCode() == 200) {
      isSuccess = true;

      // Parse JSON response
      Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      String baseCode = (String) results.get('base_code');
      Map<String, Object> conversionRates = (Map<String, Object>) results.get(
        'conversion_rates'
      );

      System.debug('Base Currency: ' + baseCode);
      for (String currencyCode : conversionRates.keySet()) {
        System.debug(currencyCode + ' : ' + conversionRates.get(currencyCode));
      }
    } else {
      System.debug('Callout failed. Status: ' + response.getStatusCode());
    }

    // Log API call details
    insertLog(
      endpoint,
      'GET',
      null,
      response,
      isSuccess,
      'CurrencyExchangeService',
      'API'
    );

    return response;
  }

  // Insert record into Logger__c custom object
  private static void insertLog(
    String endpoint,
    String method,
    String requestBody,
    HttpResponse response,
    Boolean success,
    String className,
    String typeVal
  ) {
    Logger__c log = new Logger__c();
    log.Endpoint__c = endpoint;
    log.Method__c = method;
    log.Request_Body__c = requestBody;
    log.Status_Code__c = response.getStatusCode();
    log.Response_Body__c = response.getBody();
    log.Class_Name__c = className;
    log.Success__c = success;
    log.Type__c = typeVal;

    insert log;
  }
}
