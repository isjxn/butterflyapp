import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Flutter code sample for [NavigationBar].

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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 73, 7, 255),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Übersicht',
          ),
          NavigationDestination(
            icon: Icon(Icons.book),
            label: 'Berichte',
          ),
          NavigationDestination(
            icon: Icon(Icons.hdr_plus),
            label: 'Add Button',
          ),
          NavigationDestination(
            icon: Icon(Icons.data_array),
            label: 'Data',
          ),NavigationDestination(
            icon:  Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
      
      body: <Widget>[
        /// Übersicht page
        Card(
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

        /// Bericht page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Bericht Seite',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
/// Add Picture page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Take a picture',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        /// Data page
        const DataPage(), // Data page will fetch Firestore data

        /// Menu page
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
              return ListTile(
                title: Text(doc['species'] ?? 'Unknown Species'), // Display species name
                subtitle: Text(doc['traits'] ?? 'No traits available'), // Display traits
              );
            },
          );
        },
      ),
    );
  }
}