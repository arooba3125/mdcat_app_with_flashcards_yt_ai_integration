// Importing necessary material design library for UI components.
import 'package:flutter/material.dart';

// StatefulWidget allows for dynamic changes in the UI based on user interaction or data updates.
class CustomCardPage extends StatefulWidget {
  @override
  // createState method creates the mutable state object for this widget.
  _CustomCardPageState createState() => _CustomCardPageState();
}

// State class for CustomCardPage that handles the logic and internal state.
class _CustomCardPageState extends State<CustomCardPage> {
  // TextEditingControllers manage the text being edited in TextField widgets.
  final _titleController = TextEditingController(); // Controller for the title input.
  final _descriptionController = TextEditingController(); // Controller for the description input.
  final _imageController = TextEditingController(); // Controller for the optional image URL input.

  // Method to handle saving the card's data.
  void _saveCard() {
    final card = {
      'title': _titleController.text, // Retrieves text from the title TextField.
      'description': _descriptionController.text, // Retrieves text from the description TextField.
    };

    // Pops the current screen off the stack and passes the card data back to the previous screen.
    Navigator.pop(context, card);
  }

  @override
  // Builds the UI elements for the custom card page.
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Scaffold provides the high-level structure for the screen.
        appBar: AppBar(
          title: Text('Customize Card'), // AppBar with a simple title.
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Padding for all sides of the body content.
          child: Column(
            // Column arranges its children vertically.
            children: [
              TextField(
                controller: _titleController, // Connects the TextField to the title controller.
                decoration: InputDecoration(labelText: 'Title'), // Decoration for the title input field.
              ),
              TextField(
                controller: _descriptionController, // Connects the TextField to the description controller.
                decoration: InputDecoration(labelText: 'Description'), // Decoration for the description input field.
              ),
              TextField(
                controller: _imageController, // Connects the TextField to the image URL controller.
                decoration: InputDecoration(labelText: 'Image URL (Optional)'), // Decoration for the optional image URL input field.
              ),
              SizedBox(height: 20), // Provides vertical spacing between elements.
              ElevatedButton(
                onPressed: _saveCard, // Calls the _saveCard method when the button is pressed.
                child: Text('Save Card'), // Label for the button.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
