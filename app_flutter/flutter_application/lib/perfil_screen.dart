import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'mapa_screen.dart';
import 'relatorio_screen.dart';
import 'login_screen.dart';
import 'api_service.dart';

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

  Future<void> _speakAndNavigate(String text, Widget screen) async {
    await flutterTts.speak(text);
    await Future.delayed(const Duration(seconds: 2));
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _speakAndNavigate("Você está indo para a tela de Mapa, onde pode visualizar sua localização.", const MapaScreen());
    } else if (index == 1) {
      _speakAndNavigate("Agora você está indo para Relatórios, onde verá dados e análises.", const RelatorioScreen());
    } else if (index == 2) {
      _speak("Você já está na tela de Perfil, onde pode ver sua conta e configurações.");
    }
  }

  void _logout() {
    setState(() {
      UserSession.nomeUsuario = null;
      UserSession.cpfUsuario = null;
    });

    _speak("Você saiu da conta. Redirecionando para tela de login.");
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String nome = UserSession.nomeUsuario ?? "Usuário Exemplo";
    String cpf = UserSession.cpfUsuario ?? "000.000.000-00";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _speak("Foto de perfil do usuário"),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => _speak("Nome do usuário: $nome"),
                child: Text(
                  nome,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _speak("CPF do usuário: $cpf"),
                child: Text(
                  'CPF: $cpf',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 25),
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
                    children: const [
                      Text('Conversar com IA', style: TextStyle(fontSize: 18)),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _logout,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Sair da Conta', style: TextStyle(fontSize: 18, color: Colors.red)),
                      Icon(Icons.logout, color: Colors.red),
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
              onTap: () => _speakAndNavigate("Botão de Mapa - visualizar localização.", const MapaScreen()),
              child: const Icon(Icons.map),
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