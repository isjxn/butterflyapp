import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> filteredButterflyList;

  const SearchPage({super.key, required this.searchController, required this.filteredButterflyList});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: searchController,
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
            child: filteredButterflyList.isEmpty
                ? Center(
              child: Text(
                'Schmetterling nicht gefunden',
                style: theme.textTheme.bodyLarge,
              ),
            )
                : ListView.builder(
              itemCount: filteredButterflyList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredButterflyList[index]),
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