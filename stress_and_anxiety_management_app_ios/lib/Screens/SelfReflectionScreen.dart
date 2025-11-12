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
    "Who do you want to be in five years?",
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
    if ([whoValue, whatValue, whenValue, whereValue, whyValue].any(
      (v) =>
          v == null ||
          v.isEmpty ||
          v == whoOptions[0] ||
          v == whatOptions[0] ||
          v == whenOptions[0] ||
          v == whereOptions[0] ||
          v == whyOptions[0],
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text("Please answer all questions!")),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    if ([whoValue, whatValue, whenValue, whereValue, whyValue]
        .any((v) => v == null || v.isEmpty || v == "Select a question...")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please answer all questions!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      await dbHelper.insertReflection(
        who: whoValue!,
        what: whatValue!,
        when: whenValue!,
        where: whereValue!,
        why: whyValue!,
        date: widget.selectedDate,
      );

      if (mounted) {
        Navigator.pop(context); // Dismiss loading

        // Show congrats dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF3D4C59),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.celebration, color: Colors.amber, size: 64),
                const SizedBox(height: 20),
                const Text(
                  'Congratulations!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You have successfully completed your reflection for today. Keep up the great work on your wellness journey!',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Dismiss dialog
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ); // Navigate to home and clear stack
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );

        // Vibrate for feedback (optional)
        // HapticFeedback.lightImpact();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text("Failed to save reflection. Please try again."),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> deleteReflectionsForSelectedDate() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D4C59),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Reflection?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete the reflection for this date? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await dbHelper.deleteReflectionsByDate(widget.selectedDate);
      setState(() {
        whoValue = whoOptions[0];
        whatValue = whatOptions[0];
        whenValue = whenOptions[0];
        whereValue = whereOptions[0];
        whyValue = whyOptions[0];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.delete_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text("Reflection deleted successfully.")),
              ],
            ),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text("Failed to delete reflection.")),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: const Text("Self-Reflection"),
        backgroundColor: const Color(0xFF546E7A),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white, //set AppBar title text to white
          color: Colors.white,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            // Date Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF546E7A), Color(0xFF78909C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reflection for',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.self_improvement,
                    color: Colors.white70,
                    size: 32,
                  ),
                ],
              ),
            ),

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: saveReflection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF556874),
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
