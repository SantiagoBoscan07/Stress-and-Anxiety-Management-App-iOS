import 'package:flutter/material.dart';
import '../Components/AboutTextBox.dart';

/// AboutScreen displays information about the app, including a logo
/// at the top and a descriptive text box below.
/// This screen has a simple AppBar with a back button for navigation.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sets the background color of the screen
      backgroundColor: const Color(0xFF708694),

      // AppBar with back button
      appBar: AppBar(
        backgroundColor: const Color(0xFF546E7A), // AppBar background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back arrow
          onPressed: () => Navigator.pop(context), // Returns to previous screen
        ),
        title: const Text(
          'About Us', // AppBar title
          style: TextStyle(color: Colors.white), // White text
        ),
        centerTitle: true, // Center the title in the AppBar
      ),

      // Main content: logo at top, text box below
      body: SingleChildScrollView(
        // Allows scrolling if content exceeds screen height
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // Logo centered at the top
            Center(
              child: Image.asset(
                'assets/logo.png', // App logo
                width: 180,
                height: 120,
              ),
            ),
            const SizedBox(height: 32), // Space between logo and text box

            // Text box describing the app
            // Uses AboutTextBox component with slightly larger font
            const AboutTextBox(
              text:
              "HowRU is a mental wellness app designed to help users manage anxiety and stress. "
                  "It features a daily mood diary to track emotional patterns and guided breathing exercises "
                  "to quickly reduce anxiety, offering practical tools for building mindfulness and improving mental well-being.",
              fontSize: 18, // Slightly larger text for readability
            ),
          ],
        ),
      ),
    );
  }
}
