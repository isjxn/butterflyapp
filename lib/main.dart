import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tagfalter_monitoring/firebase_options.dart';
import 'package:tagfalter_monitoring/pages/home/home_page.dart';
import 'package:tagfalter_monitoring/pages/image/image_page.dart';
import 'package:tagfalter_monitoring/pages/search/search_page.dart';
import 'package:tagfalter_monitoring/widgets/bottom_navigation_bar_widget.dart';
import 'package:tagfalter_monitoring/widgets/app_bar_widget.dart'; // Import the new AppBar widget

import 'pages/menu/menu_page.dart';
import 'pages/data/data_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ButterflyApp());
}

class ButterflyApp extends StatefulWidget {
  const ButterflyApp({super.key});

  @override
  State<ButterflyApp> createState() => ButterflyAppState();
}

class ButterflyAppState extends State<ButterflyApp> {
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
    return MaterialApp(
      title: "Butterfly Demo",
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        extendBody: true,

        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color.fromARGB(255, 25, 98, 2),
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          child: const Icon(Icons.camera_alt),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: BottomNavigationBarWidget(
          currentPageIndex: currentPageIndex,
          onPageSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),

        appBar: const AppBarWidget(),

        body: <Widget>[
          const HomePage(),
          SearchPage(
            searchController: _searchController,
            filteredButterflyList: _filteredButterflyList,
          ),
          const ImagePage(),
          const DataPage(),
          const MenuPage(),
        ][currentPageIndex],
      ),
    );
  }
}
