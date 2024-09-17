import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'register_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to listen to authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final User? user = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Menu'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(user == null ? 'Login' : 'Logout'), // Show "Login" or "Logout" based on user status
                onTap: () {
                  if (user == null) {
                    // If the user is not logged in, navigate to the LoginPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  } else {
                    // If the user is logged in, just navigate to LoginPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
              ),
              if (user == null) // Only show the "Register" option if not logged in
                ListTile(
                  leading: const Icon(Icons.app_registration),
                  title: const Text('Register'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('TODO: Settings'),
                onTap: () {
                  // Add settings navigation functionality
                },
              ),
              const Divider(),
              ExpansionTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('TODO: Info'),
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
      },
    );
  }
}
