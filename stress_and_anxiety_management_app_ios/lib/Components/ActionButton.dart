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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF546E7A), Color(0xFF78909C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon, 
            color: Colors.white,
            size: 24,
          ),
          label: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: Size.fromHeight(height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }
}
