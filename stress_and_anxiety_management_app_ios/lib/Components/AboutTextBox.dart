import 'package:flutter/material.dart';

/// AboutTextBox is a reusable component to display centered informational text
/// inside a styled card. Typically used on screens like AboutScreen.
class AboutTextBox extends StatelessWidget {
  final String text; // The content of the text box
  final double fontSize; // Font size of the text, default is 16

  const AboutTextBox({
    super.key,
    required this.text,
    this.fontSize = 16, // Default font size
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[700], // Background color of the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(20), // Inner spacing around the text
        child: Text(
          text,
          textAlign: TextAlign.center, // Center the text horizontally
          style: TextStyle(
            color: Colors.white, // White text for contrast
            fontSize: fontSize, // Allows customizable font size
            height: 1.5, // Line height for better readability
          ),
        ),
      ),
    );
  }
}
