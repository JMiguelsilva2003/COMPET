import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  File? _image;
  String? _latitude;
  String? _longitude;
  final ImagePicker _picker = ImagePicker();

  // Método para pedir permissão de localização
  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
  }

  // Método para tirar foto
  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });

      _getLocation();
    }
  }

  // Método para obter localização
  Future<void> _getLocation() async {
    await _requestPermission(); // Solicita permissão antes de pegar a localização

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

              if (_image != null) ...[
                Image.file(_image!, height: 200),
                const SizedBox(height: 10),
              ],

              if (_latitude != null && _longitude != null)
                Text(
                  'Latitude: $_latitude\nLongitude: $_longitude',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}