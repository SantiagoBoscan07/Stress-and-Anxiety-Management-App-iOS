import 'package:flutter/material.dart';
import '../Components/ActionButton.dart';
import '../Screens/SelfReflectionScreen.dart';

class HomeViewModel {
  List<Widget> getButtons(BuildContext context) {
    return [
      ActionButton(
        label: 'Dashboard',
        icon: Icons.dashboard,
        onPressed: () {},
      ),
      const SizedBox(height: 12),
      ActionButton(
        label: 'Awareness Questions',
        icon: Icons.help,
        onPressed: ()
        {
          // Navigate to SelfReflectScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelfReflectScreen(),
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      ActionButton(
        label: 'Immediate Exercises',
        icon: Icons.fitness_center,
        onPressed: () {},
      ),
      const SizedBox(height: 12),
      ActionButton(
        label: 'Monthly Calendar',
        icon: Icons.calendar_today,
        onPressed: () {},
      ),
    ];
  }

  List<Map<String, dynamic>> getMenuItems() {
    return [
      {'icon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.help, 'label': 'Awareness Questions'},
      {'icon': Icons.fitness_center, 'label': 'Immediate Exercises'},
      {'icon': Icons.calendar_today, 'label': 'Monthly Calendar'},
    ];
  }
}
