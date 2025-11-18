import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Screens/HomeScreen.dart';
import 'Screens/AboutScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/SignUpScreen.dart';
import 'Screens/DashboardScreen.dart';
import 'Screens/BreathingExerciseScreen.dart';
import 'Screens/CalendarScreenWithCallback.dart';
import 'Screens/SelfReflectionScreen.dart';
import 'Screens/FaqScreen.dart';
import 'Screens/SettingScreen.dart';
import 'Screens/MoodSelectionScreen.dart';
import 'Screens/ControlGaugeScreen.dart';
import 'Screens/StressorTypeScreen.dart';

/// Entry point of the Flutter application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'reflections.db');
  if (await File(path).exists()) {
    await deleteDatabase(path);
    print('Old database deleted. A fresh database will be created.');
  }
  runApp(const MyApp()); // Runs the root widget of the app
}

/// Root widget of the app, extending StatelessWidget because the app state
/// does not need to be mutable at this level
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the main wrapper that provides material design styling,
    // themes, navigation, and routes to the app.
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Hides the debug banner in the top-right
      title: 'HOWRU.LIFE', // App title shown in task manager or window
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFFA726), // Main orange color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFA726),
          brightness: Brightness.light,
          primary: const Color(0xFFFFA726),
          secondary: const Color(0xFFFFCC02),
          surface: Colors.white,
          background: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFA726),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // Routes define named navigation paths for different screens
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(), // Main home screen
        '/about': (context) => const AboutScreen(), // About screen
        '/dashboard': (context) =>
            const DashboardScreen(), // Dashboard with stats and recent reflections
        '/awareness-questions': (context) =>
            _AwarenessQuestionsWrapper(), // Calendar selection for new reflections
        '/breathing-exercise': (context) =>
            const BreathingExerciseScreen(), // Breathing exercises for stress relief
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/logout': (context) => const LoginScreen(),
        '/faq': (context) => const FaqScreen(), // FAQ Screen
        '/settings': (context) => const SettingScreen(),
        '/mood-selection': (context) => MoodSelectionScreen(selectedDate: DateTime.now()),
        '/control-gauge': (context) => ControlGaugeScreen(selectedDate: DateTime.now()),
        '/stressor-types': (context) => StressorTypeScreen(selectedDate: DateTime.now()),
        // Placeholder screens for features not implemented yet
        '/membership': (context) =>
            const PlaceholderScreen(title: 'Membership'),
      },
    );
  }
}

/// A simple placeholder screen for pages not yet implemented.
/// Accepts a title to display in the AppBar and body.
class PlaceholderScreen extends StatelessWidget {
  final String title; // The title to display in AppBar and body

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the basic material design layout structure:
      // AppBar at the top, Body in the main content area
      appBar: AppBar(
        title: Text(title), // Displays the passed-in title
      ),
      body: Center(
        child: Text(
          'This is the $title page', // Simple placeholder text in the center
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// Wrapper widget that handles the calendar selection to awareness questions flow
class _AwarenessQuestionsWrapper extends StatelessWidget {
  const _AwarenessQuestionsWrapper();

  @override
  Widget build(BuildContext context) {
    return CalendarScreenWithCallback(
      onDateSelected: (selectedDate) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelfReflectScreen(selectedDate: selectedDate),
          ),
        );
      },
    );
  }
}
