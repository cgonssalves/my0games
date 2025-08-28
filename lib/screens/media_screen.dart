import 'package:flutter/material.dart';
import 'dart:io';
import '../database/database.dart';
import 'photo_view_screen.dart';

class MediaScreen extends StatefulWidget {
  final AppDatabase database;

  const MediaScreen({Key? key, required this.database}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  Game? _selectedGameFilter;

  void _navigateToPhotoView(MediaItem mediaItem) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PhotoViewScreen(
        mediaItem: mediaItem,
        mediaDao: widget.database.mediaDao,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mídias'),
      ),
      body: StreamBuilder<List<Game>>(
        stream: widget.database.gamesDao.watchAllGames(),
        builder: (context, gameSnapshot) {
          if (!gameSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final allGames = gameSnapshot.data ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<Game>(
                  value: _selectedGameFilter,
                  hint: const Text('Filtrar por jogo...'),
                  isExpanded: true,
                  items: allGames.map((game) {
                    return DropdownMenuItem(value: game, child: Text(game.name));
                  }).toList(),
                  onChanged: (Game? newGame) {
                    setState(() => _selectedGameFilter = newGame);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: _selectedGameFilter != null ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _selectedGameFilter = null),
                    ) : null,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<MediaItem>>(
                  stream: widget.database.mediaDao.watchAllMedia(),
                  builder: (context, mediaSnapshot) {
                    if (!mediaSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    var allMedia = mediaSnapshot.data ?? [];

                    if (_selectedGameFilter != null) {
                      allMedia = allMedia.where((media) => media.gameId == _selectedGameFilter!.id).toList();
                    }

                    if (allMedia.isEmpty) {
                      return const Center(child: Text("Nenhuma mídia encontrada."));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: allMedia.length,
                      itemBuilder: (context, index) {
                        final mediaItem = allMedia[index];
                        return GestureDetector(
                          onTap: () => _navigateToPhotoView(mediaItem),
                          child: Image.file(File(mediaItem.imagePath), fit: BoxFit.cover),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
