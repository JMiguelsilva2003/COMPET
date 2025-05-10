import 'dart:io';
import 'relatorio_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'perfil_screen.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final FlutterTts flutterTts = FlutterTts();
  List<File> _images = [];
  List<Map<String, String>> _locations = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    flutterTts.setLanguage("pt-BR");
    flutterTts.setSpeechRate(0.5);

    if (Platform.isAndroid) {
      WebViewController().setJavaScriptMode(JavaScriptMode.unrestricted);
    }
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

  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      await _getLocation(image);
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

  void _showImageDetails(File image, String latitude, String longitude) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(image, height: 200),
              const SizedBox(height: 10),
              Text("Latitude: $latitude"),
              Text("Longitude: $longitude"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  final WebViewController webViewController = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted);

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
              const SizedBox(height: 20),
              if (_images.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: List.generate(_images.length, (index) {
                      return GestureDetector(
                        onTap: () => _showImageDetails(
                          _images[index],
                          _locations[index]["latitude"]!,
                          _locations[index]["longitude"]!,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Image.file(_images[index], height: 100),
                              const SizedBox(width: 10),
                              Text("Lat: ${_locations[index]["latitude"]}"),
                              Text("Lon: ${_locations[index]["longitude"]}"),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: WebViewWidget(controller: webViewController),
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
