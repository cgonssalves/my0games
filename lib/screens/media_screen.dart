import 'package:flutter/material.dart';
import 'dart:io';

class MediaScreen extends StatelessWidget {
  final List<File> mediaFiles;

  const MediaScreen({Key? key, required this.mediaFiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mídias'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 fotos por linha
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: mediaFiles.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.file(
              mediaFiles[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
