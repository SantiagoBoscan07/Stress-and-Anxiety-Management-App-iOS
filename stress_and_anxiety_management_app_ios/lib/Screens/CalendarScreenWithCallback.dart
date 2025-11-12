import 'package:flutter/material.dart';
import '../Components/CalendarComponent.dart';

class CalendarScreenWithCallback extends StatelessWidget {
  final void Function(DateTime selectedDate) onDateSelected;

  const CalendarScreenWithCallback({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF69808D),
      appBar: AppBar(
        title: const Text("Select a Date"),
        backgroundColor: const Color(0xFF546E7A),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Back arrow white
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false, // Remove all previous routes
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/logo.png',
                width: 120,
                height: 120,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ReusableCalendar(
            onContinue: (selectedDate) {
              onDateSelected(selectedDate);
            },
          ),
          const SizedBox(height: 24),
        ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: screenWidth * 0.3, // 30% of screen width
              height: screenWidth * 0.3,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            ReusableCalendar(
              onContinue: (selectedDate) {
                onDateSelected(selectedDate);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
