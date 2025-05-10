import 'dart:io';
import 'relatorio_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'api_service.dart';
import 'perfil_screen.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  List<Map<String, dynamic>> _imageData = [];
  bool _isLoading = true;
  final FlutterTts flutterTts = FlutterTts();
  List<File> _images = [];
  List<Map<String, String>> _locations = [];
  final ImagePicker _picker = ImagePicker();
  String _uploadStatus = "";

  // 🔹 Criando controladores corretos para WebView
final WebViewController webViewControllerPontos = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse("http://192.168.1.16:8000/mapas/mapas/pontos"));

final WebViewController webViewControllerConexoes = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse("http://192.168.1.16:8000/mapas/mapas/conexoes"));

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("pt-BR");
    flutterTts.setSpeechRate(0.5);
    _fetchImages();
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _speakAndNavigate(String text, Widget screen) async {
    await flutterTts.speak(text);
    await Future.delayed(const Duration(seconds: 2));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
  }

  Future<void> _fetchImages() async {
    try {
      List<Map<String, dynamic>> images = await ApiService.listarImagens();
      setState(() {
        _imageData = images;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _uploadStatus = "❌ Erro ao listar imagens.";
      });
    }
  }

  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _getLocation(image);
      await _uploadImageToApi(File(image.path));
    }
  }

  Future<void> _getLocation(XFile image) async {
    await _requestPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _images.add(File(image.path));
      _locations.add({
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
      });
    });
  }

  Future<void> _uploadImageToApi(File image) async {
    try {
      if (UserSession.cpfUsuario == null) {
        setState(() {
          _uploadStatus = "❌ Erro: Usuário não está logado.";
        });
        return;
      }

      String cpfUsuario = UserSession.cpfUsuario!;
      double latitude = double.tryParse(_locations.last["latitude"]!) ?? 0.0;
      double longitude = double.tryParse(_locations.last["longitude"]!) ?? 0.0;

      String mensagem = await ApiService.uploadImage(
        image,
        cpfUsuario,
        latitude,
        longitude,
      );

      setState(() {
        _uploadStatus = "✅ $mensagem";
      });
    } catch (error) {
      setState(() {
        _uploadStatus = "❌ $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Mapa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _captureImage,
                child: const Text('Tirar Foto'),
              ),
              const SizedBox(height: 10),
              Text(
                _uploadStatus,
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // 🔹 Exibe a lista de imagens da API
              _isLoading
                  ? const CircularProgressIndicator()
                  : _imageData.isNotEmpty
                      ? Column(
                          children: _imageData.map((image) {
                            return Card(
                              child: ListTile(
  leading: Image.network(
  image["caminho_local"],  // 🔹 Agora carrega a imagem pelo servidor HTTP
  height: 50,
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error, color: Colors.red);  // 🔹 Exibe ícone de erro se a imagem não for carregada
  },
),

                                title: Text("Arquivo: ${image["arquivo"]}"),
                                subtitle: Text("Lat: ${image["latitude"]}, Lon: ${image["longitude"]}"),
                              ),
                            );
                          }).toList(),
                        )
                      : const Text("Nenhuma imagem encontrada."),

              const SizedBox(height: 20),

              // 🔹 Mapa de pontos
              SizedBox(
                height: 300,
                child: WebViewWidget(controller: webViewControllerPontos),
              ),

              const SizedBox(height: 20),

              // 🔹 Mapa de conexões
              SizedBox(
                height: 300,
                child: WebViewWidget(controller: webViewControllerConexoes),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _speak("Você já está na tela de Mapa."),
              child: const Icon(Icons.map, color: Colors.blue),
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _speakAndNavigate("Botão de Relatórios - visualizar dados.", const RelatorioScreen()),
              child: const Icon(Icons.article),
            ),
            label: 'Relatório',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _speakAndNavigate("Indo para Perfil.", const PerfilScreen()),
              child: const Icon(Icons.person),
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}