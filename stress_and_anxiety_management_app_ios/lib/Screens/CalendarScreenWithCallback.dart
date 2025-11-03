import 'package:flutter/material.dart';
import '../Components/CalendarComponent.dart';

class CalendarScreenWithCallback extends StatelessWidget {
  final void Function(DateTime selectedDate) onDateSelected;

  const CalendarScreenWithCallback({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF69808D),
      appBar: AppBar(
        title: const Text("Select a Date"),
        backgroundColor: const Color(0xFF546E7A), // AppBar background color
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
          Image.asset(
            'assets/logo.png',
            width: 120,
            height: 120,
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
    );
  }
}
