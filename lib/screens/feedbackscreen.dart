// Importing necessary packages from Flutter and Firebase Firestore for UI components and database interactions.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// StatefulWidget allows for dynamic changes in the UI based on user interaction or data updates.
class FeedbackScreen extends StatefulWidget {
  @override
  // createState method creates the mutable state object for this widget.
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

// State class for FeedbackScreen, handling all logic and state changes.
class _FeedbackScreenState extends State<FeedbackScreen> {
  // Integer to track the current feedback selection, defaulting to 3 for neutral.
  int selectedFeedback = 3;

  // Mapping of integer scores to specific colors representing different feedback levels.
  final Map<int, Color> emojiColors = {
    1: Colors.red, // Color for very dissatisfied.
    2: Colors.deepOrange, // Color for dissatisfied.
    3: Colors.amber, // Color for neutral.
    4: Colors.lightGreen, // Color for satisfied.
    5: Colors.green, // Color for very satisfied.
  };

  // Asynchronous method to submit feedback data to Firestore.
  Future<void> _submitFeedback() async {
    // Adding a new document to the 'feedback' collection with the selected feedback score and a server timestamp.
    await FirebaseFirestore.instance.collection('feedback').add({
      'score': selectedFeedback,
      'timestamp': FieldValue.serverTimestamp(), // Automatically set the server timestamp for accuracy.
    });

    // Display a Snackbar to inform the user of successful feedback submission.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback Submitted! Thank you.')),
    );

    // Pop the current screen off the navigation stack after feedback submission.
    Navigator.pop(context);
  }

  // Returns a clickable emoji icon wrapped in a Column widget.
  Widget _emojiButton(int score, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Update the state to reflect the selected feedback score when the icon is tapped.
        setState(() {
          selectedFeedback = score;
        });
      },
      child: Column(
        children: [
          Icon(
            icon, // Emoji icon representation.
            size: 50, // Icon size set to 50 for better visibility.
            // Color changes to grey when selected, otherwise uses defined color from emojiColors map.
            color: selectedFeedback == score ? Colors.grey : emojiColors[score],
          ),
          const SizedBox(height: 5), // Vertical spacing between the icon and any following content.
        ],
      ),
    );
  }

  @override
  // Builds the UI elements for the feedback screen.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback', style: TextStyle(color: Colors.white)), // AppBar title.
        backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0), // AppBar background color.
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically in the view.
            children: [
              const Text(
                'Rate your experience', // Prompt text for user action.
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Text styling.
              ),
              const SizedBox(height: 30), // Spacer to create distance between text and emoji icons.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute emoji icons evenly across the row.
                children: [
                  // Emoji buttons for various feedback scores, 1 through 5.
                  _emojiButton(1, Icons.sentiment_very_dissatisfied),
                  _emojiButton(2, Icons.sentiment_dissatisfied),
                  _emojiButton(3, Icons.sentiment_neutral),
                  _emojiButton(4, Icons.sentiment_satisfied),
                  _emojiButton(5, Icons.sentiment_very_satisfied),
                ],
              ),
              const SizedBox(height: 40), // Additional spacer below emoji icons before the submit button.
              ElevatedButton(
                onPressed: _submitFeedback, // Calls the submit feedback method when pressed.
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0), // Button color.
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Padding inside the button.
                ),
                child: const Text(
                  'Submit Feedback', // Text displayed on the button.
                  style: TextStyle(fontSize: 18, color: Colors.white), // Button text styling.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
