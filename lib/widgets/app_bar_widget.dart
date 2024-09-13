import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          const Text(
            'Tagfalter Monitoring',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
