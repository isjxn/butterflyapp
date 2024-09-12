import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBody: true, // Ensures FAB extends over the bottom app bar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your functionality here
        },
        backgroundColor: const Color.fromARGB(255, 37, 150, 3), // Change button background color
        foregroundColor: Colors.black, 
        shape: const CircleBorder(),
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // BottomAppBar with custom buttons
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: const Color.fromARGB(255, 119, 171, 105),
        shape: const CircularNotchedRectangle(), // Allows FAB to notch into BottomAppBar
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  currentPageIndex = 0; // Navigate to the "Übersichts" page
                });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  currentPageIndex = 1; // Navigate to the "Bericht" page
                });
              },
            ),
            IconButton(
              icon: const ImageIcon(
                AssetImage('assets/images/schmetterling.png'),  // Path to your custom icon
                size: 24.0,  // Adjust the size as needed
                // change color to black
              ),
            onPressed: () {
              setState(() {
                currentPageIndex = 3; // Navigate to the "Data" page
              });
            },
          ),
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                // Add your print functionality here
              },
            ),
          ],
        ),
      ),
      
      // Body content changes based on current page index
      body: <Widget>[
        // Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home Page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
        // Search page, search via traits -> boolean
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Search Page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
        // todo: Camera integation here
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Add Image Page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
        // Data from Firebase
        const DataPage(),  
        // Menu page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Menu Page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }
}

class DataPage extends StatelessWidget {
  const DataPage({Key? key}) : super(key: key);

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
            return const Center(child: Text('Something went wrong'));
          }

          // If data is available
          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              var doc = data.docs[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: doc['image'] != null
                      ? Image.network(
                          doc['image'],
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : const Placeholder(),
                  title: Text(doc['species'] ?? 'Unknown Species'), // Display species name
                  subtitle: Text(doc['traits'] ?? 'No traits available'), // Display traits
                ),);
            },
          );
        },
      ),
    );
  }
}
