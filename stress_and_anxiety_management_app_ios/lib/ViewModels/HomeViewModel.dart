import 'package:flutter/material.dart';
import '../Components/ActionButton.dart';

class HomeViewModel {
  List<Widget> getButtons() {
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
        onPressed: () {},
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
}
