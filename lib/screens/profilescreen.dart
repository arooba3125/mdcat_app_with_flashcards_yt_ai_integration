// Importing necessary Flutter and Firebase authentication packages.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importing screens for navigation and interaction within the app.
import 'package:my_sem_projrct/screens/ChatScreen.dart';
import 'package:my_sem_projrct/screens/feedbackscreen.dart';
import 'package:my_sem_projrct/screens/videos_screen.dart';
import 'layoutt1.dart';  // Assuming this is a custom layout or widget.
import 'homepage.dart';  // Home screen of the application.
import 'login.dart';  // Login screen for user authentication.

// Declaration of a StatefulWidget to manage mutable state related to user profiles.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});  // Constructor with optional key parameter.

  @override
  // Creating the state for this widget.
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// State class for ProfileScreen containing all the logic and mutable data.
class _ProfileScreenState extends State<ProfileScreen> {
  // Variables to store user email and name with default values.
  String userEmail = 'Fetching email...';  // Placeholder text before email is fetched.
  String userName = 'John Doe';  // Default user name.
  final TextEditingController _nameController = TextEditingController();  // Controller for editing user name.

  @override
  // Initialize state and fetch user email from Firebase.
  void initState() {
    super.initState();
    _getUserEmail();  // Call to fetch the email of the logged-in user.
  }

  // Fetches the current user's email from FirebaseAuth and updates the state.
  void _getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;  // Get the current logged-in user.
    if (user != null) {
      setState(() {
        userEmail = user.email ?? 'No email available';  // Update userEmail with the fetched email or show default message.
      });
    }
  }

  // Asynchronously signs the user out and navigates back to the login screen.
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();  // Firebase sign out.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,  // Remove all routes below the login screen.
    );
  }

  // Opens a dialog to edit the user name.
  void _editName() {
    _nameController.text = userName;  // Initialize text field with current userName.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),  // Dialog title.
          content: TextField(
            controller: _nameController,  // TextField for entering name.
            decoration: const InputDecoration(
              labelText: 'Your Name',  // Label for the text field.
              border: OutlineInputBorder(),  // Outlined border for the text field.
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),  // Button to cancel and close the dialog.
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  userName = _nameController.text.trim();  // Update userName with the input from the text field.
                });
                Navigator.pop(context);  // Close the dialog after saving.
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  // Building the UI of the profile screen.
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(28, 48, 78, 0.8),  // Background color for the scaffold.
        appBar: AppBar(
          title: const Text('Profile', style: TextStyle(color: Colors.white)),  // App bar with 'Profile' title.
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0),  // App bar background color.
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,  // Remove default padding.
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(2, 19, 34, 1.0),  // Background color for the drawer header.
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person_pin, size: 80, color: Colors.white),  // Icon for the user.
                    const Text('Hello, User!',  // Greeting text.
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(userEmail, style: const TextStyle(color: Colors.white70, fontSize: 14)),  // Display user email.
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.school),  // Icon for the Learning menu item.
                title: const Text('Start Learning'),  // Text for the Learning menu item.
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectSelectionScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.video_library),  // Icon for the Video menu item.
                title: const Text('Learn from Video'),  // Text for the Video menu item.
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectSelection())),
              ),
              ListTile(
                leading: const Icon(Icons.chat),  // Icon for the Chat menu item.
                title: const Text('Chat a Query'),  // Text for the Chat menu item.
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.settings_suggest_outlined),  // Icon for the Feedback menu item.
                title: const Text('Feedback'),  // Text for the Feedback menu item.
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen())),
              ),
              const Divider(),  // Divider for visual separation in the drawer.
              ListTile(
                leading: const Icon(Icons.logout),  // Icon for the Logout menu item.
                title: const Text('Logout'),  // Text for the Logout menu item.
                onTap: _logout,  // Function to execute on tap (logout).
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(  // Ensures the content is scrollable to prevent overflow.
          child: Padding(
            padding: const EdgeInsets.all(16.0),  // Padding for the body content.
            child: Column(
              children: [
                const Center(child: Icon(Icons.person_pin, size: 200, color: Colors.white)),  // Large icon for the user profile.
                const SizedBox(height: 20),  // Space between the icon and the user name.
                GestureDetector(
                  onTap: _editName,  // Function to edit name on tap.
                  child: Text(userName,  // Display the current user name.
                      style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Orbitron", decoration: TextDecoration.underline)),
                ),
                const SizedBox(height: 10),  // Space between the name and the email.
                Text(userEmail, style: const TextStyle(fontSize: 16, color: Colors.grey)),  // Display the current email.
                const SizedBox(height: 30),  // Space before the list tiles.
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),  // Rounded corners for the card.
                  child: ListTile(
                    leading: const Icon(Icons.school, color: Color.fromRGBO(2, 19, 34, 1.0)),  // Icon for the learning link.
                    title: const Text('Start Learning', style: TextStyle(fontWeight: FontWeight.bold)),  // Text for the learning link.
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectSelectionScreen())),  // Navigate to learning screen on tap.
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
