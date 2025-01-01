// Importing required Flutter material components.
import 'package:flutter/material.dart';
// Importing global variables stored in a separate file to maintain state across different screens.
import '../globals.dart' as globals;
// Importing layout0 which presumably could be used to navigate or provide a layout template.
import 'layout0.dart';

// A stateless widget for selecting a subject.
class SubjectSelectionScreen extends StatelessWidget {
  // List of subjects available for selection.
  final List<String> subjects = ['BIOLOGY', 'CHEMISTRY', 'PHYSICS', 'ENGLISH', "LOGICAL REASONING"];

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the high-level structure for a screen.
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned.fill ensures the image covers the entire screen.
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg', // Path to the background image.
                fit: BoxFit.cover, // Cover the entire space without distorting aspect ratio.
              ),
            ),
            // Center widget centers its child within itself.
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Aligns children in the center of the column vertically.
                children: [
                  const SizedBox(height: 40), // Provides spacing above the text.
                  const Text(
                    "WHAT DO YOU WANT TO LEARN TODAY???", // Main heading text.
                    textAlign: TextAlign.center, // Align text to the center horizontally.
                    style: TextStyle(
                      fontSize: 30, // Font size for the text.
                      color: Colors.white, // Text color.
                      fontWeight: FontWeight.bold, // Font weight for bold text.
                      fontFamily: "Orbitron", // Custom font family.
                    ),
                  ),
                  const SizedBox(height: 50), // Provides spacing between the heading and the options.
                  // Padding around the options container.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                    child: Container(
                      height: 500, // Specifies the container's height.
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0), // Padding inside the container.
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7), // Semi-transparent white background.
                        borderRadius: BorderRadius.circular(50), // Rounded corners.
                      ),
                      // Column that holds a dynamic list of buttons.
                      child: Column(
                        children: subjects.map((subject) {
                          // Mapping each subject to a button widget.
                          return buildOptionButton(subject, () {
                            globals.selectedSubject = subject; // Setting the global variable to the selected subject.
                            // Navigates to the LearningTypeScreen on button press.
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LearningTypeScreen()),
                            );
                          });
                        }).toList(), // Convert the iterable to a list.
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Provides spacing below the options container.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function that creates a reusable button widget for each subject.
  Widget buildOptionButton(String title, VoidCallback onPressed) {
    // GestureDetector allows handling of tap events.
    return GestureDetector(
      onTap: onPressed, // Function to execute on tap.
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10), // Vertical margin between buttons.
        padding: const EdgeInsets.symmetric(vertical: 15), // Padding inside the button.
        decoration: BoxDecoration(
          color: const Color.fromRGBO(2, 19, 34, 1.0), // Button background color.
          borderRadius: BorderRadius.circular(30), // Rounded corners for the button.
          border: Border.all(
            color: Colors.white, // Border color.
            width: 2, // Border width.
          ),
        ),
        child: Center(
          child: Text(
            title, // The text label of the button.
            style: const TextStyle(
              fontSize: 24, // Font size for the text inside the button.
              color: Colors.white, // Text color.
              fontWeight: FontWeight.bold, // Bold text.
              fontFamily: "Orbitron", // Custom font family.
            ),
          ),
        ),
      ),
    );
  }
}
