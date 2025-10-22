import 'package:flutter/material.dart';

/// ActionButton is a reusable button with an icon and label.
/// It can be customized with text size, color, and height.
/// Typically used on the HomeScreen to represent actions like Dashboard, Settings, etc.
class ActionButton extends StatelessWidget {
  final String label; // Text displayed on the button
  final IconData icon; // Icon displayed before the text
  final VoidCallback onPressed; // Callback when the button is pressed
  final double fontSize; // Font size of the label text
  final Color textColor; // Color of the text and icon
  final double height; // Minimum height of the button

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.fontSize = 18, // Default font size
    this.textColor = Colors.black, // Default text/icon color
    this.height = 50, // Default button height
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed, // Executes callback when pressed
      icon: Icon(icon, color: textColor), // Leading icon
      label: Text(
        label,
        style: TextStyle(
          fontSize: fontSize, // Customizable text size
          color: textColor, // Customizable text color
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height), // Ensures button height
        foregroundColor: textColor, // Sets text & icon color for the button
      ),
    );
  }
}
