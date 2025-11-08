import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final void Function(String?) onChanged;
  final String? errorText;

  const QuestionCard({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2F3941),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF78909C)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedValue ?? options[0],
              dropdownColor: const Color(0xFF3D4C59),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF3D4C59),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF78909C)),
                ),
                errorText: errorText,
              ),
              items: options.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
