// Importing necessary Flutter and Firestore packages.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Importing screen to display Flashcards after chapter selection.
import 'FlashcardDisplayScreen.dart';
// Importing global variables.
import '../globals.dart' as globals;

// Declaration of a StatelessWidget because this screen does not manage any internal state changes.
class ChapterSelectionScreen extends StatelessWidget {
  @override
  // Builds the UI components of the ChapterSelectionScreen.
  Widget build(BuildContext context) {
    return Scaffold(
      // Provides a high-level structure to manage the basic material design layout.
      body: SafeArea(
        // Keeps the app UI within the safe area boundaries of the display.
        child: Stack(
          // Allows overlaying widgets on top of each other.
          children: [
            // Background image widget.
            Positioned.fill(
              // Positioned.fill to cover the entire available space.
              child: Image.asset(
                'assets/images/background.jpg', // Local asset path for the background image.
                fit: BoxFit.cover, // Ensures the image covers the space without distorting its ratio.
              ),
            ),
            // Center widget to align its child to the middle of the available space.
            Center(
              child: Column(
                // Column arranges its children vertically.
                mainAxisAlignment: MainAxisAlignment.center, // Centers the Column's children vertically.
                children: [
                  const SizedBox(height: 30), // Provides vertical spacing.
                  const Text(
                    "SELECT A CHAPTER", // Main heading text.
                    textAlign: TextAlign.center, // Centers the text horizontally.
                    style: TextStyle(
                      fontSize: 30, // Sets the font size.
                      color: Colors.white, // Sets the text color.
                      fontWeight: FontWeight.bold, // Makes the text bold.
                      fontFamily: "Orbitron", // Uses a custom font family.
                    ),
                  ),
                  const SizedBox(height: 30), // Provides additional vertical spacing.
                  Expanded(
                    // Expanded widget to use all available space for the container.
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8), // Semi-transparent white background.
                          borderRadius: BorderRadius.circular(30), // Rounded corners.
                        ),
                        child: FutureBuilder<QuerySnapshot>(
                          // FutureBuilder to build widgets based on Firestore's asynchronous response.
                          future: FirebaseFirestore.instance
                              .collection(globals.selectedSubject) // Fetches chapters based on the selected subject.
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Shows a loading indicator while waiting for data.
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              // Shows an error message if the snapshot encounters an error.
                              return Center(
                                  child: Text(
                                    'Error: ${snapshot.error}', // Displays the error message.
                                    style: TextStyle(color: Colors.red, fontSize: 16),
                                  ));
                            }

                            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                              // Displays a message if no chapters are found.
                              return const Center(
                                child: Text(
                                  'No chapters found.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              );
                            }

                            // ListView to display each chapter as an interactive list item.
                            return ListView(
                              children: snapshot.data!.docs.map((doc) {
                                String chapterName = doc.id; // Obtains the chapter name from the document ID.
                                return GestureDetector(
                                  onTap: () {
                                    // Handles tap on the chapter item.
                                    globals.selectedChapter = chapterName; // Sets the selected chapter globally.
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FlashcardDisplayScreen()), // Navigates to the FlashcardDisplayScreen.
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(2, 19, 34, 1.0), // Button color.
                                      borderRadius: BorderRadius.circular(25), // Rounded corners.
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26, // Shadow color.
                                          blurRadius: 5, // Blur radius for shadow.
                                          offset: Offset(2, 2), // Offset for shadow.
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      chapterName, // Displays the chapter name.
                                      textAlign: TextAlign.center, // Centers the text.
                                      style: const TextStyle(
                                        fontSize: 22, // Font size for the text.
                                        color: Colors.white, // Text color.
                                        fontWeight: FontWeight.bold, // Makes the text bold.
                                        fontFamily: "Orbitron", // Uses a custom font family.
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(), // Converts the iterable to a list.
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Additional space at the bottom.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
