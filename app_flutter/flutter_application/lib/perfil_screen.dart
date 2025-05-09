import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int _selectedIndex = 2;
  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("pt-BR");
    flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _speak("Você está indo para a tela de Mapa, onde pode visualizar sua localização.");
    } else if (index == 1) {
      _speak("Agora você está indo para Relatórios, onde verá dados e análises.");
    } else if (index == 2) {
      _speak("Você já está na tela de Perfil, onde pode ver sua conta e configurações.");
    }
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
              // Foto de perfil
              GestureDetector(
                onTap: () => _speak("Foto de perfil do usuário"),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
              const SizedBox(height: 15),

              // Nome do usuário
              GestureDetector(
                onTap: () => _speak("Nome do usuário: Usuário Exemplo"),
                child: const Text(
                  'Usuário Exemplo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => _speak("Conversar com inteligência artificial"),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Conversar com IA', style: TextStyle(fontSize: 18)),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              GestureDetector(
                onTap: () => _speak("Sair da conta"),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sair da Conta', style: TextStyle(fontSize: 18, color: Colors.red)),
                      const Icon(Icons.arrow_forward_ios, color: Colors.red),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _speak("Botão de Mapa - visualizar localização."),
              child: const Icon(Icons.map),
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _speak("Botão de Relatórios - visualizar dados."),
              child: const Icon(Icons.article),
            ),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _speak("Botão de Perfil - ver configurações."),
              child: const Icon(Icons.person, color: Colors.blue), 
            ),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
