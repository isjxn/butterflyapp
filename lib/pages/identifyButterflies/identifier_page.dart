import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class ButterflySwipeGame extends StatefulWidget {
  const ButterflySwipeGame({Key? key}) : super(key: key);

  @override
  _ButterflySwipeGameState createState() => _ButterflySwipeGameState();
}

class _ButterflySwipeGameState extends State<ButterflySwipeGame> {
  List<DocumentSnapshot> butterflyList = [];
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];
  final List<String> _characteristicsKeys = [
    'color_black',
    'color_yellow',
    'has_spots',
    'has_pickles',
    'wing_shape_pointy',
  ];

  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadButterfliesFromFirebase();
  }

  // Load butterfly data from Firestore
  Future<void> _loadButterfliesFromFirebase() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('butterflies')
          .get();

      setState(() {
        butterflyList = snapshot.docs;
        _initializeSwipeItems(); // Initialize swipe items with all questions
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load butterflies: $e')),
      );
    }
  }

  // Initialize swipe items for SwipeCards
  void _initializeSwipeItems() {
    _swipeItems = _characteristicsKeys.map((questionKey) {
      return SwipeItem(
        content: _formatQuestion(questionKey),
        likeAction: () {
          _onSwipeYes(questionKey);
        },
        nopeAction: () {
          _onSwipeNo(questionKey);
        },
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    setState(() {}); // Trigger UI update
  }

  // Swipe right (Yes) to filter butterflies based on the current question
  void _onSwipeYes(String questionKey) {
    setState(() {
      butterflyList = butterflyList.where((doc) {
        final characteristics = doc['questionnaire_charachteristics'] ?? {};
        return characteristics[questionKey] == true;
      }).toList();

      _tryIdentifyButterfly(); // Check if we can identify the butterfly
    });
  }

  // Swipe left (No) to filter butterflies based on the current question
  void _onSwipeNo(String questionKey) {
    setState(() {
      butterflyList = butterflyList.where((doc) {
        final characteristics = doc['questionnaire_charachteristics'] ?? {};
        return characteristics[questionKey] == false;
      }).toList();

      _tryIdentifyButterfly(); // Check if we can identify the butterfly
    });
  }

  // Try to identify the butterfly after all the questions
  void _tryIdentifyButterfly() {
    if (butterflyList.length == 1) {
      _endGameSuccess(butterflyList.first);
    } else if (butterflyList.isEmpty) {
      _endGameNoMatch();
    } else {
      _endGameMultipleMatches();
    }
  }

  // End the game when only one butterfly is identified
  void _endGameSuccess(DocumentSnapshot butterfly) {
    final species = butterfly['species'] ?? 'Unknown species';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('The butterfly is: $species')),
    );
  }

  // End the game when no butterflies match
  void _endGameNoMatch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No butterfly matches your description.')),
    );
  }

  // End the game when multiple butterflies still match after all questions
  void _endGameMultipleMatches() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Could not identify the butterfly with certainty.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butterfly Identifier'),
        backgroundColor: const Color.fromARGB(255, 119, 171, 105),
      ),
      body: _swipeItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      _swipeItems[index].content,
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              onStackFinished: _tryIdentifyButterfly, // Try to identify after all cards
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Swipe right for YES, left for NO",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper method to format the question string
  String _formatQuestion(String key) {
    if (key.startsWith('color_')) {
      return "Is it ${key.replaceFirst('color_', '')}?";
    } else if (key == 'has_spots') {
      return "Does it have spots?";
    } else if (key == 'has_pickles') {
      return "Does it have pickles?";
    } else if (key == 'wing_shape_pointy') {
      return "Are the wings pointy?";
    }
    return key;
  }
}
