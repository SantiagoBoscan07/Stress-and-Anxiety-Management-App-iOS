import 'package:flutter/material.dart';
import '../Database/LocalDatabase.dart';

class ControlGaugeScreen extends StatefulWidget {
  final DateTime selectedDate;

  const ControlGaugeScreen({super.key, required this.selectedDate});

  @override
  State<ControlGaugeScreen> createState() => _ControlGaugeScreenState();
}

class _ControlGaugeScreenState extends State<ControlGaugeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  int? selectedSection;

  final List<Map<String, dynamic>> sections = [
    {'label': '1', 'color': Colors.red},
    {'label': '2', 'color': Colors.orange},
    {'label': '3', 'color': Colors.yellow},
    {'label': '4', 'color': Colors.lightGreen},
    {'label': '5', 'color': Colors.green},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedSection();
  }

  Future<void> _loadSavedSection() async {
    final sectionFromDb = await dbHelper.getControlGauge(widget.selectedDate);
    setState(() {
      selectedSection = sectionFromDb;
    });
  }

  Future<void> saveSection(int section) async {
    await dbHelper.insertControlGauge(widget.selectedDate, section);
    setState(() => selectedSection = section);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Control level "$section" saved!'),
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
        title: const Text('Control Gauge'),
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
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Text(
              'How in control do you feel on ${widget.selectedDate.toLocal().toIso8601String().substring(0, 10)}?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // --- Description about the gauge ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Pick the section that best represents how in control you feel today.\n'
                  '1 = least control, 5 = most control. Tap a section to select it!',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Selected section card
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
                  selectedSection != null
                      ? 'Selected Level: $selectedSection'
                      : 'No level selected',
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

          // Gauge buttons
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: sections.map((section) {
                  final int index = int.parse(section['label']);
                  final bool isSelected = selectedSection != null && index <= selectedSection!;
                  return GestureDetector(
                    onTap: () => saveSection(index),
                    child: Container(
                      width: 50,
                      height: 150,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? section['color'] as Color
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          section['label'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Continue button
          if (selectedSection != null)
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
