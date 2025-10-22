import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NavBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF546E7A),
      title: const Text(
        'HOWRU.LIFE',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }

  // Required for PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
