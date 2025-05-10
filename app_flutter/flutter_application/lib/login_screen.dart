import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'cadastro_screen.dart'; // Importando a tela de cadastro
import 'perfil_screen.dart';
import 'api_service.dart'; // Importando a API

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String _apiStatus = "Verificando conexão...";

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("pt-BR");
    flutterTts.setSpeechRate(0.5);
    _testApiConnection();
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _testApiConnection() async {
    try {
      String message = await ApiService.testConnection();
      setState(() {
        _apiStatus = "✅ API Online: $message";
      });
    } catch (error) {
      setState(() {
        _apiStatus = "❌ Erro na conexão com API";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _speak("Logotipo do aplicativo"),
                child: Image.asset(
                  'assets/logo.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => _speak("Bem-vindo ao aplicativo. Insira seu CPF e senha para entrar."),
                child: const Text(
                  'Bem-vindo!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _apiStatus,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => _speak("Digite seu CPF no campo abaixo."),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    hintText: 'Digite seu CPF',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              GestureDetector(
                onTap: () => _speak("Digite sua senha no campo abaixo."),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => _speak("Botão para entrar na conta"),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PerfilScreen()),
                      );
                    },
                    child: const Text('Entrar'),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não é registrado?'),
                  GestureDetector(
                    onTap: () => _speak("Clique aqui para criar uma conta"),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CadastroScreen()),
                        );
                      },
                      child: const Text(
                        'Registre-se aqui',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}