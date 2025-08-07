import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my0games/screens/login_screen.dart';
import 'package:my0games/screens/game_search_screen.dart';
import 'package:my0games/services/game_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- VARIÁVEIS DE ESTADO ---
  String _gamerName = 'Carregando...';
  String? _selectedPlatform;
  final List<String> _platforms = ['PC', 'Xbox', 'Playstation', 'Nintendo'];
  List<Game> _library = [];

  // --- INICIALIZAÇÃO DA TELA ---
  @override
  void initState() {
    super.initState();
    _loadGamerName();
    _loadPlatform();
    _loadLibrary();
  }

  Future<void> _loadGamerName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _gamerName = prefs.getString('gamerName') ?? 'Jogador';
      });
    }
  }

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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _saveLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> libraryJson = _library.map((game) => json.encode(game.toJson())).toList();
    await prefs.setStringList('gameLibrary', libraryJson);
  }

  Future<void> _loadLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? libraryJson = prefs.getStringList('gameLibrary');
    if (libraryJson != null) {
      setState(() {
        _library = libraryJson.map((gameJson) => Game.fromJson(json.decode(gameJson))).toList();
      });
    }
  }

  void _navigateAndAddGame(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameSearchScreen()),
    );

    if (result != null && result is Game) {
      // Evita adicionar jogos duplicados
      if (!_library.any((game) => game.id == result.id)) {
        setState(() {
          _library.add(result);
        });
        _saveLibrary();
      }
    }
  }

  // --- CONSTRUÇÃO DA INTERFACE (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- PARTE SUPERIOR (PERFIL) ---
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white24,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
            ),
            const SizedBox(height: 20),
            Text(
              _gamerName,
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.white24)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPlatform,
                  hint: const Text('Selecionar plataforma', style: TextStyle(color: Colors.white70)),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: _platforms.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue == null) return;
                    setState(() { _selectedPlatform = newValue; });
                    _savePlatform(newValue);
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- SEÇÃO BIBLIOTECA ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Biblioteca', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _navigateAndAddGame(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Adicionar Game'),
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.grey[800]),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- GRADE DE JOGOS ---
            Expanded(
              child: _library.isEmpty
                  ? const Center(
                      child: Text("Sua biblioteca está vazia.\nAdicione um jogo!",
                          textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 16)))
                  : GridView.builder(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 20.0),
                      itemCount: _library.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final game = _library[index];
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(game.imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[850],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}