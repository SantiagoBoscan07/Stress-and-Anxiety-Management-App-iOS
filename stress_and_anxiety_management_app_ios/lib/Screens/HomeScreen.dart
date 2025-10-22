import 'package:flutter/material.dart';
import '../ViewModels/HomeViewModel.dart';
import '../Components/MainScaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel();

    return MainScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 200,
              height: 180,
            ),
            const SizedBox(height: 24),
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(children: viewModel.getButtons()),
          ],
        ),
      ),
    );
  }
}
