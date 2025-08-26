import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:collection';
import 'game_search_screen.dart';
import 'library_screen.dart';
import 'media_screen.dart';
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
  SortMode _sortMode = SortMode.lastAdded;
  int _selectedIndex = 2;
  List<File> _mediaFiles = [];

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
    final mediaPaths = prefs.getStringList('mediaImagePaths') ?? [];
    if (mounted) {
      setState(() {
        _gamerName = prefs.getString('gamerName') ?? 'Gamer';
        _mediaFiles = mediaPaths.map((path) => File(path)).toList();
      });
    }
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      
      final newFiles = pickedFiles.map((file) => File(file.path)).toList();
      _mediaFiles.addAll(newFiles);

      final updatedPaths = _mediaFiles.map((file) => file.path).toList();
      await prefs.setStringList('mediaImagePaths', updatedPaths);
      
      setState(() {});
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

  void _navigateToMediaScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MediaScreen(mediaFiles: _mediaFiles),
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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
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
                    _buildHorizontalGameList(allGames),
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

  Widget _buildHorizontalGameList(List<Game> games) {
    if (games.isEmpty) {
      return const SizedBox(height: 170, child: Center(child: Text("Sua biblioteca está vazia.")));
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

  Widget _buildMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Mídias", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 32,
                width: 32,
                child: ElevatedButton(
                  onPressed: _pickMedia,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Icon(Icons.add, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildMediaGridPreview(),
        ],
      ),
    );
  }

  Widget _buildMediaGridPreview() {
    if (_mediaFiles.isEmpty) {
      return GestureDetector(
        onTap: _pickMedia,
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(12)),
          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate_outlined, size: 40), SizedBox(height: 8), Text("Adicionar mídia")]),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final smallImageSize = (width - 8) / 3;
        final largeImageHeight = smallImageSize * 2 + 8;

        return SizedBox(
          height: largeImageHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.65,
                height: largeImageHeight,
                child: _buildMediaItem(_mediaFiles[0]),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: width * 0.35 - 8,
                child: Column(
                  children: [
                    SizedBox(
                      height: smallImageSize,
                      child: _mediaFiles.length > 1 ? _buildMediaItem(_mediaFiles[1]) : Container(),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: smallImageSize,
                      child: _mediaFiles.length > 2 ? _buildSeeMoreItem(_mediaFiles[2]) : Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaItem(File imageFile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.file(imageFile, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
    );
  }

  Widget _buildSeeMoreItem(File imageFile) {
    return GestureDetector(
      onTap: _navigateToMediaScreen,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(imageFile, fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            const Center(
              child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
            ),
          ],
        ),
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
