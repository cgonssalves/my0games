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
  String? _selectedPlatform;
  final List<String> _platforms = ['PC', 'Xbox', 'Playstation', 'Nintendo'];

  @override
  void initState() {
    super.initState();
    _loadGamerName();
    _loadPlatform(); // MUDANÇA 1: Carrega a plataforma salva ao iniciar
  }

  Future<void> _loadGamerName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _gamerName = prefs.getString('gamerName') ?? 'Jogador';
      });
    }
  }

  // --- MUDANÇA 2: FUNÇÕES DE SALVAR E CARREGAR ADICIONADAS ---
  Future<void> _savePlatform(String platform) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPlatform', platform);
  }

  Future<void> _loadPlatform() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedPlatform = prefs.getString('selectedPlatform');
      });
    }
  }
  // --- FIM DA MUDANÇA 2 ---

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
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white24,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
            ),
            const SizedBox(height: 20),
            Text(
              _gamerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.white24)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPlatform,
                  hint: const Text(
                    'Selecionar plataforma',
                    style: TextStyle(color: Colors.white70),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: _platforms.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  // --- MUDANÇA 3: LÓGICA DE SALVAMENTO ADICIONADA AQUI ---
                  onChanged: (String? newValue) {
                    // Se o usuário não selecionar nada (raro), não fazemos nada.
                    if (newValue == null) return;

                    // Atualiza a tela para mostrar a nova seleção
                    setState(() {
                      _selectedPlatform = newValue;
                    });

                    // Salva a nova escolha na memória do celular
                    _savePlatform(newValue);
                  },
                  // --- FIM DA MUDANÇA 3 ---
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}