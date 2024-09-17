import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'register_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to listen to authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final User? user = snapshot.data;


        // check if user is logged in and retrieve and display user/ email
        String username = user?.displayName ?? user?.email ?? 'Anonymous';

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Menu'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Account Section
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user == null ? 'Login' : 'Logout'), // Show "Login" or "Logout" based on user status
            subtitle: user != null ? Text('Logged in as $username'): null,
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
            trailing: const Icon(Icons.chevron_right),
          ),
           if (user == null) // Only show the "Register" option if not logged in
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Register'),
            onTap: () {
               Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(), // Separator for sections

          // Settings Section
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              'TODO: Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('App'),
            onTap: () {
              // Navigate to App Settings
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),

          // Info Section
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              'TODO: Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('How to use'),
            onTap: () {
              // Navigate to Help
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              // Navigate to Help
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              // Navigate to Help
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Imprint'),
            onTap: () {
              // Navigate to Credits
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Navigate to Privacy Policy
            },
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ));
    });
  }}