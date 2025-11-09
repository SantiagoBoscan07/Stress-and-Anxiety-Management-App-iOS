import 'package:flutter/material.dart';
import '../Database/LocalDatabase.dart';
import 'HomeScreen.dart';

class StressorDetailScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String category;

  const StressorDetailScreen({super.key, required this.selectedDate, required this.category});

  @override
  State<StressorDetailScreen> createState() => _StressorDetailScreenState();
}

class _StressorDetailScreenState extends State<StressorDetailScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String? selectedDetail;
  late List<String> options;

  @override
  void initState() {
    super.initState();
    _loadOptions();
    _loadSavedDetail();
  }

  void _loadOptions() {
    switch (widget.category) {
      case 'Home':
        options = ['Family', 'Chores', 'Bills', 'Relationships', 'Noise', 'Other'];
        break;
      case 'School':
        options = ['Exams', 'Homework', 'Teachers', 'Classmates', 'Projects', 'Other'];
        break;
      case 'Social':
        options = ['Friends', 'Events', 'Social Media', 'Dating', 'Community', 'Other'];
        break;
      case 'Work':
        options = ['Deadlines', 'Boss', 'Colleagues', 'Meetings', 'Workload', 'Other'];
        break;
      default:
        options = ['Other'];
    }
  }

  Future<void> _loadSavedDetail() async {
    final data = await dbHelper.getStressor(widget.selectedDate);
    setState(() {
      selectedDetail = data?['detail'] as String?;
    });
  }

  Future<void> saveDetail(String detail) async {
    await dbHelper.updateStressorDetail(widget.selectedDate, detail);
    setState(() => selectedDetail = detail);
  }

  Future<void> deleteData() async {
    await dbHelper.deleteStressor(widget.selectedDate);
    setState(() => selectedDetail = null);
    Navigator.pop(context); // Go back to category selection
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: const Text('Daily Stressor Details'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Which stressors affect you in this area today?',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Select the specific stressor that affects you in this area.',
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
                children: options.map((opt) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () => saveDetail(opt),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: Size(screenWidth * 0.8, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(opt, style: const TextStyle(color: Colors.white)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (selectedDetail != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white24,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Text(
                    'Selected: $selectedDetail',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF556874),
                  minimumSize: Size(screenWidth * 0.8, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: deleteData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(screenWidth * 0.8, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Erase Data', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
