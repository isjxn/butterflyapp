import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 25, 98, 2),
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your actual logo
              height: 40.0,
            ),
            const SizedBox(width: 10),
            const Text('Your App Title', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Login'),
            onTap: () {
              // Add your login functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text('Register'),
            onTap: () {
              // Add your register functionality
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings
            },
          ),
          const Divider(),
          ExpansionTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Info'),
            children: [
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Anleitung (Guide)'),
                onTap: () {
                  // Navigate to Guide page
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Hilfe (Help)'),
                onTap: () {
                  // Navigate to Help page
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Über Impressum (Imprint)'),
                onTap: () {
                  // Navigate to Imprint page
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Datenschutz (Privacy Policy)'),
                onTap: () {
                  // Navigate to Privacy Policy page
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
