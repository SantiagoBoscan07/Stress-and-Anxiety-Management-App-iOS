import 'package:flutter/material.dart';
import '../Components/CalendarComponent.dart';
import 'SelfReflectionScreen.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF69808D),
      appBar: AppBar(
        title: const Text("Calendar"),
        backgroundColor: const Color(0xFF546E7A),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Make image responsive to screen width
            Image.asset(
              'assets/logo.png',
              width: screenWidth * 0.3, // 30% of screen width
              height: screenWidth * 0.3,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            ReusableCalendar(
              onContinue: (selectedDate) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SelfReflectScreen(selectedDate: selectedDate),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
