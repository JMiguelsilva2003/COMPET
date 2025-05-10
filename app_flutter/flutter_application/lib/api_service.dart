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

  // POST - Cadastrar usuário
  static Future<String> registerUser(String nome, String cpf, String senha, bool concordou) async {
    final Map<String, dynamic> requestBody = {
      "nome": nome,
      "cpf": cpf,
      "senha": senha,
      "concordou": concordou,
    };

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/usuarios/cadastrar_usuario"),
      headers: ApiConfig.getHeaders(),
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body)["mensagem"];
    } else {
      throw Exception("Erro no cadastro: ${jsonDecode(response.body)["detail"]}");
    }
  }

    // POST - Login do usuário
  static Future<Map<String, dynamic>> loginUser(String cpf, String senha) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/usuarios/login"),
      headers: ApiConfig.getHeaders(),
      body: jsonEncode({
        "cpf": cpf,
        "senha": senha,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("CPF ou senha inválidos.");
    }
  }
}
