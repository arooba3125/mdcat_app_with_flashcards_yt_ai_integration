// Importing Flutter's material library for UI components.
import 'package:flutter/material.dart';

// A reusable widget for sign-in or sign-up buttons.
Widget signInSignUpButton(
    BuildContext context, bool isLogin, VoidCallback onTap) {
  return Container(
    // Full width of the screen and height set to 50.
    width: MediaQuery.of(context).size.width,
    height: 50,
    // Adding margin for spacing above and below the button.
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    // Styling the container with rounded corners.
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      // Action triggered when the button is tapped.
      onPressed: onTap,
      style: ButtonStyle(
        // Setting the background color of the button with conditional logic for pressed state.
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26; // Light gray color when pressed.
          }
          return const Color.fromRGBO(51, 72, 101, 1.0); // Default button color.
        }),
        // Applying rounded corners to the button shape.
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
      child: Text(
        // Display "LOG IN" or "SIGN UP" based on the `isLogin` flag.
        isLogin ? "LOG IN" : "SIGN UP",
        style: const TextStyle(
          // Styling the button text with white color, bold font weight, and a font size of 16.
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    ),
  );
}

// A reusable button widget for custom buttons with specific properties.
Widget customButton({
  required String text, // The text displayed on the button.
  required double fontSize, // Font size for the button text.
  required VoidCallback onPressed, // Action triggered when the button is pressed.
}) {
  return ElevatedButton(
    onPressed: onPressed, // Setting the action to be performed when the button is pressed.
    style: ElevatedButton.styleFrom(
      // Setting a custom background color for the button.
      backgroundColor: const Color.fromRGBO(51, 72, 101, 1.0),
      // Adding padding inside the button for better spacing.
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      // Applying rounded corners to the button shape.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    child: Text(
      text, // The text displayed on the button.
      style: TextStyle(
        fontFamily: 'Orbitron', // Custom font family for the text.
        fontSize: fontSize, // Dynamic font size passed as an argument.
        fontWeight: FontWeight.bold, // Bold font weight for emphasis.
        color: Colors.white, // White text color.
      ),
    ),
  );
}

// A reusable widget for creating option buttons with custom titles and actions.
Widget buildOptionButton(String title, VoidCallback onPressed) {
  return GestureDetector(
    // Action triggered when the button is tapped.
    onTap: onPressed,
    child: Container(
      // Adding vertical margins to space the button vertically.
      margin: const EdgeInsets.symmetric(vertical: 10),
      // Adding vertical padding inside the button for better spacing.
      padding: const EdgeInsets.symmetric(vertical: 15),
      // Styling the button container with a background color and rounded corners.
      decoration: BoxDecoration(
        color: const Color.fromRGBO(2, 19, 34, 1.0), // Button background color.
        borderRadius: BorderRadius.circular(30), // Rounded corners.
        // Adding a white border around the button.
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Center(
        // Centering the text within the button.
        child: Text(
          title, // The title displayed on the button.
          style: const TextStyle(
            fontSize: 31, // Font size for the button text.
            color: Colors.white, // White text color.
            fontWeight: FontWeight.bold, // Bold font weight.
            fontFamily: "Orbitron", // Custom font family for the text.
          ),
        ),
      ),
    ),
  );
}
