import 'package:flutter/material.dart';
import '../Components/MainScaffold.dart';
import 'BreathingExerciseDetailScreen.dart';

class BreathingExercisesSelectionScreen extends StatelessWidget {
  const BreathingExercisesSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Exercises',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Logo and Header
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // "Rest your Mind" Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF3D4C59),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Rest your Mind',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Exercises Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF3D4C59),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Exercises',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Exercise Cards
                  _buildExerciseCard(
                    context,
                    'EASE YOUR SLEEP',
                    Icons.access_time,
                    BreathingExerciseType.easeYourSleep,
                  ),
                  const SizedBox(height: 12),
                  _buildExerciseCard(
                    context,
                    'DESTRESS YOUR DAY',
                    Icons.play_arrow,
                    BreathingExerciseType.destressYourDay,
                  ),
                  const SizedBox(height: 12),
                  _buildExerciseCard(
                    context,
                    'STRENGTHEN YOUR FOCUS',
                    Icons.remove_red_eye_outlined,
                    BreathingExerciseType.strengthenYourFocus,
                  ),
                  const SizedBox(height: 12),
                  _buildExerciseCard(
                    context,
                    'PSYCHOLOGICAL SIGH',
                    Icons.refresh,
                    BreathingExerciseType.psychologicalSigh,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, String title, IconData icon, BreathingExerciseType type) {
    return GestureDetector(
      onTap: () => _navigateToExercise(context, type),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF5A6B73),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToExercise(BuildContext context, BreathingExerciseType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreathingExerciseDetailScreen(exerciseType: type),
      ),
    );
  }
}

enum BreathingExerciseType {
  easeYourSleep,
  destressYourDay,
  strengthenYourFocus,
  psychologicalSigh,
}