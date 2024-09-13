import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../detail/detail_page.dart';

class DataPage extends StatelessWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butterfly Species'),
        backgroundColor: const Color.fromARGB(255, 119, 171, 105),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('butterflies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              var doc = data.docs[index];
              var butterflyData = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: butterflyData['image'] != null
                      ? Image.network(
                          butterflyData['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : const Placeholder(
                          fallbackHeight: 100,
                          fallbackWidth: 100,
                        ),
                  title: Text(butterflyData['species'] ?? 'Unknown Species'),
                  subtitle: Text(butterflyData['scientific_name'] ?? 'Unknown Scientific Name'),
                  onTap: () {
                    // Navigate to detail page on tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(butterflyData: butterflyData),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
