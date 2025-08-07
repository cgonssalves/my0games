import 'package:flutter/material.dart';
import 'package:my0games/services/game_service.dart'; 

class GameSearchScreen extends StatefulWidget {
  const GameSearchScreen({Key? key}) : super(key: key);

  @override
  _GameSearchScreenState createState() => _GameSearchScreenState();
}

class _GameSearchScreenState extends State<GameSearchScreen> {
  final GameService _gameService = GameService();
  List<Game> _searchResults = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final results = await _gameService.searchGames(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Adicionar Jogo'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Column(
        children: [
          // --- BARRA DE BUSCA ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Digite o nome do jogo...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // --- LISTA DE RESULTADOS ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final game = _searchResults[index];
                      return ListTile(
                        leading: game.imageUrl.isNotEmpty
                            ? Image.network(game.imageUrl, width: 60, fit: BoxFit.cover)
                            : Container(width: 60, color: Colors.grey[800]),
                        title: Text(game.name, style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop(game);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}