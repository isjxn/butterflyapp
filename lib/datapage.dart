import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// todo: create seperate datapage.dart
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
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: doc['image'] != null
                      ? Image.network(
                          doc['image'],
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : const Placeholder(),
                  title: Text(doc['species'] ?? 'Unknown Species'), // Display species name
                  subtitle: Text(doc['traits'] ?? 'No traits available'), // Display traits
                ),);
            },
          );
        },
      ),
    );
  }
}
