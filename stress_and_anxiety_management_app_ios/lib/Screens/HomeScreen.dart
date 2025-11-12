import 'package:flutter/material.dart';
import '../ViewModels/HomeViewModel.dart';
import '../Components/MainScaffold.dart';
import '../Database/LocalDatabase.dart';
import '../Screens/SettingScreen.dart';
import '../Components/WelcomeCardComponent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  late Future<String?> _userNameFuture;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() {
    _userNameFuture = dbHelper.getUserName();
  }

  Future<void> _navigateToSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingScreen()),
    );
    setState(() {
      _loadUserName();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel();
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Dynamic sizing
    final logoWidth = screenWidth * 0.45;
    final logoHeight = screenHeight * 0.22;
    final cardFontSize = screenWidth * 0.045;
    final spacingSmall = screenHeight * 0.015;
    final spacingMedium = screenHeight * 0.025;

    return MainScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: spacingMedium,
          horizontal: screenWidth * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: logoWidth,
              height: logoHeight,
              fit: BoxFit.contain,
            ),
            SizedBox(height: spacingMedium),

            // Use WelcomeCard component
            FutureBuilder<String?>(
              future: _userNameFuture,
              builder: (context, snapshot) {
                return WelcomeCard(
                  fontSize: cardFontSize,
                  padding: screenWidth * 0.04,
                );
              },
            ),

            SizedBox(height: spacingMedium),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: viewModel.getButtons(context).map((button) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: spacingSmall / 2),
                  child: SizedBox(
                    width: double.infinity,
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