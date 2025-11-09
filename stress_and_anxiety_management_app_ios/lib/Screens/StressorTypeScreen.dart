import 'package:flutter/material.dart';
import '../Database/LocalDatabase.dart';
import 'StressorDetailScreen.dart';

class StressorTypeScreen extends StatefulWidget {
  final DateTime selectedDate;

  const StressorTypeScreen({super.key, required this.selectedDate});

  @override
  State<StressorTypeScreen> createState() => _StressorTypeScreenState();
}

class _StressorTypeScreenState extends State<StressorTypeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {'label': 'Home', 'color': Colors.orange, 'icon': Icons.home},
    {'label': 'School', 'color': Colors.blue, 'icon': Icons.school},
    {'label': 'Social', 'color': Colors.purple, 'icon': Icons.people},
    {'label': 'Work', 'color': Colors.green, 'icon': Icons.work},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedCategory();
  }

  Future<void> _loadSavedCategory() async {
    final data = await dbHelper.getStressor(widget.selectedDate);
    setState(() {
      selectedCategory = data?['category'] as String?;
    });
  }

  Future<void> saveCategory(String category) async {
    await dbHelper.insertStressor(widget.selectedDate, category);
    setState(() => selectedCategory = category);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StressorDetailScreen(
          selectedDate: widget.selectedDate,
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: const Text('Daily Stressor'),
        backgroundColor: const Color(0xFF546E7A),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select the main stressor:',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Pick the area of life that feels most stressful for you.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // ensures vertical centering
                children: categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => saveCategory(cat['label']),
                      icon: Icon(cat['icon'], color: Colors.white),
                      label: Text(cat['label'], style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cat['color'],
                        minimumSize: Size(screenWidth * 0.8, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
