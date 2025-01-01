// Importing necessary Flutter and Firebase Firestore packages.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Importing screens for navigation within the app.
import 'package:my_sem_projrct/screens/login.dart';
import 'package:my_sem_projrct/screens/signup.dart';
import 'package:my_sem_projrct/screens/videos_screen.dart';

// Creating a StatefulWidget to manage state that might change.
class BackgroundImageWithContainerScreen extends StatefulWidget {
  const BackgroundImageWithContainerScreen({super.key}); // Constructor with optional key parameter.

  @override
  // Creating the state associated with this StatefulWidget.
  State<BackgroundImageWithContainerScreen> createState() =>
      _BackgroundImageWithContainerScreenState();
}

// Defining the State class that extends the State of BackgroundImageWithContainerScreen.
class _BackgroundImageWithContainerScreenState
    extends State<BackgroundImageWithContainerScreen> {
  double averageFeedback = 0.0; // Variable to store the average feedback score.

  @override
  void initState() {
    super.initState(); // Calling the initState method of the superclass.
    _calculateAverageFeedback(); // Fetch average feedback score from Firestore on initialization.
  }

  // Function to calculate the average feedback from Firestore.
  Future<void> _calculateAverageFeedback() async {
    // Querying the 'feedback' collection in Firestore and retrieving documents.
    QuerySnapshot feedbackSnapshot =
    await FirebaseFirestore.instance.collection('feedback').get();

    // Extracting scores from documents and calculating the average.
    List<int> scores = feedbackSnapshot.docs
        .map((doc) => doc['score'] as int)
        .toList();

    if (scores.isNotEmpty) { // Checking if there are any scores.
      double average =
          scores.reduce((a, b) => a + b) / scores.length; // Calculating average.
      setState(() {
        averageFeedback = average; // Updating state with the new average.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Building the widget tree.
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image container.
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Container displaying the average feedback score.
            Positioned(
              top: 30,
              right: 20,
              child: Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 15),
                    Text(
                      averageFeedback.toStringAsFixed(1), // Displaying average feedback with one decimal.
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Rotated container in the center.
            Center(
              child: Transform.rotate(
                angle: 45 * (3.1415926535897932 / 180), // Rotating the container by 45 degrees.
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(2, 19, 34, 1.0),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: -45 * (3.1415926535897932 / 180), // Counter-rotating the text inside the container.
                      child: const Padding(
                        padding: EdgeInsets.all(27.0),
                        child: Text(
                          'FREE EDU!', // Text inside the rotated container.
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Orbitron',
                            color: Color.fromRGBO(225, 200, 59, 1.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Additional text displayed on the screen.
            const Padding(
              padding: EdgeInsets.fromLTRB(60, 50, 20, 0),
              child: Text(
                "SHARKEMM", // Title text at the top.
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  color: Color.fromRGBO(225, 200, 59, 1.0),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(60, 120, 20, 0),
              child: Text(
                "WELCOME TO FREE EDU", // Subtitle text.
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 180, 20, 0),
              child: Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(225, 225, 225, 50.0),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Your Gateway to MBBS Success – Prepare Smarter, Achieve Greater!", // Motivational text.
                    style: TextStyle(
                      color: Color.fromRGBO(2, 19, 34, 1.0),
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Button to start or sign up.
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 600, 20, 100),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()), // Navigates to signup screen on press.
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(51, 72, 101, 30.0), // Button style configuration.
                  padding:
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'GET STARTED', // Button text.
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Icon buttons for navigation to different screens.
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 720, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // First container with icon button.
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(51, 72, 101, 30.0),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.home_outlined,
                          size: 45, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubjectSelection(), // Navigates to subject selection screen.
                          ),
                        );
                      },
                    ),
                  ),
                  // Second container with icon button.
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.login_outlined,
                          size: 45, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(), // Navigates to login screen.
                          ),
                        );
                      },
                    ),
                  ),
                  // Third container with icon button.
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(151, 137, 66, 0.9176470588235294),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.person_add,
                          size: 45, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(), // Navigates to signup screen again.
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
