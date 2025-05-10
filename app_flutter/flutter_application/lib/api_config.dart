class ApiConfig {
  static const String baseUrl = "http://192.168.1.16:8000";

  static Map<String, String> getHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer SEU_TOKEN_AQUI",
    };
  }
}
