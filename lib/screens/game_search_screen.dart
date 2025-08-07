import 'package:flutter/material.dart';
import '../database/database.dart';
import '../services/game_service.dart' as game_service;

class GameSearchScreen extends StatefulWidget {
  final GamesDao gamesDao;

  const GameSearchScreen({
    Key? key,
    required this.gamesDao,
  }) : super(key: key);

  @override
  State<GameSearchScreen> createState() => _GameSearchScreenState();
}

class _GameSearchScreenState extends State<GameSearchScreen> {
  final _searchController = TextEditingController();
  final _gameService = game_service.GameService();
  List<game_service.Game> _searchResults = [];
  bool _isLoading = false;
  String _message = "Digite o nome de um jogo para buscar.";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    FocusScope.of(context).unfocus();
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _message = '';
      _searchResults = [];
    });

    try {
      final results = await _gameService.searchGames(query);
      setState(() {
        _searchResults = results;
        if (results.isEmpty) {
          _message = "Nenhum jogo encontrado com o nome '$query'.";
        }
      });
    } catch (e) {
      setState(() {
        _message = "Ocorreu um erro ao buscar. Tente novamente.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addGameToLibrary(game_service.Game gameFromService) async {
    final gameToInsert = Game(
      id: 0, // O ID é auto-gerado pelo banco
      name: gameFromService.name,
      // AJUSTE 1: Usando o nome correto do campo: 'imageUrl'
      coverUrl: gameFromService.imageUrl,
      // AJUSTE 2: Como não temos plataforma, definimos um valor padrão.
      platform: 'Não definida',
    );

    await widget.gamesDao.insertGame(gameToInsert);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('${gameToInsert.name} foi adicionado à sua biblioteca!'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Novo Jogo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Nome do jogo',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: _buildResultsArea(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsArea() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_searchResults.isNotEmpty) {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final game = _searchResults[index];
          return Card(
            child: ListTile(
              onTap: () => _addGameToLibrary(game),
              // AJUSTE 3: Usando o nome correto 'imageUrl' para a imagem.
              leading: Image.network(game.imageUrl, width: 50, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image), // fallback
              ),
              title: Text(game.name),
              // AJUSTE 4: Como não temos plataforma, podemos colocar uma dica.
              subtitle: Text('Toque para adicionar'),
            ),
          );
        },
      );
    }
    return Center(child: Text(_message));
  }
}