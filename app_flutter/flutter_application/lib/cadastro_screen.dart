import 'package:flutter/material.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registre-se',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Crie a sua conta para começar a usar',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Campo Nome
            const Text('Nome'),
            TextField(
              decoration: InputDecoration(
                hintText: 'Digite seu nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Campo CPF
            const Text('CPF'),
            TextField(
              decoration: InputDecoration(
                hintText: 'Digite seu CPF', 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Campo Senha
            const Text('Senha'),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Digite sua senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Campo Confirmar Senha
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirme sua senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? value) {},
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

            SizedBox(
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
          ],
        ),
      ),
    );
  }
}