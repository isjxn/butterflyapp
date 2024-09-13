import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> butterflyData;

  const DetailPage({Key? key, required this.butterflyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(butterflyData['species'] ?? 'Butterfly Details'),
        backgroundColor: const Color.fromARGB(255, 119, 171, 105),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            butterflyData['image'] != null
                ? Image.network(
                    butterflyData['image'],
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 16.0),
            Text(
              butterflyData['species'] ?? 'Unknown Species',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              butterflyData['scientific_name'] ?? 'Unknown Scientific Name',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16.0),
            // Characteristics
            Text(
              'Characteristics',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildCharacteristicItem(
              'Butterfly',
              butterflyData['characteristics']?['butterfly'] ?? 'No information available',
            ),
            _buildCharacteristicItem(
              'Egg',
              butterflyData['characteristics']?['egg'] ?? 'No information available',
            ),
            _buildCharacteristicItem(
              'Caterpillar',
              butterflyData['characteristics']?['caterpillar'] ?? 'No information available',
            ),
            const SizedBox(height: 16.0),
            // Habitat and Lifestyle
            Text(
              'Habitat & Lifestyle',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildCharacteristicItem(
              'Habitat',
              butterflyData['habitat_lifestyle']?['habitat'] ?? 'No information available',
            ),
            _buildCharacteristicItem(
              'Nectar Plants',
              _getListAsString(butterflyData['habitat_lifestyle']?['nectar_plants']),
            ),
            _buildCharacteristicItem(
              'Host Plants',
              _getListAsString(butterflyData['habitat_lifestyle']?['host_plants']),
            ),
            _buildCharacteristicItem(
              'Egg Laying',
              butterflyData['habitat_lifestyle']?['egg_laying'] ?? 'No information available',
            ),
            _buildCharacteristicItem(
              'Caterpillar Habitat',
              butterflyData['habitat_lifestyle']?['caterpillar_habitat'] ?? 'No information available',
            ),
            _buildCharacteristicItem(
              'Pupation',
              butterflyData['habitat_lifestyle']?['pupation'] ?? 'No information available',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacteristicItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getListAsString(dynamic data) {
    if (data is List) {
      return data.join(', ');
    } else if (data is String) {
      return data;
    } else {
      return 'No information available';
    }
  }
}
