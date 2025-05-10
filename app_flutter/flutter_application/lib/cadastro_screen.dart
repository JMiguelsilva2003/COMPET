import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'api_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  bool _aceitouTermos = false;
  String _statusCadastro = "";

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("pt-BR");
    flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _cadastrarUsuario() async {
    if (_senhaController.text != _confirmarSenhaController.text) {
      setState(() {
        _statusCadastro = "As senhas não coincidem!";
      });
      return;
    }

    try {
      String mensagem = await ApiService.registerUser(
        _nomeController.text,
        _cpfController.text,
        _senhaController.text,
        _aceitouTermos,
      );
      setState(() {
        _statusCadastro = "✅ $mensagem";
      });
    } catch (error) {
      setState(() {
        _statusCadastro = "❌ $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _speak("Registre-se. Crie sua conta para usar o aplicativo."),
              child: const Text(
                'Registre-se',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _speak("Crie sua conta para começar a usar."),
              child: const Text(
                'Crie a sua conta para começar a usar',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

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
            const SizedBox(height: 15),

            TextField(
              controller: _confirmarSenhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirme sua senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: _aceitouTermos,
                  onChanged: (bool? value) {
                    setState(() {
                      _aceitouTermos = value!;
                    });
                  },
                ),
                const Expanded(
                  child: Text("Eu li e aceito os termos e condições."),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              _statusCadastro,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _cadastrarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
