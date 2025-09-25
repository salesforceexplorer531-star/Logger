public class WeatherService {
  public static HttpResponse getCurrentWeather(String location) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();

    // Endpoint with API Key and location
    String endpoint =
      'https://api.weatherapi.com/v1/current.json?key=d2f6468eedc14671bc883059250509&q=' +
      EncodingUtil.urlEncode(location, 'UTF-8');

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
      Map<String, Object> locationInfo = (Map<String, Object>) results.get(
        'location'
      );
      Map<String, Object> currentWeather = (Map<String, Object>) results.get(
        'current'
      );

      System.debug(
        'Location: ' +
          locationInfo.get('name') +
          ', ' +
          locationInfo.get('country')
      );
      System.debug('Temperature (C): ' + currentWeather.get('temp_c'));
      System.debug(
        'Condition: ' +
        ((Map<String, Object>) currentWeather.get('condition')).get('text')
      );
    } else {
      System.debug(
        'Weather API call failed. Status: ' + response.getStatusCode()
      );
    }

    // Log API call details
    insertLog(
      endpoint,
      'GET',
      null,
      response,
      isSuccess,
      'WeatherService',
      'API'
    );

    return response;
  }

  // Reuse logging logic
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
