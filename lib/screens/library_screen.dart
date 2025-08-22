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
  // Navega para a tela de busca de jogos
  void _navigateToGameSearch() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameSearchScreen(gamesDao: widget.database.gamesDao),
    ));
  }

  // Mostra o diálogo de confirmação para deletar um jogo
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green, size: 30),
            tooltip: 'Adicionar Jogo',
            onPressed: _navigateToGameSearch,
          ),
        ],
      ),
      body: StreamBuilder<List<Game>>(
        stream: widget.database.gamesDao.watchAllGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final games = snapshot.data ?? [];
          if (games.isEmpty) {
            return const Center(child: Text("Sua biblioteca está vazia."));
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
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        game.name, 
                        textAlign: TextAlign.center, 
                        style: const TextStyle(fontSize: 11) 
                      ),
                    ),
                    child: Image.network(
                      game.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image, size: 30, color: Colors.grey));
                      },
                    ),
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