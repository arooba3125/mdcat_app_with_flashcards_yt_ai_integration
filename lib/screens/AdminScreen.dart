// Importing necessary packages from Flutter's material design library and the cloud Firestore library.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Definition of the AdminScreen widget, which is a StatefulWidget allowing dynamic updates.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});  // Constructor accepting a key for the widget.

  @override
  // Creating the state for this widget.
  State<AdminScreen> createState() => _AdminScreenState();
}

// The state class for AdminScreen, containing all stateful data and methods.
class _AdminScreenState extends State<AdminScreen> {
  // Text editing controllers for user inputs.
  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _backController = TextEditingController();
  // Nullable strings for handling dropdown selections.
  String? selectedSubject;
  String? selectedChapter;
  String? selectedFlashcardType;

  // Lists of possible selections for subjects, chapters, and types of flashcards.
  List<String> subjects = ['BIOLOGY', 'CHEMISTRY', 'PHYSICS', 'ENGLISH', 'LOGICAL REASONING'];
  List<String> chapters = [];
  List<String> flashcardTypes = ['MCQs', 'FLASHCARDS', 'QUESTIONS', 'TF'];

  // Asynchronous method to fetch chapter names based on selected subject.
  Future<void> _loadChapters() async {
    if (selectedSubject == null) return;  // Exit if no subject is selected.

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(selectedSubject!)
        .get();

    List<String> chapterNames = snapshot.docs.map((doc) => doc.id).toList();

    setState(() {
      chapters = chapterNames;  // Update chapter list.
      selectedChapter = null;  // Reset selected chapter.
    });
  }

  // Asynchronous method to add a new flashcard to Firestore.
  Future<void> _addFlashcard() async {
    if (selectedSubject == null || selectedChapter == null || selectedFlashcardType == null) {
      // Error handling if not all dropdowns have selections.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all dropdown options')),
      );
      return;
    }
    if (_frontController.text.isEmpty || _backController.text.isEmpty) {
      // Error handling if text fields are empty.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both front and back fields')),
      );
      return;
    }

    // Add the flashcard data to Firestore.
    await FirebaseFirestore.instance
        .collection(selectedSubject!)
        .doc(selectedChapter)
        .collection(selectedFlashcardType!)
        .add({
      'front': _frontController.text,
      'back': _backController.text,
      'timestamp': FieldValue.serverTimestamp(),  // Add a server-side timestamp.
    });

    // Notify user of successful addition.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Flashcard added successfully!')),
    );

    // Clear input fields after submission.
    _frontController.clear();
    _backController.clear();
  }

  @override
  // Build method to construct the UI.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),  // Title of the screen.
        backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0),  // AppBar background color.
      ),
      body: SingleChildScrollView(
        // Allows for scrolling when content exceeds screen size.
        child: SafeArea(
          // Keeps the app within the safe area boundaries of the screen.
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Subject:',  // Label for subject selection.
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  // Dropdown menu for selecting a subject.
                  value: selectedSubject,
                  hint: const Text('Choose a subject'),
                  isExpanded: true,
                  items: subjects.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubject = value;  // Update selected subject.
                      _loadChapters();  // Fetch chapters for the new subject.
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Chapter:',  // Label for chapter selection.
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  // Dropdown menu for selecting a chapter.
                  value: selectedChapter,
                  hint: const Text('Choose a chapter'),
                  isExpanded: true,
                  items: chapters.map((chapter) {
                    return DropdownMenuItem(
                      value: chapter,
                      child: Text(chapter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedChapter = value;  // Update selected chapter.
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Flashcard Type:',  // Label for flashcard type selection.
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  // Dropdown menu for selecting flashcard type.
                  value: selectedFlashcardType,
                  hint: const Text('Choose a flashcard type'),
                  isExpanded: true,
                  items: flashcardTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFlashcardType = value;  // Update flashcard type.
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Flashcard Front:',  // Label for the front text of the flashcard.
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  // Text field for entering the front of the flashcard.
                  controller: _frontController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter front text',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Flashcard Back:',  // Label for the back text of the flashcard.
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  // Text field for entering the back of the flashcard.
                  controller: _backController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter back text',
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    // Button to submit the new flashcard to Firestore.
                    onPressed: _addFlashcard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Add Flashcard',  // Button text.
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
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
