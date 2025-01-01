// Importing necessary Flutter and Firestore packages.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';  // For creating flip animations for cards.
// Importing helper class for local database operations.
import '../database_helper.dart';
// Importing global variables for access throughout the application.
import '../globals.dart' as globals;
// Importing custom card widget for creating and managing cards.
import 'customcard.dart';

// StatefulWidget allows for creating a stateful widget to manage state changes based on user interaction or data updates.
class FlashcardDisplayScreen extends StatefulWidget {
  @override
  _FlashcardDisplayScreenState createState() => _FlashcardDisplayScreenState();
}

// State class for FlashcardDisplayScreen to manage the flashcards' data and interactions.
class _FlashcardDisplayScreenState extends State<FlashcardDisplayScreen> {
  // List to store custom flashcards fetched from local storage.
  List<Map<String, dynamic>> customCards = [];

  @override
  // Initialize state, loading custom cards from local storage when the widget is inserted into the tree.
  void initState() {
    super.initState();
    _loadCustomCards();  // Call method to load custom cards.
  }

  // Asynchronous method to fetch custom cards from local storage using the DatabaseHelper.
  Future<void> _loadCustomCards() async {
    final dbHelper = DatabaseHelper();  // Instance of database helper.
    final cards = await dbHelper.getCards(globals.selectedChapter);  // Fetching cards by chapter.
    setState(() {
      customCards = cards;  // Update the state with fetched cards.
    });
  }

  // Asynchronous method to fetch flashcards from Firestore.
  Future<List<Widget>> _fetchFlashcards() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(globals.selectedSubject)
        .doc(globals.selectedChapter)
        .collection(globals.selectedLearningType)
        .get();  // Firestore query to fetch flashcards by subject, chapter, and learning type.

    List<Widget> flashcards = [];  // List to store flashcard widgets.

    // Iterate over each document in the snapshot.
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;  // Data of the document.
      String front = data['front'] ?? 'No front data';  // Front text of the card, default if missing.
      String back = data['back'] ?? 'No back data';  // Back text of the card, default if missing.

      // Add a widget for the flashcard.
      flashcards.add(_buildFlashcard(front, back));
    }

    // Add custom cards from local storage to the list.
    for (var card in customCards) {
      flashcards.add(_buildCustomFlashcard(card['front'], card['back'], card['id']));
    }

    return flashcards;  // Return the list of flashcard widgets.
  }

  // Widget to build a standard flashcard with a flip animation.
  Widget _buildFlashcard(String front, String back) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,  // Direction of the flip animation.
          front: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Color.fromRGBO(88, 117, 156, 50),  // Color of the front of the card.
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    front,
                    style: TextStyle(fontSize: 25, fontFamily: "Orbitron", color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          back: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blueGrey,  // Color of the back of the card.
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    back,
                    style: TextStyle(fontSize: 25, fontFamily: "Orbitron", color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget to build a custom flashcard that can be dismissed.
  Widget _buildCustomFlashcard(String front, String back, int id) {
    return Dismissible(
      key: UniqueKey(),  // Unique key for Dismissible.
      direction: DismissDirection.endToStart,  // Dismiss direction from right to left.
      onDismissed: (direction) async {
        final dbHelper = DatabaseHelper();
        await dbHelper.deleteCard(id);  // Delete card from database upon dismissal.
        setState(() {
          customCards.removeWhere((card) => card['id'] == id);  // Remove card from the list.
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Card deleted')));
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: _buildFlashcard(front, back),  // Child is a regular flashcard widget.
    );
  }

  // Method to navigate to the custom card creation page.
  void _navigateToCustomCardPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomCardPage(),
      ),
    );

    // Check if a result was returned and insert the new card into the database.
    if (result != null && result is Map<String, String>) {
      final dbHelper = DatabaseHelper();
      await dbHelper.insertCard(globals.selectedChapter, result['title']!, result['description']!);
      _loadCustomCards();  // Reload custom cards from database.
    }
  }

  @override
  // Builds the UI for the flashcard display screen.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${globals.selectedChapter} - ${globals.selectedLearningType}',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0),
      ),
      body: FutureBuilder<List<Widget>>(
        future: _fetchFlashcards(),  // Fetch flashcards asynchronously.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Show loading indicator.
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));  // Show error message.
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No flashcards available.'));  // Show message if no cards are available.
          }

          return ListView(
            children: snapshot.data!,  // Display the list of flashcards.
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCustomCardPage,  // Navigate to the custom card page on button press.
        backgroundColor: Color.fromRGBO(2, 19, 34, 1.0),
        child: Icon(Icons.add),  // Icon for adding a new card.
      ),
    );
  }
}
