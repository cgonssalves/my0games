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

  // retorna o ícone correto com base no status do jogo
  Widget _buildStatusIcon(String status) {
    String icon;
    switch (status) {
      case 'zerado':
        icon = '✅';
        break;
      case 'platinado':
        icon = '🏆';
        break;
      case 'jogando':
      default:
        icon = '▶️';
        break;
    }
    return Text(icon, style: const TextStyle(fontSize: 20, shadows: [Shadow(blurRadius: 2.0)]));
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
                  child: Stack( 
                    fit: StackFit.expand,
                    children: [
                      // A imagem do jogo
                      Image.network(
                        game.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c,e,s) => const Center(child: Icon(Icons.broken_image, size: 30, color: Colors.grey)),
                      ),
                      // nome na parte inferior
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: GridTileBar(
                          backgroundColor: Colors.black54,
                          title: Text(game.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                        ),
                      ),
                      // ícone de status no canto superior esquerdo
                      Positioned(
                        top: 4, left: 4,
                        child: _buildStatusIcon(game.status),
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
