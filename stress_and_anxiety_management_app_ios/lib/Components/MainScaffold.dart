import 'package:flutter/material.dart';
import 'NavBar.dart';

/// MainScaffold is a reusable widget that provides a consistent layout
/// for screens in the app, including a NavBar at the top and a Drawer menu.
/// It accepts a `body` widget to display the main content of each screen.
class MainScaffold extends StatelessWidget {
  final Widget body; // The main content of the screen
  final String title; // Title displayed in the Drawer header
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Key to control the Scaffold (needed to open the drawer from NavBar)

  MainScaffold({super.key, required this.body, this.title = 'HOWRU.LIFE'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assigns the key so NavBar can control drawer
      backgroundColor: Colors.white, // White background color

      // NavBar at the top of the screen
      appBar: NavBar(scaffoldKey: _scaffoldKey),

      // Drawer menu that slides from the left
      drawer: Drawer(
        backgroundColor: const Color(0xFF708694),
        child: ListView(
          padding: EdgeInsets.zero, // Remove default padding at top
          children: [
            // Drawer header containing the logo and app title
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF546E7A),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false, // Remove all previous routes
                      );
                    },
                    child: Image.asset(
                      'assets/logo.png', // App logo
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between logo and title
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false, // Remove all previous routes
                      );
                    },
                    child: Text(
                      title, // App name
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Features
            _drawerItem(
              icon: Icons.home,
              label: 'Home',
              context: context,
              onTap: () => _navigateTo(context, '/home'),
            ),
            _drawerItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              context: context,
              onTap: () => _navigateTo(context, '/dashboard'),
            ),
            
            // Divider for section separation
            const Divider(color: Colors.white54, thickness: 1, indent: 16, endIndent: 16),
            
            // Tools & Exercises
            _drawerItem(
              icon: Icons.psychology,
              label: 'Self Reflection',
              context: context,
              onTap: () => _navigateTo(context, '/awareness-questions'),
            ),
            _drawerItem(
              icon: Icons.air,
              label: 'Breathing Exercise',
              context: context,
              onTap: () => _navigateTo(context, '/breathing-exercise'),
            ),
            _drawerItem(
              icon: Icons.mood,
              label: 'Mood Tracking',
              context: context,
              onTap: () => _navigateTo(context, '/mood-selection'),
            ),
            _drawerItem(
              icon: Icons.tune,
              label: 'Control Gauge',
              context: context,
              onTap: () => _navigateTo(context, '/control-gauge'),
            ),
            _drawerItem(
              icon: Icons.psychology_outlined,
              label: 'Stressor Types',
              context: context,
              onTap: () => _navigateTo(context, '/stressor-types'),
            ),
            
            // Divider for section separation
            const Divider(color: Colors.white54, thickness: 1, indent: 16, endIndent: 16),
            
            // Information & Support
            _drawerItem(
              icon: Icons.shopping_cart,
              label: 'Membership',
              context: context,
              onTap: () => _navigateTo(context, '/membership'),
            ),
            _drawerItem(
              icon: Icons.question_mark,
              label: 'FAQ',
              context: context,
              onTap: () => _navigateTo(context, '/faq'),
            ),
            _drawerItem(
              icon: Icons.info,
              label: 'About',
              context: context,
              onTap: () => _navigateTo(context, '/about'),
            ),
            
            // Divider for section separation
            const Divider(color: Colors.white54, thickness: 1, indent: 16, endIndent: 16),
            
            // Account
            _drawerItem(
              icon: Icons.settings,
              label: 'Settings',
              context: context,
              onTap: () => _navigateTo(context, '/settings'),
            ),
            _drawerItem(
              icon: Icons.logout,
              label: 'Logout',
              context: context,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/logout', (route) => false),
            ),
          ],
        ),
      ),

      // The main body content of the screen
      body: body,
    );
  }

  /// Helper method to create a Drawer item with icon, label, and tap behavior
  Widget _drawerItem({
    required IconData icon,
    required String label,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white), // Icon displayed at start
      title: Text(label, style: const TextStyle(color: Colors.white)), // Label text
      onTap: onTap, // Action when tapped
    );
  }

  /// Navigates to a named route and closes the drawer first
  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushNamed(context, route); // Navigate to the specified route
  }
}
