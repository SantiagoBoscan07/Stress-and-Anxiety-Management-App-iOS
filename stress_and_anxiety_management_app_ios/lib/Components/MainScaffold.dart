import 'package:flutter/material.dart';
import 'NavBar.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MainScaffold({super.key, required this.body, this.title = 'HOWRU.LIFE'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF708694),

      appBar: NavBar(scaffoldKey: _scaffoldKey),

      drawer: Drawer(
        backgroundColor: const Color(0xFF708694),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF546E7A),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              context: context,
              onTap: () => _navigateTo(context, '/dashboard'),
            ),
            _drawerItem(
              icon: Icons.shopping_cart,
              label: 'Membership',
              context: context,
              onTap: () => _navigateTo(context, '/membership'),
            ),
            _drawerItem(
              icon: Icons.settings,
              label: 'Settings',
              context: context,
              onTap: () => _navigateTo(context, '/settings'),
            ),
            _drawerItem(
              icon: Icons.info,
              label: 'About',
              context: context,
              onTap: () => _navigateTo(context, '/about'),
            ),
            _drawerItem(
              icon: Icons.logout,
              label: 'Logout',
              context: context,
              onTap: () => _navigateTo(context, '/logout'),
            ),
          ],
        ),
      ),

      body: body,
    );
  }

  // Drawer item builder for cleaner code
  Widget _drawerItem({
    required IconData icon,
    required String label,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to $route (placeholder)')),
    );
  }
}
