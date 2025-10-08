public with sharing class WeatherService {
  private static final String CLASS_NAME = 'WeatherService';
  private static final String BASE_URL = 'https://api.weatherapi.com/v1/current.json';
  private static final String API_KEY = 'd2f6468eedc14671bc883059250509';

  public static HttpResponse getCurrentWeather(String location) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res;
    LogWrapper lw = new LogWrapper();

    // Build endpoint with URL encoding
    String endpoint =
      BASE_URL +
      '?key=' +
      API_KEY +
      '&q=' +
      EncodingUtil.urlEncode(location, 'UTF-8');
    req.setEndpoint(endpoint);
    req.setMethod('GET');
    req.setTimeout(20000);

    // 🔹 Perform callout
    res = http.send(req);

    // 🔹 Populate and save log
    lw.populateFromApi(req, res, CLASS_NAME, 'Api');
    ApiLoggerService.addLog(lw);
    ApiLoggerService.insertLogs();

    // 🔹 Handle success
    if (res.getStatusCode() == 200) {
      Map<String, Object> json = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );
      Map<String, Object> locationInfo = (Map<String, Object>) json.get(
        'location'
      );
      Map<String, Object> current = (Map<String, Object>) json.get('current');

      System.debug(
        'Location: ' +
          locationInfo.get('name') +
          ', ' +
          locationInfo.get('country')
      );
      System.debug('Temperature (C): ' + current.get('temp_c'));
      System.debug(
        'Condition: ' +
        ((Map<String, Object>) current.get('condition')).get('text')
      );
    } else {
      System.debug('Weather API call failed. Status: ' + res.getStatusCode());
    }

    return res;
  }
}
