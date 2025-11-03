import 'package:flutter/material.dart';
import '../Components/QuestionCard.dart';
import '../Database/LocalDatabase.dart'; // import the DatabaseHelper we created

class SelfReflectScreen extends StatefulWidget {
  const SelfReflectScreen({super.key});

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

  String? validateSelection(String? value, List<String> options) {
    if (value == null || value == options[0]) return 'Please select a question';
    return null;
  }

  Future<void> saveReflection() async {
    final errors = [
      validateSelection(whoValue, whoOptions),
      validateSelection(whatValue, whatOptions),
      validateSelection(whenValue, whenOptions),
      validateSelection(whereValue, whereOptions),
      validateSelection(whyValue, whyOptions),
    ];

    if (errors.any((e) => e != null)) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please answer all questions!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save the reflection as a single row in the database
    await dbHelper.insertReflection(
      who: whoValue!,
      what: whatValue!,
      when: whenValue!,
      where: whereValue!,
      why: whyValue!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reflection saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    print("Saved reflection to database:");
    print({
      "who": whoValue,
      "what": whatValue,
      "when": whenValue,
      "where": whereValue,
      "why": whyValue,
    });
  }

  Future<void> showSavedReflections() async {
    final reflections = await dbHelper.getReflections();
    print("All saved reflections:");
    for (var r in reflections) {
      print(
          "${r['id']}: Who: ${r['who']}, What: ${r['what']}, When: ${r['when_question']}, Where: ${r['where_question']}, Why: ${r['why_question']}, CreatedAt: ${r['createdAt']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: const Text("Self-Reflection"),
        backgroundColor: const Color(0xFF2F3941),
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
                    onPressed: showSavedReflections,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF556874),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.list, color: Colors.white),
                    label: const Text(
                      "Show Saved Reflections",
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
