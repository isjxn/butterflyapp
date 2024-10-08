import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tagfalter_monitoring/pages/identifyButterflies/identifier_page.dart';
import '../detail/detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  final Set<String> _selectedButterflies = {}; // To store the names of selected butterflies

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadUserFavorites(); // Load favorites on init
  }

  // Load the user's favorites from Firebase
  Future<void> _loadUserFavorites() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle the case where the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated')),
      );
      return;
    }

    try {
      final userFavoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final favoritesSnapshot = await userFavoritesRef.get();

      setState(() {
        _selectedButterflies.clear();
        for (var doc in favoritesSnapshot.docs) {
          _selectedButterflies.add(doc.id); // Add the butterfly ID to the selected set
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load favorites: $e')),
      );
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text.toLowerCase();
    });
  }

  Future<void> _toggleSelection(String id, String species, bool isSelected) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated')),
      );
      return;
    }

    try {
      final userFavoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      if (isSelected) {
        // Add the selected butterfly to the user's favorites with its species name
        await userFavoritesRef.doc(id).set({
          'species': species,
        });
        _selectedButterflies.add(id);
      } else {
        // Remove the selected butterfly from the user's favorites
        await userFavoritesRef.doc(id).delete();
        _selectedButterflies.remove(id);
      }

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Butterflies'),
        backgroundColor: const Color.fromARGB(255, 119, 171, 105),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search butterflies...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 119, 171, 105),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            // Button to navigate to the butterfly Identifier
            ElevatedButton(
              onPressed: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ButterflySwipeGame(), // Replace with your new page
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 119, 171, 105),
              ),
              child: const Text('BUTTERFLY IDENTIFIER',
              style: TextStyle(color: Colors.black) ),
            ),
            const SizedBox(height: 20),
            // Display filtered list of butterflies from Firebase
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('butterflies')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  final data = snapshot.requireData;
                  final filteredData = data.docs.where((doc) {
                    final species = (doc['species'] as String?)?.toLowerCase() ?? '';
                    return species.contains(_searchText);
                  }).toList();

                  // Sort the data so that selected items appear at the top
                  filteredData.sort((a, b) {
                    final aId = a.id;
                    final bId = b.id;
                    final aSelected = _selectedButterflies.contains(aId);
                    final bSelected = _selectedButterflies.contains(bId);

                    if (aSelected && !bSelected) return -1;
                    if (!aSelected && bSelected) return 1;
                    return 0;
                  });

                  return filteredData.isEmpty
                      ? Center(
                    child: Text(
                      'No butterflies found',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                      : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var doc = filteredData[index];
                      var butterflyData = doc.data() as Map<String, dynamic>;

                      // Use default values if fields are missing
                      final species = butterflyData['species'] ?? 'Unknown Species';
                      final scientificName = butterflyData['scientific_name'] ?? 'Unknown Scientific Name';
                      final image = butterflyData['image'];
                      final id = doc.id;

                      final isSelected = _selectedButterflies.contains(id);

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: image != null
                              ? Image.network(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : const Placeholder(
                            fallbackHeight: 100,
                            fallbackWidth: 100,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  species,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleSelection(
                                  id,
                                  species, // Pass species name
                                  !isSelected,
                                ),
                                child: Icon(
                                  isSelected ? Icons.star : Icons.star_border,
                                  color: isSelected ? Colors.amber : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(scientificName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  butterflyData: butterflyData,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
