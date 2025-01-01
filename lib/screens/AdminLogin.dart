// Importing the Flutter Material package for UI components.
import 'package:flutter/material.dart';
// Importing the AdminScreen where administrators will navigate upon successful login.
import 'AdminScreen.dart';

// AdminLogin is a StatefulWidget, which allows it to maintain state that can change over time.
class AdminLogin extends StatefulWidget {
  // Constructor with an optional key parameter.
  const AdminLogin({Key? key}) : super(key: key);

  @override
  // Creating the state for this widget.
  State<AdminLogin> createState() => _AdminLoginState();
}

// The state class for AdminLogin, containing logic and properties.
class _AdminLoginState extends State<AdminLogin> {
  // Controllers to manage the text input for email and password fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Map to store admin credentials for authentication.
  final Map<String, String> adminCredentials = {
    "admin@gmail.com": "admin", // Default admin credentials.
  };

  // Method to handle login functionality.
  void _login() {
    // Retrieving user input from text fields.
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Checking credentials.
    if (adminCredentials[email] == password) {
      // If credentials match, navigate to the Admin Panel using a route replacement.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
    } else {
      // If credentials do not match, show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  // Build method to construct the UI.
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides a high-level structure for the login screen.
      appBar: AppBar(
        // AppBar with a title.
        title: const Text('Admin Login', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0), // Setting a custom color for the AppBar.
      ),
      body: Padding(
        // Padding around the content inside the body for aesthetics.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Column widget to arrange children vertically.
          children: [
            const Text(
              'Login as Admin', // Text heading for the login form.
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Provides vertical spacing.
            TextField(
              // Text field for email input.
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email', // Label for the email field.
                border: OutlineInputBorder(), // Adds a border around the text field.
              ),
            ),
            const SizedBox(height: 20), // More vertical spacing.
            TextField(
              // Text field for password input.
              controller: _passwordController,
              obscureText: true, // Obscures text for password entry.
              decoration: const InputDecoration(
                labelText: 'Password', // Label for the password field.
                border: OutlineInputBorder(), // Adds a border around the text field.
              ),
            ),
            const SizedBox(height: 20), // Additional vertical spacing.
            ElevatedButton(
              // Button to trigger the login process.
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0), // Button color to match the theme.
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)), // Button text.
            ),
          ],
        ),
      ),
    );
  }
}
