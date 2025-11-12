import 'package:flutter/material.dart';
import '../Database/LocalDatabase.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  /// Load saved username from database
  Future<void> _loadUserName() async {
    final name = await dbHelper.getUserName();
    if (name != null) {
      setState(() {
        _nameController.text = name;
      });
    }
  }

  /// Save username to database
  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a name!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await dbHelper.saveUserName(name);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Name saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Delete all user data including username and reflections
  Future<void> _deleteAllData() async {
    await dbHelper.deleteAllData();
    setState(() {
      _nameController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All data deleted!"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Dynamic sizes
    final labelFontSize = screenWidth * 0.045;
    final inputFontSize = screenWidth * 0.045;
    final buttonFontSize = screenWidth * 0.045;
    final spacingSmall = screenHeight * 0.015;
    final spacingMedium = screenHeight * 0.03;
    final buttonPaddingVertical = screenHeight * 0.02;
    final borderRadius = screenWidth * 0.03;

    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF546E7A),
        centerTitle: true,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: spacingMedium,
          horizontal: screenWidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your name",
              style: TextStyle(
                color: Colors.white70,
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: spacingSmall),
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white, fontSize: inputFontSize),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF3D4C59),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: spacingMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveName,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  "Save Name",
                  style: TextStyle(color: Colors.white, fontSize: buttonFontSize),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF556874),
                  padding: EdgeInsets.symmetric(vertical: buttonPaddingVertical),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacingSmall),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _deleteAllData,
                icon: const Icon(Icons.delete, color: Colors.white),
                label: Text(
                  "Delete All Data",
                  style: TextStyle(color: Colors.white, fontSize: buttonFontSize),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB00020),
                  padding: EdgeInsets.symmetric(vertical: buttonPaddingVertical),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
