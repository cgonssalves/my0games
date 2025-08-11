import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_search_screen.dart';
import '../database/database.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDatabase _database;
  late Stream<List<Game>> _gamesStream;
  String _gamerName = "Carregando...";

  final List<String> _platforms = ['PC', 'Xbox', 'Playstation', 'Nintendo'];
  String _selectedPlatform = 'PC';

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _loadUserData();
    _updateGamesStream();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gamerName = prefs.getString('gamerName') ?? 'Gamer';
    });
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
  
  void _updateGamesStream() {
    setState(() {
      _gamesStream = _database.gamesDao.watchGamesByPlatform(_selectedPlatform);
    });
  }

  void _navigateToGameSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameSearchScreen(gamesDao: _database.gamesDao),
      ),
    );
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: Text("Deseja remover '${game.name}'?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
              onPressed: () {
                _database.gamesDao.deleteGame(game);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Sair',
                  onPressed: _logout,
                ),
              ],
            ),

            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.imgur.com/8soQJkH.png'), 
            ),
            const SizedBox(height: 12),
            Text(
              _gamerName, 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),


            // --- SELETOR DE PLATAFORMA ---
            DropdownButtonFormField<String>(
              value: _selectedPlatform,
              items: _platforms.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPlatform = value;
                    _updateGamesStream();
                  });
                }
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            
            // --- TÍTULO DA BIBLIOTECA ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Biblioteca", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Adicionar"),
                  onPressed: _navigateToGameSearch,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // --- GRADE DE JOGOS ---
            Expanded(
              child: _buildGameLibraryGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameLibraryGrid() {
    return StreamBuilder<List<Game>>(
      stream: _gamesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final games = snapshot.data ?? [];
        if (games.isEmpty) {
          return Center(child: Text("Nenhum jogo para '$_selectedPlatform'."));
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return InkWell(
              onLongPress: () => _showDeleteConfirmationDialog(game),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(game.name, textAlign: TextAlign.center),
                  ),
                  child: Image.network(
                    game.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}