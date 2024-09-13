import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'menupage.dart';
import 'datapage.dart';

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
      title: "Butterfly Demo",
      theme: ThemeData(useMaterial3: true),
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
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  // Firestore reference to the butterflies collection
  final CollectionReference _butterfliesRef =
  FirebaseFirestore.instance.collection('butterflies');

  List<String> _filteredButterflyList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  // Function to handle search logic
  void _onSearchChanged() async {
    setState(() {
      _searchText = _searchController.text.toLowerCase();
    });

    if (_searchText.isNotEmpty) {
      QuerySnapshot querySnapshot = await _butterfliesRef
          .where('name', isGreaterThanOrEqualTo: _searchText)
          .where('name', isLessThanOrEqualTo: '$_searchText\uf8ff')
          .get();

      setState(() {
        _filteredButterflyList = querySnapshot.docs
            .map((doc) => doc['name'] as String)
            .toList();
      });
    } else {
      setState(() {
        _filteredButterflyList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 25, 98, 2),
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: const Color.fromARGB(255, 119, 171, 105),
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: currentPageIndex == 0 ? Colors.white : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  currentPageIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: currentPageIndex == 1 ? Colors.white : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  currentPageIndex = 1;
                });
              },
            ),
            IconButton(
              icon: ImageIcon(
                const AssetImage('assets/images/schmetterling.png'),
                size: 24.0,
                color: currentPageIndex == 2 ? Colors.white : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  currentPageIndex = 2;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.menu,
                color: currentPageIndex == 3 ? Colors.white : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  currentPageIndex = 3;
                });
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 119, 171, 105),
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/schmetterling.png',
              height: 40.0,
            ),
            const SizedBox(width: 10),
            const Text('Tagfalter Monitoring',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      // Body content changes based on current page index
      body: <Widget>[
        // Home page
        Scrollbar(
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
        ),
        // Search page with search bar and list of butterflies
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Suchen schmetterling...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 119, 171, 105),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Display filtered list of butterflies from Firebase
              Expanded(
                child: _filteredButterflyList.isEmpty
                    ? Center(
                  child: Text(
                    'Schmetterling nicht gefunden',
                    style: theme.textTheme.bodyLarge,
                  ),
                )
                    : ListView.builder(
                  itemCount: _filteredButterflyList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredButterflyList[index]),
                      onTap: () {
                        // Add functionality to navigate to a detailed page or action if needed
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Add Image page
        Center(
          child: Text(
            'Bild hinzufügen',
            style: theme.textTheme.titleLarge,
          ),
        ),
        // Data page
        const DataPage(),
        // Menu page
        const MenuPage(),
      ][currentPageIndex],
    );
  }
}
