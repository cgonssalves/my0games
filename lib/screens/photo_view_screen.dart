import 'package:flutter/material.dart';
import 'dart:io';
import '../database/database.dart';

class PhotoViewScreen extends StatelessWidget {
  final MediaItem mediaItem;
  final MediaDao mediaDao;

  const PhotoViewScreen({
    Key? key,
    required this.mediaItem,
    required this.mediaDao,
  }) : super(key: key);

  Future<void> _deleteMedia(BuildContext context) async {
    // Mostra um diálogo de confirmação antes de apagar
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar Mídia'),
        content: const Text('Tem a certeza de que quer apagar esta foto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Apagar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await mediaDao.deleteMedia(mediaItem);
      if (context.mounted) {
        Navigator.pop(context); // Fecha a tela de visualização
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Imagem com zoom
          Center(
            child: InteractiveViewer(
              child: Image.file(File(mediaItem.imagePath)),
            ),
          ),
          // Botão de apagar
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => _deleteMedia(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Apagar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
