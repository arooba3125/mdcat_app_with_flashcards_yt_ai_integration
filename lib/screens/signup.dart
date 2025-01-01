// Importing necessary packages for Firebase authentication and Flutter material components.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Importing additional custom screens and reusable widgets for use within this screen.
import 'package:my_sem_projrct/screens/login.dart';
import 'package:my_sem_projrct/reusable_widgets/reusable_widgets.dart';

// Declaration of a StatefulWidget to manage the mutable state related to user signup.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key}); // Constructor for initializing key in the superclass widget.

  @override
  // Creating the state associated with the SignupScreen.
  State<SignupScreen> createState() => _SignupScreenState();
}

// The state class that contains the logic and UI for the SignupScreen.
class _SignupScreenState extends State<SignupScreen> {
  // Controllers to manage the text input for email and password fields.
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  // Builds the UI components of the SignupScreen.
  Widget build(BuildContext context) {
    return Scaffold(
      // Provides a high-level structure to manage the basic material design layout.
      body: SafeArea(
        // Keeps the app UI within the safe area boundaries of the display.
        child: Stack(
          // Allows overlaying widgets on top of each other.
          children: [
            // Positions a background image to cover the entire available space.
            Positioned.fill(
              child: Image.asset(
                'assets/images/login background.jpg', // Specifies the path to the background image.
                fit: BoxFit.cover, // Ensures the image covers the space without distorting its ratio.
              ),
            ),
            // Padding around the main content of the signup form.
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 100),
              child: Center(
                // Center aligns its child widget within the parent.
                child: Container(
                  width: 400, // Specifies the width of the container.
                  height: 345, // Specifies the height of the container.
                  padding: const EdgeInsets.all(14), // Provides padding within the container.
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(2, 19, 34, 1.0), // Sets a dark semi-transparent background color.
                    borderRadius: BorderRadius.circular(30), // Rounds the corners of the container.
                    border: Border.all(
                      color: Colors.blue, // Sets the border color to blue.
                      width: 2, // Sets the border width.
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Center(
                          // Center-aligns the "SIGN UP" heading within its container.
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white, // Text color is white.
                              fontSize: 40, // Font size is 40.
                              fontWeight: FontWeight.bold, // Text weight is bold.
                            ),
                          ),
                        ),
                        const SizedBox(height: 0), // Provides vertical space between elements.
                        const Text(
                          "Email:", // Label for the email input field.
                          style: TextStyle(
                            color: Colors.white, // Text color is white.
                            fontSize: 18, // Font size is 18.
                          ),
                        ),
                        // Email input text field.
                        TextField(
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Rounded corners for the input field.
                              borderSide: const BorderSide(color: Colors.blue), // Border color.
                            ),
                            filled: true, // Fills the text field with a background color.
                            fillColor: Colors.white, // Background color is white.
                          ),
                        ),
                        const SizedBox(height: 10), // Provides vertical space between elements.
                        const Text(
                          "Password:", // Label for the password input field.
                          style: TextStyle(
                            color: Colors.white, // Text color is white.
                            fontSize: 18, // Font size is 18.
                          ),
                        ),
                        // Password input text field, obscured for privacy.
                        TextField(
                          controller: _passwordTextController,
                          obscureText: true, // Obscures text input.
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Rounded corners for the input field.
                              borderSide: const BorderSide(color: Colors.blue), // Border color.
                            ),
                            filled: true, // Fills the text field with a background color.
                            fillColor: Colors.white, // Background color is white.
                          ),
                        ),
                        // Reusable sign up button that handles user registration.
                        signInSignUpButton(context, false, () async {
                          try {
                            // Attempt to create a new user with Firebase authentication.
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                            );

                            // Show a SnackBar to indicate successful account creation.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Account created successfully!',
                                  style: TextStyle(fontFamily: 'Orbitron'),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Navigate to the login screen after successful account creation.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          } catch (e) {
                            // Show a SnackBar to display the error message if account creation fails.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error: $e',
                                  style: const TextStyle(fontFamily: 'Orbitron'),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
