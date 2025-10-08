public with sharing class ApiLoggerService {
  private static List<Logger__c> buffer = new List<Logger__c>();

  //  Convert LogWrapper to Logger__c record
  private static Logger__c toSObject(LogWrapper lw) {
    Logger__c log = new Logger__c();
    log.Endpoint__c = truncate(lw.endpoint, 255);
    log.Method__c = truncate(lw.method, 10);
    log.Request_Body__c = lw.requestBody;
    log.Status_Code__c = lw.statusCode;
    log.Response_Body__c = lw.responseBody;
    log.Class_Name__c = truncate(lw.className, 50);
    log.Success__c = lw.success;
    log.Type__c = lw.typeValue;
    return log;
  }

  //  Helper to prevent “String too long” errors
  private static String truncate(String input, Integer maxLength) {
    return (input != null &&
      input.length() > maxLength)
      ? input.substring(0, maxLength)
      : input;
  }

  //  Add a new log to buffer
  public static void addLog(LogWrapper lw) {
    if (lw != null)
      buffer.add(toSObject(lw));
  }

  //  Insert all buffered logs at once
  public static void insertLogs() {
    if (!buffer.isEmpty()) {
      Database.insert(buffer, false); // partial success allowed
      buffer.clear();
    }
  }
}
