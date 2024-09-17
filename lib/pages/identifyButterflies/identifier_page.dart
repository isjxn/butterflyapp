import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class IdentifierPage extends StatefulWidget {
  const IdentifierPage({super.key});

  @override
  IdentifierPageState createState() => IdentifierPageState();
}

class IdentifierPageState extends State<IdentifierPage> {
  List<SwipeItem> _swipeItems = [];
  List<String> _butterflyNames = [
    "Butterfly 1",
    "Butterfly 2",
    "Butterfly 3",
    "Butterfly 4",
    "Butterfly 5"
  ];
  late MatchEngine _matchEngine;

  @override
  void initState() {
    super.initState();

    // Initialize swipe items with butterfly names
    for (var name in _butterflyNames) {
      _swipeItems.add(
        SwipeItem(
          content: name,
          likeAction: () {
            // Handle the swipe right action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You liked $name')),
            );
          },
          nopeAction: () {
            // Handle the swipe left action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You disliked $name')),
            );
          },
        ),
      );
    }

    // Initialize match engine with the swipe items
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe to Identify Butterflies'),
        backgroundColor: const Color.fromARGB(255, 119, 171, 105),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      _swipeItems[index].content as String,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              onStackFinished: () {
                // Handle when the card stack is finished
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No more butterflies to show')),
                );
              },
              upSwipeAllowed: false,
              fillSpace: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Dislike button (Swipe Left)
              ElevatedButton(
                onPressed: () {
                  _matchEngine.currentItem?.nope();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red for dislike
                ),
                child: const Icon(Icons.close),
              ),
              // Like button (Swipe Right)
              ElevatedButton(
                onPressed: () {
                  _matchEngine.currentItem?.like();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green for like
                ),
                child: const Icon(Icons.favorite),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
