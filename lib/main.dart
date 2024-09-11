import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Flutter Beispiel für [NavigationBar].

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NavigationBarApp());
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.purple, // Color principal morado
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple, // Color morado para el AppBar
          foregroundColor: Colors.white, // Color del texto del AppBar
        ),
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  final Color _selectedColor = Colors.purple; // Morado para íconos seleccionados
  final Color _unselectedColor = Colors.purple.withOpacity(0.6); // Morado transparente para íconos no seleccionados

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                setState(() {
                  currentPageIndex = 0;
                });
              },
              color: currentPageIndex == 0
                  ? _selectedColor
                  : _unselectedColor,
              tooltip: 'Übersicht',
            ),
            IconButton(
              icon: const Icon(Icons.book),
              onPressed: () {
                setState(() {
                  currentPageIndex = 1;
                });
              },
              color: currentPageIndex == 1
                  ? _selectedColor
                  : _unselectedColor,
              tooltip: 'Berichte',
            ),
            const SizedBox(width: 48), // Platzhalter für die Kamera-Taste in der Mitte
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                setState(() {
                  currentPageIndex = 3;
                });
              },
              color: currentPageIndex == 3
                  ? _selectedColor
                  : _unselectedColor,
              tooltip: 'Historie',
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt), // Filter-Icon
              onPressed: () {
                setState(() {
                  currentPageIndex = 4; // Wechsel zur Filter-Seite
                });
              },
              color: currentPageIndex == 4
                  ? _selectedColor
                  : _unselectedColor,
              tooltip: 'Filter',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kamera wird geöffnet...')),
          );
        },
        child: const Icon(Icons.camera_alt),
        tooltip: 'Foto machen',
        backgroundColor: _selectedColor, // Hintergrundfarbe des Buttons
        shape: const CircleBorder(), // Macht die Schaltfläche rund
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Inhalt der Seiten
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
          // Übersicht Seite
          Scaffold(
            appBar: AppBar(
              title: const Text('Übersicht Seite'),
            ),
            body: Card(
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Center(
                  child: Text(
                    'Übersicht Seite',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          ),

          // Berichte Seite
          Scaffold(
            appBar: AppBar(
              title: const Text('Berichte Seite'),
            ),
            body: Card(
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Center(
                  child: Text(
                    'Berichte Seite',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          ),

          // Seite für Foto machen
          Scaffold(
            appBar: AppBar(
              title: const Text('Foto machen'),
            ),
            body: Card(
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kamera wird geöffnet...')),
                      );
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Foto machen'),
                  ),
                ),
              ),
            ),
          ),

          // Historie Seite
          Scaffold(
            appBar: AppBar(
              title: const Text('Historie'),
            ),
            body: const HistoriePage(),
          ),

          // Filter Seite
          Scaffold(
            appBar: AppBar(
              title: const Text('Filter und Suche'),
            ),
            body: FilterPage(),
          ),
        ],
      ),
    );
  }
}

// Historie-Seite zeigt die Firestore-Daten an
class HistoriePage extends StatelessWidget {
  const HistoriePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('butterflies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Es ist ein Fehler aufgetreten'));
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              var doc = data.docs[index];
              return ListTile(
                title: Text(doc['species'] ?? 'Unbekannte Art'),
                subtitle: Text(doc['traits'] ?? 'Keine Merkmale verfügbar'),
              );
            },
          );
        },
      ),
    );
  }
}

// Filter-Seite mit Suchfunktion
class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _searchQuery = ''; // Suchabfrage

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value; // Aktualisiert die Suchabfrage
              });
            },
            decoration: InputDecoration(
              labelText: 'Suche nach Namen oder Merkmalen',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('butterflies')
                .where('species', isGreaterThanOrEqualTo: _searchQuery)
                .where('species', isLessThanOrEqualTo: '$_searchQuery\uf8ff') // Fuzzy matching
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Es ist ein Fehler aufgetreten'));
              }

              final data = snapshot.requireData;

              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  var doc = data.docs[index];
                  return ListTile(
                    title: Text(doc['species'] ?? 'Unbekannte Art'),
                    subtitle: Text(doc['traits'] ?? 'Keine Merkmale verfügbar'),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
