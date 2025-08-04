import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Garanta que a importação está correta

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _gamerName = 'Carregando...'; // Valor inicial enquanto busca os dados

  @override
  void initState() {
    super.initState();
    _loadGamerName(); // Carrega o nome do usuário ao iniciar a tela
  }

  // Função para buscar o nome do SharedPreferences
  Future<void> _loadGamerName() async {
    final prefs = await SharedPreferences.getInstance();
    // Busca o nome salvo; se não encontrar, usa 'Jogador' como padrão
    setState(() {
      _gamerName = prefs.getString('gamerName') ?? 'Jogador';
    });
  }

  // Função de Logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todos os dados salvos

    // Navega de volta para a tela de login
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Círculo para a foto de perfil
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white24,
              // Usamos uma imagem da rede como placeholder
              backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=a042581f4e29026704d'),
            ),
            const SizedBox(height: 20),

            // Nome do Gamer
            Text(
              _gamerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Um subtítulo de exemplo
            const Text(
              'Mestre das Métricas',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}