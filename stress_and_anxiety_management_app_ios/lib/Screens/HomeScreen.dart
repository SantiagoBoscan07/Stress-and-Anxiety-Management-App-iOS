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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFFFFA726), // Orange
              Color(0xFFFFB74D), // Light Orange
              Color(0xFFFFCC02), // Yellow
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Small gradient section for header only
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header row with drawer button
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: spacingSmall),
                    // Centered logo (smaller)
                    Image.asset(
                      'assets/logo.png',
                      width: logoWidth * 0.7,
                      height: logoHeight * 0.7,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              // White content section that covers most of the screen
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.04,
                      40,
                      screenWidth * 0.04,
                      spacingMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: spacingMedium),

                        // Use WelcomeCard component with updated styling
                        FutureBuilder<String?>(
                          future: _userNameFuture,
                          builder: (context, snapshot) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFFF8F0,
                                ), // Very light orange background
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFFA726,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: WelcomeCard(
                                fontSize: cardFontSize,
                                padding: screenWidth * 0.04,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: spacingMedium),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: viewModel.getButtons(context).map((button) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: spacingSmall / 2,
                              ),
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
                ),
              ),
            ],
          ),
        ),
      ),
      // Add drawer for navigation
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFA726), // Orange
                Color(0xFFFFB74D), // Light Orange
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFFF6B35)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/logo.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'HOWRU.LIFE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _drawerItem(
                icon: Icons.home,
                label: 'Home',
                onTap: () => Navigator.pop(context),
              ),
              _drawerItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
                onTap: () => _navigateTo('/dashboard'),
              ),
              _drawerItem(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () => _navigateToSettings(context),
              ),
              _drawerItem(
                icon: Icons.info,
                label: 'About',
                onTap: () => _navigateTo('/about'),
              ),
              _drawerItem(
                icon: Icons.logout,
                label: 'Logout',
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/logout',
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  void _navigateTo(String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }
}
