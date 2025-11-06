import 'package:flutter/material.dart';
import '../Screens/HomeScreen.dart';
import '../Screens/AboutScreen.dart';
import '../Screens/LoginScreen.dart';
import '../Screens/SignUpScreen.dart';


/// Entry point of the Flutter application
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      debugShowCheckedModeBanner: false, // Hides the debug banner in the top-right
      title: 'HOWRU.LIFE', // App title shown in task manager or window
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Sets default colors for app bars, buttons, etc.
      ),

      // Routes define named navigation paths for different screens
      routes: {
        '/': (context) => const LoginScreen(),
        //'/': (context) => const HomeScreen(), // Default home screen
        '/about': (context) => const AboutScreen(), // About screen
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/logout': (context) => const LoginScreen(),
        // Placeholder screens for features not implemented yet
        '/dashboard': (context) => const PlaceholderScreen(title: 'Dashboard'),
        '/membership': (context) => const PlaceholderScreen(title: 'Membership'),
        '/settings': (context) => const PlaceholderScreen(title: 'Settings'),
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
