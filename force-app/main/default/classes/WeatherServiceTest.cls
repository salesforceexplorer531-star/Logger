@IsTest
public class WeatherServiceTest {
  // Mock response for success case (200 OK)
  private class WeatherMockSuccess implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatusCode(200);
      res.setBody(
        '{' +
          '"location": {' +
          '"name": "London",' +
          '"region": "City of London, Greater London",' +
          '"country": "United Kingdom"' +
          '},' +
          '"current": {' +
          '"temp_c": 15.0,' +
          '"condition": {"text":"Partly cloudy"}' +
          '}' +
          '}'
      );
      return res;
    }
  }

  // Mock response for failure case (500 Server Error)
  private class WeatherMockFailure implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatusCode(500);
      res.setBody('{"error":"server error"}');
      return res;
    }
  }

  // Test method for success
  @IsTest
  static void testGetCurrentWeather_Success() {
    // Set mock
    Test.setMock(HttpCalloutMock.class, new WeatherMockSuccess());

    // Call service
    HttpResponse res = WeatherService.getCurrentWeather('London');

    // Assertions
    System.assertEquals(200, res.getStatusCode(), 'Response should be 200');
    System.assert(
      res.getBody().contains('"name": "London"'),
      'Response should contain London'
    );

    // Verify Logger record created
    List<Logger__c> logs = [
      SELECT Id, Endpoint__c, Method__c, Status_Code__c, Success__c, Type__c
      FROM Logger__c
      WHERE Class_Name__c = 'WeatherService'
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];

    System.assertEquals('GET', logs[0].Method__c);
    System.assertEquals(200, logs[0].Status_Code__c);
    System.assertEquals(true, logs[0].Success__c);
    System.assertEquals(
      'API',
      logs[0].Type__c != null ? logs[0].Type__c.toUpperCase() : null
    );
  }

  // Test method for failure
  @IsTest
  static void testGetCurrentWeather_Failure() {
    // Set mock
    Test.setMock(HttpCalloutMock.class, new WeatherMockFailure());

    // Call service
    HttpResponse res = WeatherService.getCurrentWeather('London');

    // Assertions
    System.assertEquals(500, res.getStatusCode(), 'Response should be 500');
    System.assert(
      res.getBody().contains('server error'),
      'Response should contain error message'
    );

    // Verify Logger record created
    List<Logger__c> logs = [
      SELECT Id, Endpoint__c, Method__c, Status_Code__c, Success__c, Type__c
      FROM Logger__c
      WHERE Class_Name__c = 'WeatherService'
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];

    System.assertEquals('GET', logs[0].Method__c);
    System.assertEquals(500, logs[0].Status_Code__c);
    System.assertEquals(false, logs[0].Success__c);
    System.assertEquals(
      'API',
      logs[0].Type__c != null ? logs[0].Type__c.toUpperCase() : null
    );
  }
}
