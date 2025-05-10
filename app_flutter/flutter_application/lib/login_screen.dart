import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'cadastro_screen.dart';
import 'perfil_screen.dart';
import 'api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String _apiStatus = "Verificando conexão...";
  String _loginMessage = "";

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

  Future<void> _loginUsuario() async {
    try {
      final response = await ApiService.loginUser(_cpfController.text, _senhaController.text);
      String mensagem = response["mensagem"];

      setState(() {
        _loginMessage = mensagem;
      });

      // Se a mensagem contiver "Bem-vindo", redireciona para perfil
      if (mensagem.contains("Bem-vindo")) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilScreen()),
        );
      }
    } catch (error) {
      setState(() {
        _loginMessage = "❌ CPF ou senha inválidos.";
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

              const SizedBox(height: 10),

              Text(
                _loginMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loginUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Entrar'),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não é registrado?'),
                  TextButton(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}