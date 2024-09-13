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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBody: true, // Ensures FAB extends over the bottom app bar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your functionality here
        },
        backgroundColor: const Color.fromARGB(255, 25, 98, 2), // Change button background color
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
                color: Colors.black,
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
                setState(() {
                currentPageIndex = 4; // Navigate to the "Menu" page
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
              'assets/images/schmetterling.png', // Replace with your actual logo
              height: 40.0,
            ),
            const SizedBox(width: 10),
            const Text('Tagfalter Monitoring', style: TextStyle(color: Colors.black)),
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
        // DataPage (now coming from datapage.dart)
        const DataPage(),  
        // MenuPage (from menupage.dart)
        const MenuPage(), // Load MenuPage
      ][currentPageIndex],
    );
  }
}

