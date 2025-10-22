import 'package:flutter/material.dart';
import '../ViewModels/HomeViewModel.dart';
import '../Components/MainScaffold.dart';

/// HomeScreen is the main landing page of the app.
/// It displays the logo, a welcome message, and a list of action buttons.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the HomeViewModel which provides the list of action buttons
    final viewModel = HomeViewModel();

    // MainScaffold is a reusable layout that already includes
    // the top NavBar and side Drawer with menu items
    return MainScaffold(
      body: SingleChildScrollView(
        // Allows the content to scroll if the screen is small
        padding: const EdgeInsets.all(16),
        child: Column(
          // Column stacks widgets vertically
          children: [
            // App logo at the top
            Image.asset(
              'assets/logo.png',
              width: 200,
              height: 180,
            ),
            const SizedBox(height: 24), // Space between logo and card

            // Welcome message displayed in a styled Card
            Card(
              color: Colors.blueGrey[700], // Dark card background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: const Padding(
                padding: EdgeInsets.all(16), // Inner spacing for text
                child: Text(
                  'Welcome User, what would you like to do?',
                  textAlign: TextAlign.center, // Centered text
                  style: TextStyle(
                    color: Colors.white, // White text for contrast
                    fontSize: 18, // Slightly larger font for readability
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24), // Space between card and buttons

            // Display the list of action buttons from the ViewModel
            Column(children: viewModel.getButtons()),
          ],
        ),
      ),
    );
  }
}
