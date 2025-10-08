@IsTest
public class WeatherServiceTest {
  //  Mock success response
  private class WeatherMockSuccess implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
      HttpResponse res = new HttpResponse();
      res.setStatusCode(200);
      res.setHeader('Content-Type', 'application/json');
      res.setBody(
        '{' +
          '"location": {"name": "London", "country": "United Kingdom"},' +
          '"current": {"temp_c": 15.0, "condition": {"text": "Partly cloudy"}}' +
          '}'
      );
      return res;
    }
  }

  // Mock failure response
  private class WeatherMockFailure implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
      HttpResponse res = new HttpResponse();
      res.setStatusCode(500);
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"error":"Server Error"}');
      return res;
    }
  }

  //  Test: Success case (200 OK)
  @IsTest
  static void testGetCurrentWeather_Success() {
    Test.setMock(HttpCalloutMock.class, new WeatherMockSuccess());

    Test.startTest();
    HttpResponse res = WeatherService.getCurrentWeather('London');
    Test.stopTest();

    System.assertEquals(200, res.getStatusCode(), 'Status should be 200');
    System.assert(
      res.getBody().contains('"London"'),
      'Response should include London'
    );

    Logger__c log = [
      SELECT Method__c, Status_Code__c, Success__c, Type__c, Class_Name__c
      FROM Logger__c
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];

    System.assertEquals('GET', log.Method__c);
    System.assertEquals(200, log.Status_Code__c);
    System.assertEquals(true, log.Success__c);
    System.assertEquals('Api', log.Type__c);
    System.assertEquals('WeatherService', log.Class_Name__c);
  }

  //  Test: Failure case (500 Server Error)
  @IsTest
  static void testGetCurrentWeather_Failure() {
    Test.setMock(HttpCalloutMock.class, new WeatherMockFailure());

    Test.startTest();
    HttpResponse res = WeatherService.getCurrentWeather('London');
    Test.stopTest();

    System.assertEquals(500, res.getStatusCode(), 'Status should be 500');
    System.assert(
      res.getBody().contains('Server Error'),
      'Response should include error'
    );

    Logger__c log = [
      SELECT Method__c, Status_Code__c, Success__c, Type__c, Class_Name__c
      FROM Logger__c
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];

    System.assertEquals('GET', log.Method__c);
    System.assertEquals(500, log.Status_Code__c);
    System.assertEquals(false, log.Success__c);
    System.assertEquals('Api', log.Type__c);
    System.assertEquals('WeatherService', log.Class_Name__c);
  }
}
