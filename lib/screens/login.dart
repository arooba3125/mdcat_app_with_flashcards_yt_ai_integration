// Importing necessary Firebase authentication library for handling login.
import 'package:firebase_auth/firebase_auth.dart';
// Importing material design library from Flutter.
import 'package:flutter/material.dart';
// Importing a reusable widgets file where custom widgets might be defined.
import 'package:my_sem_projrct/reusable_widgets/reusable_widgets.dart';
// Importing the profile screen to navigate after successful login.
import 'package:my_sem_projrct/screens/profilescreen.dart';

// Creating a StatefulWidget because the login state (input fields) needs to be mutable.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Constructor with key initialization for the widget.

  @override
  // Creating state for the StatefulWidget.
  State<LoginScreen> createState() => _LoginScreenState();
}

// State class for LoginScreen containing all the stateful data and logic.
class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController to manage the text input for the password.
  TextEditingController _passwordTextController = TextEditingController();
  // TextEditingController to manage the text input for the email.
  TextEditingController _emailTextController = TextEditingController();

  @override
  // Building the UI structure of the login screen.
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the high-level structure for the screen.
      body: SafeArea(
        // SafeArea to avoid overlaps with system UI (like the notch).
        child: Stack(
          // Stack allows overlaying widgets.
          children: [
            // Background image widget
            Positioned.fill(
              // Positioned.fill to cover the entire available space.
              child: Image.asset(
                'assets/images/login background.jpg', // Local asset path for the background image.
                fit: BoxFit.cover, // Ensure the entire area is covered without changing the aspect ratio.
              ),
            ),
            // Padding around the main content area.
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 100),
              child: Center(
                // Center widget to align its child to the middle.
                child: Container(
                  // Container for the login form.
                  width: 400,
                  height: 350,
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  decoration: BoxDecoration(
                    // Styling the container.
                    color: const Color.fromRGBO(28, 48, 78, 0.8), // Semi-transparent dark color.
                    borderRadius: BorderRadius.circular(30), // Rounded corners.
                    border: Border.all(
                      color: Colors.blue, // Border color.
                      width: 2, // Border width.
                    ),
                  ),
                  child: Padding(
                    // Padding inside the form.
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      // Column layout for form elements.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Centered LOGIN text as a heading.
                        const Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10), // Space between LOGIN and Username field.
                        const Text(
                          "Username:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        // TextField for username/email input.
                        TextField(
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20), // Space between username and password fields.
                        const Text(
                          "Password:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        // TextField for password input.
                        TextField(
                          controller: _passwordTextController,
                          obscureText: true, // Hide the text for security.
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        // Reusable sign-in button.
                        signInSignUpButton(context, true, () {
                          // Button tap functionality.
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _emailTextController.text.trim(), // Takes trimmed email.
                            password: _passwordTextController.text.trim(), // Takes trimmed password.
                          )
                              .then((value) {
                            // On successful login, navigate to the profile screen.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          }).onError((error, stackTrace) {
                            // Display error using SnackBar if login fails.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Error: ${error.toString()}",
                                  style: const TextStyle(fontFamily: 'Orbitron'),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
