import 'package:flutter/material.dart';
import '../Database/LocalDatabase.dart';

class MoodSelectionScreen extends StatefulWidget {
  final DateTime selectedDate;

  const MoodSelectionScreen({super.key, required this.selectedDate});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String? selectedMood;

  final List<Map<String, dynamic>> moods = [
    {'label': 'Happy', 'color': Colors.green},
    {'label': 'Sad', 'color': Colors.blue},
    {'label': 'Angry', 'color': Colors.red},
    {'label': 'Neutral', 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedMood();
  }

  Future<void> _loadSavedMood() async {
    final moodFromDb = await dbHelper.getMood(widget.selectedDate);
    setState(() {
      selectedMood = moodFromDb;
    });
  }

  Future<void> saveMood(String mood) async {
    await dbHelper.insertMood(widget.selectedDate, mood);
    setState(() => selectedMood = mood);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood "$mood" saved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        backgroundColor: const Color(0xFF546E7A),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Title at the top
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Text(
              'Select your mood for ${widget.selectedDate.toLocal().toIso8601String().substring(0, 10)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Mood card always visible
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: Colors.white24,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Text(
                  selectedMood != null
                      ? 'Selected Mood: $selectedMood'
                      : 'No mood selected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Center the mood buttons
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: moods.map((mood) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () => saveMood(mood['label'] as String),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mood['color'] as Color,
                        minimumSize: Size(screenWidth * 0.8, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        mood['label'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Continue button only visible after mood is selected
          if (selectedMood != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to next activity
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF556874),
                  minimumSize: Size(screenWidth * 0.8, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
