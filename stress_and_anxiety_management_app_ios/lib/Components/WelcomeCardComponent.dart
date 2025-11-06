import 'package:flutter/material.dart';
import '../Database/LocalDatabase.dart';

class WelcomeCard extends StatelessWidget {
  final double fontSize;
  final double padding;

  const WelcomeCard({
    super.key,
    this.fontSize = 18,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return ValueListenableBuilder<String?>(
      valueListenable: dbHelper.userNameNotifier,
      builder: (context, userName, _) {
        userName ??= "User";
        return Card(
          color: Colors.blueGrey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Text(
              'Welcome $userName, what would you like to do?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ),
        );
      },
    );
  }
}
