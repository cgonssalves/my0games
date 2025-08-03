import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o pacote
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String gamerName;

  const HomeScreen({Key? key, required this.gamerName}) : super(key: key);

  // A função de logout agora também é assíncrona
  Future<void> _logout(BuildContext context) async {
    // 1. Acessa a "caixinha" de preferências
    final prefs = await SharedPreferences.getInstance();
    
    // 2. Limpa os dados salvos
    await prefs.clear(); // O .clear() apaga tudo que salvamos

    // Garante que o widget ainda está montado antes de navegar
    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Botão de Logout (Sair)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo(a) de volta,',
              style: TextStyle(color: Colors.grey[400], fontSize: 22),
            ),
            Text(
              gamerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Minhas Métricas',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const Divider(color: Colors.green),
            
            // Espaço para a lista de métricas no futuro
            Expanded(
              child: Center(
                child: Text(
                  'Você ainda não adicionou nenhuma métrica.\nClique no botão + para começar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      // Botão flutuante para adicionar novas métricas
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aqui vamos adicionar a lógica para abrir uma tela de "Adicionar Métrica"
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionalidade a ser implementada!')),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}