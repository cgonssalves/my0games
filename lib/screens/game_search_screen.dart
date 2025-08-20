import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/database.dart';

class GameSearchScreen extends StatefulWidget {
  final GamesDao gamesDao;
  const GameSearchScreen({Key? key, required this.gamesDao}) : super(key: key);

  @override
  State<GameSearchScreen> createState() => _GameSearchScreenState();
}

class _GameSearchScreenState extends State<GameSearchScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchGames() async {
    if (_searchController.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() { _isLoading = true; _searchResults = []; });

    const apiKey = 'ab7212e032af4985883bddabb6d95c72';
    final query = Uri.encodeComponent(_searchController.text.trim());
    final url = Uri.parse('https://api.rawg.io/api/games?key=$apiKey&search=$query');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _searchResults = data['results'] ?? []);
      } else {
        _showError('Erro ao buscar jogos: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Erro de conexão. Verifique sua internet.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _showPlatformChoice(dynamic gameData) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _PlatformSelectionContent(
          gameData: gameData,
          onPlatformSelected: (platform) {
            _saveGame(gameData, platform);
          },
        );
      },
    );
  }

  Future<void> _saveGame(dynamic gameData, String platform) async {
    final newGame = GamesCompanion.insert(
      name: gameData['name'] ?? 'Nome desconhecido',
      coverUrl: gameData['background_image'] ?? 'https://via.placeholder.com/300x400.png?text=No+Image',
      platform: platform,
    );

    await widget.gamesDao.insertGame(newGame);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newGame.name.value} adicionado para $platform!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Jogo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Digite o nome do jogo',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchGames,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchGames(),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_searchResults.isEmpty)
             Expanded(child: Center(child: Text(_searchController.text.isEmpty ? 'Digite algo para buscar.' : 'Nenhum resultado encontrado.')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final game = _searchResults[index];
                  final imageUrl = game['background_image'];
                  return ListTile(
                    leading: imageUrl != null
                        ? Image.network(imageUrl, width: 50, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.image_not_supported))
                        : const Icon(Icons.image_not_supported),
                    title: Text(game['name'] ?? 'Sem nome'),
                    subtitle: Text('Lançamento: ${game['released'] ?? 'N/A'}'),
                    onTap: () => _showPlatformChoice(game),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// --- WIDGET INTERNO PARA GERENCIAR A SELEÇÃO ---
class _PlatformSelectionContent extends StatefulWidget {
  final dynamic gameData;
  final Function(String) onPlatformSelected;

  const _PlatformSelectionContent({required this.gameData, required this.onPlatformSelected});

  @override
  State<_PlatformSelectionContent> createState() => _PlatformSelectionContentState();
}

class _PlatformSelectionContentState extends State<_PlatformSelectionContent> {
  bool _isChoosingPC = false;

  final List<String> _initialPlatforms = ['PC', 'Playstation', 'Xbox', 'Nintendo'];
  final List<String> _pcPlatforms = ['Steam', 'Epic'];

  @override
  Widget build(BuildContext context) {
    final title = "Adicionar '${widget.gameData['name']}' para qual plataforma?";
    final platformsToShow = _isChoosingPC ? _pcPlatforms : _initialPlatforms;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ...platformsToShow.map((platform) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  if (platform == 'PC') {
                    setState(() {
                      _isChoosingPC = true;
                    });
                  } else {
                    Navigator.pop(context);
                    widget.onPlatformSelected(platform);
                  }
                },
                child: Text(platform),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}