import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tagfalter_monitoring/firebase_options.dart';
import 'package:tagfalter_monitoring/pages/home/home_page.dart';
import 'package:tagfalter_monitoring/pages/image/image_page.dart';
import 'package:tagfalter_monitoring/pages/search/search_page.dart';

import 'pages/menu/menu_page.dart';
import 'pages/data/data_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ButterflyApp());
}

class ButterflyApp extends StatelessWidget {
  const ButterflyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Butterfly Demo",
      theme: ThemeData(useMaterial3: true),
      home: const MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
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
        const HomePage(),
        SearchPage(searchController:  _searchController, filteredButterflyList: _filteredButterflyList),
        const ImagePage(),
        const DataPage(),
        const MenuPage(),
      ][currentPageIndex],
    );
  }
}
