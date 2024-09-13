import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Willkommen zum Tagfalter Monitoring',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'TMD zur neuen ONLINE-DATENEINGABE (ab 2024)',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Im Frühjahr 2005 startete das Tagfalter-Monitoring in Deutschland. '
                    'Jahr für Jahr erfassen Freiwillige bei wöchentlichen Begehungen entlang '
                    'festgelegter Strecken alle tagaktiven Schmetterlinge. Die gesammelten Daten '
                    'dokumentieren die Entwicklung der Schmetterlingsbestände auf lokaler, '
                    'regionaler und nationaler Ebene und können mit denen anderer europäischer Länder '
                    'verglichen werden, in denen diese Beobachtungen schon seit Jahrzehnten durchgeführt werden.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                'Das Projekt wird von zahlreichen Organisationen unterstützt, darunter NABU, BUND, '
                    'das Bundesamt für Naturschutz (BfN), entomologische Verbände, die Gesellschaft für '
                    'Schmetterlingsschutz sowie die europäische Stiftung Butterfly Conservation Europe.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8), // Reduced space between text and image
              Center(
                child: Image.asset(
                  'assets/images/UFZ_Logo.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 30), // Added space after the logo
            ],
          ),
        ),
      ),
    );
  }
}