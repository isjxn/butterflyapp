// bottom_navigation_bar.dart
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentPageIndex;
  final Function(int) onPageSelected;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentPageIndex,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              // Call the callback to notify the parent widget (ButterflyAppState)
              onPageSelected(0);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: currentPageIndex == 1 ? Colors.white : Colors.black,
            ),
            onPressed: () {
              onPageSelected(1);
            },
          ),
          IconButton(
            icon: ImageIcon(
              const AssetImage('assets/images/schmetterling.png'),
              size: 24.0,
              color: currentPageIndex == 2 ? Colors.white : Colors.black,
            ),
            onPressed: () {
              onPageSelected(2);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.menu,
              color: currentPageIndex == 3 ? Colors.white : Colors.black,
            ),
            onPressed: () {
              onPageSelected(3);
            },
          ),
        ],
      ),
    );
  }
}
