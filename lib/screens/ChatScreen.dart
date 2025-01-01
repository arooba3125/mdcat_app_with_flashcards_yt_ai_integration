// Importing necessary Flutter material and Cupertino widgets.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Importing the Google generative AI package for utilizing its AI model functionality.
import 'package:google_generative_ai/google_generative_ai.dart';
// Importing the intl package to format dates.
import 'package:intl/intl.dart';

// Defining the MyApp class which is a StatelessWidget.
class MyApp extends StatelessWidget {
  // Constructor with an optional key parameter.
  const MyApp({super.key});

  @override
  // Building the main app widget structure.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' AI Chat', // App title.
      debugShowCheckedModeBanner: false, // Disables the debug banner for cleaner UI.
      theme: ThemeData(
        // Sets up the theme using Material Design 3 features.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatScreen(), // Specifies the home screen of the app.
    );
  }
}

// StatefulWidget to manage the chat interface.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key}); // Constructor with an optional key parameter.

  @override
  // Creating the state for this widget.
  State<ChatScreen> createState() => _ChatScreenState();
}

// State class for handling the chat logic.
class _ChatScreenState extends State<ChatScreen> {
  // Controller to handle text input for user messages.
  TextEditingController _userInput = TextEditingController();

  // API key for the Google Gemini AI model, normally should be secured and not hardcoded.
  static const apiKey = "AIzaSyAlDcyjBUAYmbpfXRYKs8k-ycMbzuuEMDQ";

  // Initializing the Gemini AI model with the provided API key.
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  // List to store messages as they are sent and received.
  final List<Message> _messages = [];

  // Asynchronous function to handle sending and receiving messages.
  Future<void> sendMessage() async {
    final message = _userInput.text; // Getting text from the input controller.

    // Add user's message to the state to display in the UI.
    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    // Sending user's message to the Gemini model to generate a response.
    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    // Adding the AI-generated response to the message list.
    setState(() {
      _messages.add(Message(isUser: false, message: response.text ?? "", date: DateTime.now()));
    });

    // Clear the text input field after the message is sent.
    _userInput.clear();
  }

  @override
  // Building the UI for the chat screen.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background decoration with an image and color filter.
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
            image: NetworkImage('https://w0.peakpx.com/wallpaper/108/670/HD-wallpaper-black.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              // ListView to display the conversation.
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  // Custom widget to display each message.
                  return Messages(isUser: message.isUser, message: message.message, date: DateFormat('HH:mm').format(message.date));
                },
              ),
            ),
            Padding(
              // Padding for the input field and send button.
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    // TextField for user to enter messages.
                    flex: 15,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _userInput,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text('Enter Your Message'),
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    // Button to send the message.
                    padding: EdgeInsets.all(12),
                    iconSize: 30,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(CircleBorder()),
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send),
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

// Message class to encapsulate the data for each message.
class Message {
  final bool isUser; // Boolean to determine if the message is from the user or AI.
  final String message; // The message text.
  final DateTime date; // Timestamp for when the message was sent or received.

  Message({required this.isUser, required this.message, required this.date});
}

// Stateless widget to display individual messages.
class Messages extends StatelessWidget {
  final bool isUser; // Boolean to determine the message sender.
  final String message; // Message text to display.
  final String date; // Formatted date to display.

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  // Building the individual message widget.
  Widget build(BuildContext context) {
    return Container(
      // Container to hold each message.
      width: double.infinity,
      padding: EdgeInsets.all(15),
      // Margins adjust based on who sent the message for visual distinction.
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      // Background color changes based on the sender.
      decoration: BoxDecoration(
        color: isUser ? Colors.blueAccent : Colors.grey.shade400,
        borderRadius: BorderRadius.only(
          // Rounded corners for aesthetic enhancement.
          topLeft: Radius.circular(10),
          bottomLeft: isUser ? Radius.circular(10) : Radius.zero,
          topRight: Radius.circular(10),
          bottomRight: isUser ? Radius.zero : Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message, // Displaying the message text.
            style: TextStyle(fontSize: 16, color: isUser ? Colors.white : Colors.black),
          ),
          Text(
            date, // Displaying the time the message was sent.
            style: TextStyle(fontSize: 10, color: isUser ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
