import 'package:flutter/material.dart';

/// NavBar is a reusable AppBar widget that includes a menu button
/// which opens the Drawer from a given Scaffold key.
/// It implements PreferredSizeWidget to specify the AppBar height.
class NavBar extends StatelessWidget implements PreferredSizeWidget {
  // The GlobalKey of the Scaffold that this NavBar controls.
  // This key is used to open the Drawer when the menu button is pressed.
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NavBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF546E7A), // Dark blue-grey background
      title: const Text(
        'HOWRU.LIFE', // AppBar title text
        style: TextStyle(color: Colors.white), // White title for contrast
      ),
      leading: IconButton(
        icon:
            const Icon(Icons.menu, color: Colors.white), // Hamburger menu icon
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
        // Opens the Drawer when pressed using the provided scaffoldKey
      ),
    );
  }

  // Required property for PreferredSizeWidget to tell Flutter
  // how tall the AppBar should be
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
