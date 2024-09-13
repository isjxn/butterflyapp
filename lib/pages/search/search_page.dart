import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  List<String> _filteredButterflyList = [];

  final CollectionReference _butterfliesRef =
  FirebaseFirestore.instance.collection('butterflies');

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
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Suchen schmetterling...',
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
          const SizedBox(height: 20),
          // Display filtered list of butterflies from Firebase
          Expanded(
            child: _filteredButterflyList.isEmpty
                ? Center(
              child: Text(
                'Schmetterling nicht gefunden',
                style: theme.textTheme.bodyLarge,
              ),
            )
                : ListView.builder(
              itemCount: _filteredButterflyList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredButterflyList[index]),
                  onTap: () {
                    // Add functionality to navigate to a detailed page or action if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
