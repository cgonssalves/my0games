import 'package:flutter/material.dart';
import 'dart:io';
import '../database/database.dart';

class ConfirmMediaScreen extends StatefulWidget {
  final List<File> pickedImages;
  final AppDatabase database;

  const ConfirmMediaScreen({
    Key? key,
    required this.pickedImages,
    required this.database,
  }) : super(key: key);

  @override
  State<ConfirmMediaScreen> createState() => _ConfirmMediaScreenState();
}

class _ConfirmMediaScreenState extends State<ConfirmMediaScreen> {
  List<Game> _userGames = [];
  Game? _selectedGame;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserGames();
  }

  Future<void> _fetchUserGames() async {
    final games = await (widget.database.gamesDao.select(widget.database.games)
          ..where((tbl) => tbl.status.isNotIn(['lista de desejos'])))
        .get();
    if (mounted) {
      setState(() {
        _userGames = games;
      });
    }
  }

  Future<void> _saveMedia() async {
    if (_selectedGame == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um jogo.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    for (final imageFile in widget.pickedImages) {
      final newMedia = MediaItemsCompanion.insert(
        imagePath: imageFile.path,
        gameId: _selectedGame!.id,
      );
      await widget.database.mediaDao.insertMedia(newMedia);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.pickedImages.length} mídia(s) adicionada(s) para ${_selectedGame!.name}!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Mídia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.pickedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.file(widget.pickedImages[index], width: 100, fit: BoxFit.cover),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<Game>(
              value: _selectedGame,
              hint: const Text('Associar a qual jogo?'),
              isExpanded: true,
              items: _userGames.map((game) {
                return DropdownMenuItem(value: game, child: Text(game.name));
              }).toList(),
              onChanged: (Game? newGame) {
                setState(() => _selectedGame = newGame);
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveMedia,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}
