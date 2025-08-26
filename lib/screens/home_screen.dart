import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:collection';
import 'game_search_screen.dart';
import 'library_screen.dart';
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
  File? _selectedMedia;
  SortMode _sortMode = SortMode.lastAdded;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _loadUserData();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final mediaPath = prefs.getString('mediaImagePath');
    if (mounted) {
      setState(() {
        _gamerName = prefs.getString('gamerName') ?? 'Gamer';
        if (mediaPath != null) {
          _selectedMedia = File(mediaPath);
        }
      });
    }
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mediaImagePath', pickedFile.path);
      setState(() {
        _selectedMedia = File(pickedFile.path);
      });
    }
  }
  
  void _navigateToGameSearch() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameSearchScreen(gamesDao: _database.gamesDao),
    ));
  }
  
  void _navigateToLibraryScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LibraryScreen(database: _database),
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
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Game>>(
          stream: _database.gamesDao.watchAllGamesOrdered(_sortMode),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final allGames = snapshot.data ?? [];
            final userPlatforms = SplayTreeSet<String>.from(allGames
              .where((g) => g.status != 'lista de desejos')
              .map((g) => g.platform)).toList();

            final playingGames = allGames.where((game) => game.status == 'jogando').toList();
            final libraryGames = allGames.where((game) => game.status != 'jogando').toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    // Seção do Perfil
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [ IconButton(icon: const Icon(Icons.logout), onPressed: _logout) ],
                      ),
                    ),
                    const CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://i.imgur.com/8soQJkH.png')),
                    const SizedBox(height: 8),
                    Text(_gamerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildPlatformIndicator(userPlatforms),
                    const SizedBox(height: 24),

                    // Seção 'Jogando'
                    if (playingGames.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildSectionHeader("Jogando"),
                      ),
                      const SizedBox(height: 10),
                      _buildHorizontalGameList(playingGames),
                      const SizedBox(height: 24),
                    ],

                    // Seção Biblioteca
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: _navigateToLibraryScreen,
                            child: const Row(
                              children: [
                                Text("Biblioteca", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, size: 18),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildSortDropdown(),
                              const SizedBox(width: 8),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildHorizontalGameList(libraryGames),
                    const SizedBox(height: 24),
                    
                    _buildMediaSection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Mensagens'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Grupos'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Loja'),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHorizontalGameList(List<Game> games) {
    if (games.isEmpty) {
      return const SizedBox(height: 170, child: Center(child: Text("Nenhum jogo para exibir.")));
    }
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          final game = games[index];
          return InkWell(
            onLongPress: () => _showDeleteConfirmationDialog(game),
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 10),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(game.coverUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image)),
                    Positioned(bottom: 0, left: 0, right: 0, child: GridTileBar(backgroundColor: Colors.black54, title: Text(game.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)))),
                    Positioned(top: 4, left: 4, child: _buildStatusIcon(game.status)),
                    if (game.hoursPlayed != null && game.hoursPlayed! > 0)
                      Positioned(
                        top: 4, right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
                          child: Text('${game.hoursPlayed}H', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 48,
      decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(8.0)),
      child: DropdownButton<SortMode>(
        value: _sortMode,
        onChanged: (SortMode? newValue) {
          if (newValue != null) setState(() => _sortMode = newValue);
        },
        underline: Container(),
        icon: const Icon(Icons.sort),
        items: const [
          DropdownMenuItem(value: SortMode.lastAdded, child: Text("Last Add")),
          DropdownMenuItem(value: SortMode.firstAdded, child: Text("First Add")),
          DropdownMenuItem(value: SortMode.az, child: Text("A - Z")),
          DropdownMenuItem(value: SortMode.platinados, child: Text("Platinados")),
          DropdownMenuItem(value: SortMode.wishlist, child: Text("Wishlist")),
        ],
      ),
    );
  }

  Widget _buildPlatformIndicator(List<String> platforms) {
    if (platforms.isEmpty) return const SizedBox(height: 32);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.center,
        children: platforms.map((platform) => Chip(label: Text(platform))).toList(),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Mídias"),
          const SizedBox(height: 10),
          if (_selectedMedia == null)
            GestureDetector(
              onTap: _pickMedia,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(12)),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate_outlined, size: 40), SizedBox(height: 8), Text("Adicionar mídia")]),
              ),
            )
          else
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(_selectedMedia!, height: 200, width: double.infinity, fit: BoxFit.cover)),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    String icon;
    switch (status) {
      case 'zerado': icon = '✅'; break;
      case 'platinado': icon = '🏆'; break;
      case 'jogando': icon = '▶️'; break;
      case 'na biblioteca': icon = '📘'; break;
      case 'lista de desejos': icon = '📜'; break;
      default: icon = ''; break;
    }
    return Text(icon, style: const TextStyle(fontSize: 18, shadows: [Shadow(blurRadius: 2.0)]));
  }
}
