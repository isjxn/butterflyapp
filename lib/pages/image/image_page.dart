import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Text(
        'Bild hinzufügen',
        style: theme.textTheme.titleLarge,
      ),
    );
  }
}