public class LogWrapper {
  public String endpoint;
  public String method;
  public String requestBody;
  public Integer statusCode;
  public String responseBody;
  public String className;
  public Boolean success;
  public String typeValue;

  //  Populate log from API Request + Response
  public void populateFromApi(
    HttpRequest req,
    HttpResponse res,
    String className,
    String typeValue
  ) {
    this.endpoint = req != null ? req.getEndpoint() : null;
    this.method = req != null ? req.getMethod() : null;
    this.requestBody = req != null ? req.getBody() : null;
    this.statusCode = res != null ? res.getStatusCode() : null;
    this.responseBody = res != null ? res.getBody() : null;
    this.className = className;
    this.typeValue = typeValue;
    this.success = (res != null &&
    res.getStatusCode() >= 200 &&
    res.getStatusCode() < 300);
  }
}
