// Import necessary Flutter and Firestore packages.
import 'package:cloud_firestore/cloud_firestore.dart'; // Access Firestore for remote data storage.
import 'package:flutter/material.dart'; // Import Material widgets and functionality.
import 'package:flip_card/flip_card.dart'; // Import for card flipping animations.
import '../database_helper.dart'; // Local database helper for SQLite operations.
import '../globals.dart' as globals; // Global variables for storing app-wide data.
import 'customcard.dart'; // Importing custom card widget for creating and managing cards.

// Defines a StatefulWidget to manage stateful data like the list of cards.
class FlashcardDisplayScreen extends StatefulWidget {
  @override
  _FlashcardDisplayScreenState createState() => _FlashcardDisplayScreenState(); // Creates state for this widget.
}

// State class that contains the mutable state for FlashcardDisplayScreen.
class _FlashcardDisplayScreenState extends State<FlashcardDisplayScreen> {
  List<Map<String, dynamic>> customCards = []; // List to store card data fetched from the local database.
  int rebuildKey = 0; // Key to force re-builds of FutureBuilder.

  @override
  void initState() {
    super.initState();
    _loadCustomCards(); // Calls method to load cards from the database when the widget initializes.
  }

  // Async method to load custom cards from the database.
  Future<void> _loadCustomCards() async {
    final dbHelper = DatabaseHelper(); // Create instance of database helper.
    final cards = await dbHelper.getCards(globals.selectedChapter); // Fetch cards from the specified chapter.
    setState(() {
      customCards = cards; // Update state to refresh UI with new cards.
    });
  }

  // Async method to fetch cards from Firestore and locally.
  Future<List<Widget>> _fetchFlashcards() async {
    List<Widget> flashcards = []; // List to hold card widgets.
    // Fetch Firestore collection of cards.
    final snapshot = await FirebaseFirestore.instance
        .collection(globals.selectedSubject)
        .doc(globals.selectedChapter)
        .collection(globals.selectedLearningType)
        .get();

    // Iterate over each document in Firestore and add to flashcards list.
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      flashcards.add(_buildFlashcard(data['front'] ?? 'No front data', data['back'] ?? 'No back data'));
    }

    // Add custom cards stored locally to the flashcards list.
    for (var card in customCards) {
      flashcards.add(_buildCustomFlashcard(card['front'], card['back'], card['id']));
    }

    return flashcards; // Return the complete list of flashcard widgets.
  }

  // Build a widget for a single flashcard using flip card animation.
  Widget _buildFlashcard(String front, String back) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL, // Set flip direction to horizontal.
      front: Card(child: ListTile(title: Text(front,style: TextStyle(fontFamily: 'Orbitron',
      ),))), // Front face of the card.
      back: Card(child: ListTile(title: Text(back,style: TextStyle(fontFamily: 'Orbitron',
      ),))), // Back face of the card.
    );
  }

  // Build a dismissible widget for a custom flashcard.
  Widget _buildCustomFlashcard(String front, String back, int id) {
    return Dismissible(
      key: Key(id.toString()), // Unique key for Dismissible to identify each card.
      onDismissed: (direction) async {
        final dbHelper = DatabaseHelper();
        await dbHelper.deleteCard(id); // Delete the card from the database when dismissed.
        _loadCustomCards(); // Reload the cards from database after one is deleted.
      },
      child: _buildFlashcard(front, back), // Child is the flashcard to be displayed.
    );
  }

  // Navigate to the custom card creation page and handle the result.
  void _navigateToCustomCardPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomCardPage()), // Navigate to the card creation screen.
    );
    setState(() {
      rebuildKey++; // Increment key to force FutureBuilder to rebuild.
      _loadCustomCards(); // Reload cards upon return from card creation screen.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${globals.selectedChapter} - ${globals.selectedLearningType}')), // App bar with dynamic title.
      body: FutureBuilder<List<Widget>>(
        key: ValueKey(rebuildKey), // Use a key to force rebuild of FutureBuilder.
        future: _fetchFlashcards(), // Future that loads flashcards.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator while data loads.
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Display error if one occurs.
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No flashcards available.')); // Display message if no data is available.
          }
          return ListView(children: snapshot.data!); // Display list of flashcards.
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCustomCardPage, // Button to navigate to the card creation page.
        child: Icon(Icons.add), // Icon for the button.
      ),
    );
  }
}
