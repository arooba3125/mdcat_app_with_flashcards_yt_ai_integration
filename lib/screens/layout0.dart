// Importing the required Flutter material components.
import 'package:flutter/material.dart';
// Importing a screen for navigating to chapter selection.
import 'ChapterSelectionScreen.dart';
// Importing global variables for app-wide state management.
import '../globals.dart' as globals;
// Importing reusable widgets from a custom library.
import '../reusable_widgets/reusable_widgets.dart';

// A StatelessWidget for selecting the learning type.
class LearningTypeScreen extends StatelessWidget {
  // List of learning types available for selection.
  final List<String> learningTypes = ['FLASHCARDS', 'MCQs', 'TF', 'QUESTIONS'];

  @override
  // Builds the widget tree for the LearningTypeScreen.
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the high-level structure for a screen.
      body: SafeArea(
        // SafeArea ensures the UI does not overlap with system interfaces.
        child: Stack(
          // Stack allows overlaying of widgets.
          children: [
            // Positioned.fill ensures the background image covers the entire available space.
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg', // Path to the background image file.
                fit: BoxFit.cover, // Ensures the image covers the entire space evenly.
              ),
            ),
            // Center aligns its child to the middle of the available space.
            Center(
              child: Column(
                // Column arranges its children vertically.
                mainAxisAlignment: MainAxisAlignment.center, // Centers the Column's children vertically.
                children: [
                  const SizedBox(height: 30), // Provides vertical spacing.
                  const Text(
                    "HOW DO YOU WANT TO LEARN TODAY????", // Main heading text.
                    textAlign: TextAlign.center, // Centers the text horizontally.
                    style: TextStyle(
                      fontSize: 30, // Sets the font size.
                      color: Colors.white, // Sets the text color.
                      fontWeight: FontWeight.bold, // Makes the text bold.
                      fontFamily: "Orbitron", // Uses a custom font family.
                    ),
                  ),
                  const SizedBox(height: 70), // Provides additional vertical spacing.
                  Padding(
                    // Padding widget to add space around its child.
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 0), // Specifies the padding.
                    child: Container(
                      height: 450, // Specifies the container's height.
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20), // Padding inside the container.
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7), // Semi-transparent white background.
                        borderRadius: BorderRadius.circular(50), // Rounded corners.
                      ),
                      child: Column(
                        // Another Column to arrange buttons vertically.
                        children: [
                          // Creates a button for each learning type.
                          buildLearningTypeButton("FLASHCARDS", context),
                          buildLearningTypeButton("MCQs", context),
                          buildLearningTypeButton("TF", context),
                          buildLearningTypeButton("QUESTIONS", context),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Adds more vertical spacing at the bottom.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create a button for each learning type.
  Widget buildLearningTypeButton(String type, BuildContext context) {
    return Padding(
      // Padding to add space below each button.
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        // GestureDetector to handle tap events.
        onTap: () {
          globals.selectedLearningType = type; // Sets the selected learning type in a global variable.
          // Navigates to the ChapterSelectionScreen when the button is tapped.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChapterSelectionScreen()),
          );
        },
        child: Container(
          // Container to style the button.
          margin: const EdgeInsets.symmetric(vertical: 5), // Margin around the button.
          height: 70, // Height of the button.
          decoration: BoxDecoration(
            color: const Color.fromRGBO(2, 19, 34, 1.0), // Button color.
            borderRadius: BorderRadius.circular(30), // Rounded corners for the button.
            border: Border.all(color: Colors.white, width: 2), // White border around the button.
          ),
          child: Center(
            // Center aligns the text inside the button.
            child: Text(
              type, // Text displayed on the button.
              style: const TextStyle(
                fontSize: 30, // Font size of the text.
                color: Colors.white, // Text color.
                fontWeight: FontWeight.bold, // Makes the text bold.
                fontFamily: "Orbitron", // Uses a custom font family.
              ),
            ),
          ),
        ),
      ),
    );
  }
}
