import 'package:flutter/material.dart';
import 'perfil_screen.dart';
import 'mapa_screen.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  String? _residuosSolidos;
  String? _residuosLiquidos;
  bool _temCAR = false;
  int _qtdPessoas = 0;
  bool _consomeAgua = false;
  bool _temPlantacao = false;
  String? _tipoFertilizante;
  bool _temAnimais = false;
  String? _tipoAnimais;
  double? _distanciaAnimais;
  bool _appPreservada = false;

  void _speak(String text) {
    // Aqui pode ser adicionada funcionalidade de voz futuramente
  }

  void _speakAndNavigate(String text, Widget screen) async {
    _speak(text);
    await Future.delayed(const Duration(seconds: 2));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Relatório Ambiental da Nascente',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              const Text('Imagens da nascente coletadas no mapa:'),

              const SizedBox(height: 10),

              // Aqui futuramente serão carregadas as imagens da API
              FutureBuilder<List<String>>(
                future: _fetchImagesFromApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text("Erro ao carregar imagens");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("Nenhuma imagem disponível.");
                  }

                  return SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.map((imageUrl) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.network(imageUrl, height: 100),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text('Descarte de resíduos sólidos:'),
              TextField(
                onChanged: (value) => _residuosSolidos = value,
                decoration: const InputDecoration(
                  hintText: 'Descreva como o lixo é descartado',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              const Text('Descarte de resíduos líquidos:'),
              TextField(
                onChanged: (value) => _residuosLiquidos = value,
                decoration: const InputDecoration(
                  hintText: 'Descreva como o esgoto é descartado',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text('A propriedade tem CAR?'),
                value: _temCAR,
                onChanged: (value) => setState(() => _temCAR = value),
              ),

              const SizedBox(height: 10),

              const Text('Quantas pessoas moram na propriedade?'),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => _qtdPessoas = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(
                  hintText: 'Digite o número de pessoas',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text('Eles consomem a água da nascente?'),
                value: _consomeAgua,
                onChanged: (value) => setState(() => _consomeAgua = value),
              ),

              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text('A propriedade tem plantação?'),
                value: _temPlantacao,
                onChanged: (value) => setState(() => _temPlantacao = value),
              ),

              if (_temPlantacao)
                TextField(
                  onChanged: (value) => _tipoFertilizante = value,
                  decoration: const InputDecoration(
                    hintText: 'Qual fertilizante ou agrotóxico usam?',
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text('Eles criam animais na propriedade?'),
                value: _temAnimais,
                onChanged: (value) => setState(() => _temAnimais = value),
              ),

              if (_temAnimais)
                Column(
                  children: [
                    TextField(
                      onChanged: (value) => _tipoAnimais = value,
                      decoration: const InputDecoration(
                        hintText: 'Qual o tipo de criação?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _distanciaAnimais = double.tryParse(value),
                      decoration: const InputDecoration(
                        hintText: 'Distância dos animais para a nascente (em metros)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text('A APP (Área de Preservação Permanente) está preservada?'),
                value: _appPreservada,
                onChanged: (value) => setState(() => _appPreservada = value),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _speakAndNavigate("Indo para Mapa.", const MapaScreen()),
              child: const Icon(Icons.map),
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _speak("Você já está na tela de Relatórios."),
              child: const Icon(Icons.article, color: Colors.blue),
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

  // Simulação de requisição futura para API
  Future<List<String>> _fetchImagesFromApi() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
    ];
  }
}
