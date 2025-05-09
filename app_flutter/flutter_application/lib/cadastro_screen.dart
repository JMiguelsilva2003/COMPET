import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("pt-BR");
    flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
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

            GestureDetector(
              onTap: () => _speak("Digite seu nome no campo abaixo."),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Digite seu nome',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => _speak("Digite seu CPF no campo abaixo."),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Digite seu CPF',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => _speak("Digite sua senha no campo abaixo."),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => _speak("Confirme sua senha no campo abaixo."),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirme sua senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                GestureDetector(
                  onTap: () => _speak("Marque esta caixa para aceitar os termos e política de privacidade."),
                  child: Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Eu concordo que li e aceito os ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'termos e condições',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ' e a '),
                        TextSpan(
                          text: 'política de privacidade',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => _speak("Botão de cadastro. Clique para criar sua conta."),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text('Cadastrar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}