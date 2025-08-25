import 'package:flutter/material.dart';
import '../database/database.dart';
import 'game_search_screen.dart';

class LibraryScreen extends StatefulWidget {
  final AppDatabase database;
  const LibraryScreen({Key? key, required this.database}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  SortMode _sortMode = SortMode.lastAdded;

  void _navigateToGameSearch() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameSearchScreen(gamesDao: widget.database.gamesDao),
    ));
  }

  void _showDeleteConfirmationDialog(Game game) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content: Text("Deseja remover '${game.name}' da sua biblioteca?"),
        actions: [
          TextButton(child: const Text("Cancelar"), onPressed: () => Navigator.of(context).pop()),
          TextButton(
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            onPressed: () {
              widget.database.gamesDao.deleteGame(game);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
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
    return Text(icon, style: const TextStyle(fontSize: 20, shadows: [Shadow(blurRadius: 2.0)]));
  }

  Widget _buildSortDropdown() {
    return DropdownButton<SortMode>(
      value: _sortMode,
      onChanged: (SortMode? newValue) {
        if (newValue != null) setState(() => _sortMode = newValue);
      },
      underline: Container(),
      icon: const Icon(Icons.sort, color: Colors.white),
      dropdownColor: Colors.grey[800],
      items: const [
        DropdownMenuItem(value: SortMode.lastAdded, child: Text("Last Add")),
        DropdownMenuItem(value: SortMode.firstAdded, child: Text("First Add")),
        DropdownMenuItem(value: SortMode.az, child: Text("A - Z")),
        DropdownMenuItem(value: SortMode.platinados, child: Text("Platinados")),
        DropdownMenuItem(value: SortMode.wishlist, child: Text("Wishlist")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca'),
        actions: [
          _buildSortDropdown(),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green, size: 30),
            tooltip: 'Adicionar Jogo',
            onPressed: _navigateToGameSearch,
          ),
        ],
      ),
      body: StreamBuilder<List<Game>>(
        stream: widget.database.gamesDao.watchAllGamesOrdered(_sortMode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final games = snapshot.data ?? [];
          if (games.isEmpty) {
            return Center(child: Text(
              _sortMode == SortMode.wishlist 
                ? "Sua lista de desejos está vazia."
                : "Sua biblioteca está vazia."
            ));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              crossAxisSpacing: 10.0, 
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.7, 
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return InkWell(
                onLongPress: () => _showDeleteConfirmationDialog(game),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        game.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c,e,s) => const Center(child: Icon(Icons.broken_image, size: 30, color: Colors.grey)),
                      ),
                      Positioned(bottom: 0, left: 0, right: 0, child: GridTileBar(backgroundColor: Colors.black54, title: Text(game.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)))),
                      Positioned(top: 4, left: 4, child: _buildStatusIcon(game.status)),
                      // --- WIDGET PARA MOSTRAR AS HORAS ---
                      if (game.hoursPlayed != null && game.hoursPlayed! > 0)
                        Positioned(
                          top: 4, right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${game.hoursPlayed}H',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
