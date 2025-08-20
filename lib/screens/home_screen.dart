import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection'; 
import '../database/database.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDatabase _database;
  String _gamerName = "Carregando...";

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if(mounted) {
      setState(() {
        _gamerName = prefs.getString('gamerName') ?? 'Gamer';
      });
    }
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
  
  void _navigateToGameSearch() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameSearchScreen(gamesDao: _database.gamesDao),
    ));
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _database.gamesDao.clearAllDataForLogout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _showDeleteConfirmationDialog(Game game) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content: Text("Deseja remover '${game.name}'?"),
        actions: [
          TextButton(child: const Text("Cancelar"), onPressed: () => Navigator.of(context).pop()),
          TextButton(
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            onPressed: () {
              _database.gamesDao.deleteGame(game);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Game>>(
          stream: _database.gamesDao.watchAllGames(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final allGames = snapshot.data ?? [];
            final userPlatforms = SplayTreeSet<String>.from(allGames.map((g) => g.platform)).toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [ IconButton(icon: const Icon(Icons.logout), onPressed: _logout) ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://i.imgur.com/8soQJkH.png'), 
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _gamerName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildPlatformIndicator(userPlatforms),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Biblioteca", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: _navigateToGameSearch,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(Icons.add, size: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildGameLibraryList(allGames),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlatformIndicator(List<String> platforms) {
    if (platforms.isEmpty) {
      return const SizedBox(height: 32); // Retorna um espaço vazio se não houver plataformas
    }
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: platforms.map((platform) => Chip(label: Text(platform))).toList(),
      ),
    );
  }

  Widget _buildGameLibraryList(List<Game> games) {
    if (games.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("Sua biblioteca está vazia. Adicione um jogo!"))
      );
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          final game = games[index];
          return InkWell(
            onLongPress: () => _showDeleteConfirmationDialog(game),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 10),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(game.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                  ),
                  child: Image.network(game.coverUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}