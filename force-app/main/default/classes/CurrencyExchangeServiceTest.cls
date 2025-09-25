@IsTest
public class CurrencyExchangeServiceTest {
  // Mock response for success case (200 OK)
  private class CurrencyExchangeMockSuccess implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatusCode(200);
      res.setBody(
        '{' +
          '"result":"success",' +
          '"base_code":"USD",' +
          '"conversion_rates":{' +
          '"USD":1,' +
          '"EUR":0.91,' +
          '"INR":83.12' +
          '}' +
          '}'
      );
      return res;
    }
  }

  // Mock response for failure case (500 Error)
  private class CurrencyExchangeMockFailure implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatusCode(500);
      res.setBody('{"result":"error","error-type":"server-error"}');
      return res;
    }
  }

  @IsTest
  static void testGetExchangeRates_Success() {
    // Set mock
    Test.setMock(HttpCalloutMock.class, new CurrencyExchangeMockSuccess());

    // Call method
    HttpResponse res = CurrencyExchangeService.getExchangeRates('EUR');

    // Assertions
    System.assertEquals(200, res.getStatusCode(), 'Response should be 200');
    System.assert(
      res.getBody().contains('"base_code":"USD"'),
      'Response should contain USD'
    );

    // Verify Logger record was created
    List<Logger__c> logs = [
      SELECT Id, Endpoint__c, Method__c, Status_Code__c, Success__c, Type__c
      FROM Logger__c
      WHERE Class_Name__c = 'CurrencyExchangeService'
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

  @IsTest
  static void testGetExchangeRates_Failure() {
    // Set mock
    Test.setMock(HttpCalloutMock.class, new CurrencyExchangeMockFailure());

    // Call method
    HttpResponse res = CurrencyExchangeService.getExchangeRates('EUR');

    // Assertions
    System.assertEquals(500, res.getStatusCode(), 'Response should be 500');
    System.assert(
      res.getBody().contains('"error-type"'),
      'Response should contain error message'
    );

    // Verify Logger record was created
    List<Logger__c> logs = [
      SELECT Id, Endpoint__c, Method__c, Status_Code__c, Success__c, Type__c
      FROM Logger__c
      WHERE Class_Name__c = 'CurrencyExchangeService'
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
