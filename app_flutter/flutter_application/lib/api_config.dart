class ApiConfig {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Map<String, String> getHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer SEU_TOKEN_AQUI",
    };
  }
}
