import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double fontSize;
  final Color textColor;
  final double height;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.fontSize = 18,
    this.textColor = Colors.black,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height),
        foregroundColor: textColor, // ensures text & icon color
      ),
    );
  }
}
