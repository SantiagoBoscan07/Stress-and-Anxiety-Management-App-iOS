import 'package:flutter/material.dart';
import '../ViewModels/HomeViewModel.dart';
import '../Components/MainScaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel();
    double screenWidth = MediaQuery.of(context).size.width;

    return MainScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Responsive app logo
            Image.asset(
              'assets/logo.png',
              width: screenWidth * 0.5, // 50% of screen width
              height: screenWidth * 0.45, // proportional height
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),

            // Welcome message
            Card(
              color: Colors.blueGrey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Welcome User, what would you like to do?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons - wrap in a Column to ensure vertical stacking
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: viewModel.getButtons(context).map((button) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: double.infinity, // button fills available width
                    child: button,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
