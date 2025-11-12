import 'package:flutter/material.dart';
import '../Components/AboutTextBox.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF708694),
      appBar: AppBar(
        backgroundColor: const Color(0xFF546E7A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo centered at the top - clickable to go home
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false, // Remove all previous routes
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/logo.png', // App logo
                    width: 180,
                    height: 120,
                  ),
                ),
            // Responsive logo
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: screenWidth * 0.5, // 50% of screen width
                height: screenWidth * 0.33, // proportional height
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),

            // Responsive text box
            SizedBox(
              width: double.infinity,
              child: const AboutTextBox(
                text:
                "HowRU is a mental wellness app designed to help users manage anxiety and stress. "
                    "It features a daily mood diary to track emotional patterns and guided breathing exercises "
                    "to quickly reduce anxiety, offering practical tools for building mindfulness and improving mental well-being.",
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
