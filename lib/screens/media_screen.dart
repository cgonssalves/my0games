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
        padding: const EdgeInsets.all(4.0), 
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0, 
          mainAxisSpacing: 4.0,
        ),
        itemCount: mediaFiles.length,
        itemBuilder: (context, index) {
          return Image.file(
            mediaFiles[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
