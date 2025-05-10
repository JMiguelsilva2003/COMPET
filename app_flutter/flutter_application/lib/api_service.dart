import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  // GET - Testar conexão com API
  static Future<String> testConnection() async {
    final response = await http.get(Uri.parse("${ApiConfig.baseUrl}/"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["mensagem"];
    } else {
      throw Exception("Erro na conexão: ${response.statusCode}");
    }
  }
}
