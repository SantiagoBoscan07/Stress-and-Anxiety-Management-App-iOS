import 'package:flutter/material.dart';
import 'dart:async';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _progressController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _progressAnimation;
  
  Timer? _cycleTimer;
  int _currentCycle = 0;
  int _totalCycles = 5;
  String _currentPhase = 'Breathe In';
  bool _isActive = false;
  
  @override
  void initState() {
    super.initState();
    
    _breathingController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: Duration(seconds: _totalCycles * 8),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 100.0,
      end: 180.0,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_progressController);
    
    _breathingController.addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (!_isActive) return;
    
    if (status == AnimationStatus.completed) {
      setState(() {
        _currentPhase = 'Breathe Out';
      });
      _breathingController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _currentCycle++;
      if (_currentCycle >= _totalCycles) {
        _stopExercise();
      } else {
        setState(() {
          _currentPhase = 'Breathe In';
        });
        _breathingController.forward();
      }
    }
  }

  void _startExercise() {
    setState(() {
      _isActive = true;
      _currentCycle = 0;
      _currentPhase = 'Breathe In';
    });
    
    _progressController.forward();
    _breathingController.forward();
  }

  void _stopExercise() {
    setState(() {
      _isActive = false;
      _currentPhase = 'Ready';
    });
    
    _breathingController.stop();
    _progressController.reset();
    _breathingController.reset();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _progressController.dispose();
    _cycleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: const Text('Breathing Exercise'),
        backgroundColor: const Color(0xFF546E7A),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Instructions Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF546E7A), Color(0xFF78909C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.air,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '4-4 Breathing Exercise',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Inhale for 4 seconds, then exhale for 4 seconds.\nRepeat 5 cycles for optimal relaxation.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Progress Indicator
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Column(
                    children: [
                      Text(
                        'Cycle ${_currentCycle + 1} of $_totalCycles',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: Colors.grey[600],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4CAF50),
                        ),
                        minHeight: 8,
                      ),
                    ],
                  );
                },
              ),
              
              const Spacer(),
              
              // Breathing Animation Circle
              AnimatedBuilder(
                animation: _breathingAnimation,
                builder: (context, child) {
                  return Column(
                    children: [
                      Container(
                        width: _breathingAnimation.value,
                        height: _breathingAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF4CAF50).withOpacity(0.8),
                              const Color(0xFF81C784).withOpacity(0.4),
                              const Color(0xFF81C784).withOpacity(0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _currentPhase,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_isActive)
                        Text(
                          _currentPhase == 'Breathe In' ? 'Inhale slowly...' : 'Exhale gently...',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  );
                },
              ),
              
              const Spacer(),
              
              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!_isActive) ...[
                    ElevatedButton.icon(
                      onPressed: _startExercise,
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text(
                        'Start Exercise',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ] else ...[
                    ElevatedButton.icon(
                      onPressed: _stopExercise,
                      icon: const Icon(Icons.stop, color: Colors.white),
                      label: const Text(
                        'Stop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB00020),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}