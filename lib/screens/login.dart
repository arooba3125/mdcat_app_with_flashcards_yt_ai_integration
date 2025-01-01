// Import necessary Firebase authentication library for handling login.
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

  // Function to handle login with Firebase authentication.
  void _login() async {
    try {
      // Attempt to sign in with email and password.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );
      // Navigate to ProfileScreen upon successful login.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } on FirebaseAuthException catch (e) {
    String message;
    switch (e.code) {
    case 'user-not-found':
    message = 'No user found for that email.';
    break;
    case 'wrong-password':
    message = 'Wrong password provided for that user.';
    break;
    case 'invalid-email':
    message = 'The email address is not valid.';
    break;
    default:
    message = 'An unexpected error occurred.';
    }
    // Show error message.
    _showError(message);
    }
    catch (e) {
      // Handle any other exceptions.
      _showError('An unexpected error occurred.');
    }
  }

  // Function to display error messages.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontFamily: 'Orbitron'),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/login background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 100),
              child: Center(
                child: Container(
                  width: 400,
                  height: 350,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(28, 48, 78, 0.8),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("Username:", style: TextStyle(color: Colors.white, fontSize: 18)),
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
                      const SizedBox(height: 05),
                      const Text("Password:", style: TextStyle(color: Colors.white, fontSize: 18)),
                      TextField(
                        controller: _passwordTextController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      signInSignUpButton(context, true, _login), // Updated to use the _login method.
                    ],
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
