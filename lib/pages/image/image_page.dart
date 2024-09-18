import 'dart:io';

import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key, this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: imagePath != null
          ? Image.file(File(imagePath!)) // Display the captured image
          : Text(
        'No Image Captured',
        style: theme.textTheme.titleLarge,
      ),
    );
  }
}
