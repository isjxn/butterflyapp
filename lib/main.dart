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
          const SearchPage(), // Updated to remove dependencies
          const ImagePage(),
          const DataPage(),
          const MenuPage(),
        ][currentPageIndex],
      ),
    );
  }
}
