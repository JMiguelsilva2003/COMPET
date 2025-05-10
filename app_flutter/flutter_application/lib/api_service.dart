import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'api_config.dart';

  // Classe para armazenar sessão do usuário
  class UserSession {
    static String? cpfUsuario;
    static String? nomeUsuario;
}
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
    Map<String, dynamic> responseData = jsonDecode(response.body);

    // Depuração para verificar se o CPF está sendo recebido corretamente
    print("✅ Resposta da API: $responseData");
    print("📌 CPF recebido: ${responseData["cpf"]}");

    // Salvando corretamente na sessão
    UserSession.cpfUsuario = responseData["cpf"]?.toString() ?? "0000000";
    UserSession.nomeUsuario = responseData["nome"]?.toString() ?? "Usuário";

    return responseData;
  } else {
    throw Exception("Erro no login: ${response.body}");
  }
}



static Future<String> uploadImage(File image, String cpfAgricultor, double latitude, double longitude) async {
  var request = http.MultipartRequest("POST", Uri.parse("${ApiConfig.baseUrl}/imagens/upload"));

  request.fields["cpf_agricultor"] = cpfAgricultor;
  request.fields["latitude"] = latitude.toString();
  request.fields["longitude"] = longitude.toString();

  request.files.add(
    await http.MultipartFile.fromPath(
      "imagem",
      image.path,
      contentType: MediaType("image", "jpeg"),
    ),
  );

  var response = await request.send();
  var responseData = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    return jsonDecode(responseData)["mensagem"];
  } else {
    throw Exception("Erro ao enviar imagem: ${jsonDecode(responseData)["erro"]}");
  }
}

  // GET - Listar imagens da API
  static Future<List<Map<String, dynamic>>> listarImagens() async {
    try {
      final response = await http.get(Uri.parse("${ApiConfig.baseUrl}/imagens/listar"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        return data.map((item) => {
          "arquivo": item["arquivo"],
          "cpf_agricultor": item["cpf_agricultor"],
          "latitude": item["latitude"],
          "longitude": item["longitude"],
          "caminho_local": item["caminho_local"],
        }).toList();
      } else {
        throw Exception("Erro ao listar imagens: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Falha na requisição: $error");
    }
  }

}