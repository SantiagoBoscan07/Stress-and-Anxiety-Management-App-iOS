import 'package:flutter/material.dart';
import '../Components/QuestionCard.dart';
import '../Database/LocalDatabase.dart';

class SelfReflectScreen extends StatefulWidget {
  final DateTime selectedDate;

  const SelfReflectScreen({super.key, required this.selectedDate});

  @override
  State<SelfReflectScreen> createState() => _SelfReflectScreenState();
}

class _SelfReflectScreenState extends State<SelfReflectScreen> {
  final List<String> whoOptions = [
    "Select a question...",
    "Who inspires you the most and why?",
    "Who do you trust deeply in your life?",
    "Who do you want to be in five years?"
  ];

  final List<String> whatOptions = [
    "Select a question...",
    "What are your biggest strengths?",
    "What makes you feel happy?",
  ];

  final List<String> whenOptions = [
    "Select a question...",
    "When was the last time you felt proud?",
    "When do you feel most productive?",
  ];

  final List<String> whereOptions = [
    "Select a question...",
    "Where do you feel most at peace?",
    "Where do you see yourself in a year?",
  ];

  final List<String> whyOptions = [
    "Select a question...",
    "Why do you pursue your current goals?",
    "Why do you feel stuck in any area?",
  ];

  String? whoValue, whatValue, whenValue, whereValue, whyValue;
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadReflectionForDate(widget.selectedDate);
  }

  Future<void> _loadReflectionForDate(DateTime date) async {
    final reflections = await dbHelper.getReflectionsByDate(date);
    if (reflections.isNotEmpty) {
      final entry = reflections.first;
      setState(() {
        whoValue = entry['who'];
        whatValue = entry['what'];
        whenValue = entry['when_question'];
        whereValue = entry['where_question'];
        whyValue = entry['why_question'];
      });
    }
  }

  String? validateSelection(String? value, List<String> options) {
    if (value == null || value == options[0]) return 'Please select a question';
    return null;
  }

  Future<void> saveReflection() async {
    if ([whoValue, whatValue, whenValue, whereValue, whyValue]
        .any((v) => v == null || v.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please answer all questions!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await dbHelper.insertReflection(
      who: whoValue!,
      what: whatValue!,
      when: whenValue!,
      where: whereValue!,
      why: whyValue!,
      date: widget.selectedDate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reflection saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Delete only reflections for the selected date
  Future<void> deleteReflectionsForSelectedDate() async {
    await dbHelper.deleteReflectionsByDate(widget.selectedDate);
    setState(() {
      whoValue = whoOptions[0];
      whatValue = whatOptions[0];
      whenValue = whenOptions[0];
      whereValue = whereOptions[0];
      whyValue = whyOptions[0];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reflections for selected date deleted."),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: const Text("Self-Reflection"),
        backgroundColor: const Color(0xFF546E7A), // AppBar background color
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white, // <-- set AppBar title text to white
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Back arrow white
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            QuestionCard(
              title: "Who?",
              options: whoOptions,
              selectedValue: whoValue,
              errorText: validateSelection(whoValue, whoOptions),
              onChanged: (val) => setState(() => whoValue = val),
            ),
            QuestionCard(
              title: "What?",
              options: whatOptions,
              selectedValue: whatValue,
              errorText: validateSelection(whatValue, whatOptions),
              onChanged: (val) => setState(() => whatValue = val),
            ),
            QuestionCard(
              title: "When?",
              options: whenOptions,
              selectedValue: whenValue,
              errorText: validateSelection(whenValue, whenOptions),
              onChanged: (val) => setState(() => whenValue = val),
            ),
            QuestionCard(
              title: "Where?",
              options: whereOptions,
              selectedValue: whereValue,
              errorText: validateSelection(whereValue, whereOptions),
              onChanged: (val) => setState(() => whereValue = val),
            ),
            QuestionCard(
              title: "Why?",
              options: whyOptions,
              selectedValue: whyValue,
              errorText: validateSelection(whyValue, whyOptions),
              onChanged: (val) => setState(() => whyValue = val),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: saveReflection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF556874),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      "Save Reflection",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: deleteReflectionsForSelectedDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB00020),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text(
                      "Delete Reflection for Date",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
