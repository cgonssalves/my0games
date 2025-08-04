import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Garanta que a importação está correta

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _gamerName = 'Carregando...';

  // --- NOSSAS NOVAS VARIÁVEIS DE ESTADO ---
  // A plataforma selecionada (nullable, pois pode começar vazia)
  String? _selectedPlatform;
  // A lista de opções de plataformas
  final List<String> _platforms = ['PC', 'Xbox', 'Playstation', 'Nintendo'];
  // ------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadGamerName();
  }

  Future<void> _loadGamerName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gamerName = prefs.getString('gamerName') ?? 'Jogador';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
      // --- MUDANÇA NO LAYOUT PRINCIPAL ---
      // Usamos um Column com Padding para ter controle total
      body: Container(
        // Garante que a coluna ocupe toda a largura
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          // Alinha os itens no centro HORIZONTALMENTE
          crossAxisAlignment: CrossAxisAlignment.center,
          // Alinha os itens no TOPO VERTICALMENTE
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Espaço do topo

            // Círculo para a foto de perfil
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white24,
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
            const SizedBox(height: 40), // Espaço maior antes do botão

            // --- NOSSO NOVO SELETOR DE PLATAFORMA ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), // Cor do retângulo
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.white24) // Borda sutil
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPlatform,
                  // O texto que aparece quando nada foi selecionado
                  hint: const Text(
                    'Selecionar plataforma',
                    style: TextStyle(color: Colors.white70),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  // Mapeia nossa lista de strings para uma lista de itens de menu
                  items: _platforms.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  // O que acontece quando o usuário seleciona um item
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPlatform = newValue;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}