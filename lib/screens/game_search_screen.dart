import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
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

  Future<void> _showAddGameDialog(dynamic gameData) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AddGameDialog(gameData: gameData),
    );
    if (result != null) {
      await _saveGame(gameData, result['platform']!, result['status']!);
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _saveGame(dynamic gameData, String platform, String status) async {
    final newGame = GamesCompanion.insert(
      name: gameData['name'] ?? 'Nome desconhecido',
      coverUrl: gameData['background_image'] ?? 'https://via.placeholder.com/300x400.png?text=No+Image',
      platform: platform,
      status: Value(status),
    );
    await widget.gamesDao.insertGame(newGame);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newGame.name.value} adicionado para $platform!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (O build da tela de busca continua o mesmo)
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Jogo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Digite o nome do jogo',
                suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _searchGames),
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
                    onTap: () => _showAddGameDialog(game),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _AddGameDialog extends StatefulWidget {
  final dynamic gameData;
  const _AddGameDialog({required this.gameData});

  @override
  State<_AddGameDialog> createState() => _AddGameDialogState();
}

class _AddGameDialogState extends State<_AddGameDialog> {
  // status inicial 'na biblioteca'
  String _selectedStatus = 'na biblioteca';
  String? _selectedPlatform;
  bool _isChoosingPC = false;

  final List<String> _statusOptions = ['na biblioteca', 'jogando', 'zerado', 'platinado', 'lista de desejos'];
  final List<String> _initialPlatforms = ['PC', 'Playstation', 'Xbox', 'Nintendo'];
  final List<String> _pcPlatforms = ['Steam', 'Epic'];

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.gameData['background_image'];
    final platformsToShow = _isChoosingPC ? _pcPlatforms : _initialPlatforms;

    return AlertDialog(
      title: Text("Adicionar '${widget.gameData['name']}'"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null)
              ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.network(imageUrl, height: 150, fit: BoxFit.cover)),
            const SizedBox(height: 16),
            if (_selectedPlatform == null)
              ...platformsToShow.map((platform) => ElevatedButton(
                onPressed: () {
                  if (platform == 'PC') {
                    setState(() => _isChoosingPC = true);
                  } else {
                    setState(() => _selectedPlatform = platform);
                  }
                },
                child: Text(platform),
              )).toList()
            else ...[
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: _statusOptions.map((status) {
                  // capitaliza a primeira letra para ficar mais organizado
                  String displayText = status.replaceAll('_', ' ');
                  displayText = displayText[0].toUpperCase() + displayText.substring(1);
                  return DropdownMenuItem(value: status, child: Text(displayText));
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedStatus = value);
                },
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _selectedPlatform == null ? null : () {
            Navigator.pop(context, {'platform': _selectedPlatform!, 'status': _selectedStatus});
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
