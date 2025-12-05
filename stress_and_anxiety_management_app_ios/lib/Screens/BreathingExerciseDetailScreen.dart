import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'BreathingExercisesSelectionScreen.dart';

class BreathingExerciseDetailScreen extends StatefulWidget {
  final BreathingExerciseType exerciseType;

  const BreathingExerciseDetailScreen({super.key, required this.exerciseType});

  @override
  State<BreathingExerciseDetailScreen> createState() => _BreathingExerciseDetailScreenState();
}

class _BreathingExerciseDetailScreenState extends State<BreathingExerciseDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _progressController;
  late AnimationController _rotationController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _rotationAnimation;
  
  Timer? _cycleTimer;
  int _currentCycle = 0;
  int _totalCycles = 5;
  String _currentPhase = 'Ready';
  bool _isActive = false;

  // Exercise-specific configurations
  late Map<String, dynamic> _exerciseConfig;
  
  @override
  void initState() {
    super.initState();
    _setupExerciseConfig();
    _initializeAnimations();
  }

  void _setupExerciseConfig() {
    switch (widget.exerciseType) {
      case BreathingExerciseType.easeYourSleep:
        _exerciseConfig = {
          'title': 'Ease Your Sleep',
          'description': 'Slow, deep breathing to prepare your body for restful sleep.',
          'instructions': 'Breathe in for 6 seconds, hold for 2, exhale for 8 seconds.',
          'inhaleSeconds': 6,
          'holdSeconds': 2,
          'exhaleSeconds': 8,
          'totalSeconds': 16,
          'color': const Color(0xFF9C27B0),
          'icon': Icons.bedtime,
        };
        break;
      case BreathingExerciseType.destressYourDay:
        _exerciseConfig = {
          'title': 'Destress Your Day',
          'description': 'Quick stress relief with balanced breathing patterns.',
          'instructions': 'Breathe in for 4 seconds, hold for 4, exhale for 6 seconds.',
          'inhaleSeconds': 4,
          'holdSeconds': 4,
          'exhaleSeconds': 6,
          'totalSeconds': 14,
          'color': const Color(0xFF4CAF50),
          'icon': Icons.spa,
        };
        break;
      case BreathingExerciseType.strengthenYourFocus:
        _exerciseConfig = {
          'title': 'Strengthen Your Focus',
          'description': 'Box breathing technique to enhance concentration and mental clarity.',
          'instructions': 'Breathe in for 4 seconds, hold for 4, exhale for 4, hold for 4.',
          'inhaleSeconds': 4,
          'holdSeconds': 4,
          'exhaleSeconds': 4,
          'holdAfterExhaleSeconds': 4,
          'totalSeconds': 16,
          'color': const Color(0xFF2196F3),
          'icon': Icons.center_focus_strong,
        };
        break;
      case BreathingExerciseType.psychologicalSigh:
        _exerciseConfig = {
          'title': 'Psychological Sigh',
          'description': 'Double inhale technique for rapid stress relief and nervous system reset.',
          'instructions': 'Short inhale, second inhale, long exhale. Repeat for immediate calm.',
          'inhaleSeconds': 2,
          'secondInhaleSeconds': 1,
          'exhaleSeconds': 6,
          'totalSeconds': 9,
          'color': const Color(0xFFFF9800),
          'icon': Icons.psychology,
        };
        break;
    }
  }

  void _initializeAnimations() {
    _breathingController = AnimationController(
      duration: Duration(seconds: _exerciseConfig['totalSeconds'] as int),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: Duration(seconds: _totalCycles * (_exerciseConfig['totalSeconds'] as int)),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 80.0,
      end: 160.0,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_progressController);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_rotationController);
    
    _breathingController.addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (!_isActive) return;
    
    if (status == AnimationStatus.completed) {
      _currentCycle++;
      if (_currentCycle >= _totalCycles) {
        _stopExercise();
      } else {
        _breathingController.reset();
        _breathingController.forward();
      }
    }
  }

  void _startExercise() {
    setState(() {
      _isActive = true;
      _currentCycle = 0;
      _currentPhase = _getPhaseText(0);
    });
    
    _progressController.forward();
    _breathingController.forward();
    _rotationController.repeat();
    _startPhaseTimer();
  }

  void _startPhaseTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isActive) {
        timer.cancel();
        return;
      }
      
      double progress = _breathingController.value;
      setState(() {
        _currentPhase = _getPhaseForProgress(progress);
      });
    });
  }

  String _getPhaseText(int seconds) {
    switch (widget.exerciseType) {
      case BreathingExerciseType.easeYourSleep:
        if (seconds <= _exerciseConfig['inhaleSeconds']) return 'Breathe In';
        if (seconds <= _exerciseConfig['inhaleSeconds'] + _exerciseConfig['holdSeconds']) return 'Hold';
        return 'Breathe Out';
      case BreathingExerciseType.destressYourDay:
        if (seconds <= _exerciseConfig['inhaleSeconds']) return 'Breathe In';
        if (seconds <= _exerciseConfig['inhaleSeconds'] + _exerciseConfig['holdSeconds']) return 'Hold';
        return 'Breathe Out';
      case BreathingExerciseType.strengthenYourFocus:
        if (seconds <= 4) return 'Breathe In';
        if (seconds <= 8) return 'Hold';
        if (seconds <= 12) return 'Breathe Out';
        return 'Hold';
      case BreathingExerciseType.psychologicalSigh:
        if (seconds <= 2) return 'First Inhale';
        if (seconds <= 3) return 'Second Inhale';
        return 'Long Exhale';
    }
  }

  String _getPhaseForProgress(double progress) {
    int totalSeconds = _exerciseConfig['totalSeconds'] as int;
    int currentSecond = (progress * totalSeconds).floor();
    return _getPhaseText(currentSecond);
  }

  void _stopExercise() {
    setState(() {
      _isActive = false;
      _currentPhase = 'Complete';
    });
    
    _breathingController.stop();
    _rotationController.stop();
    _progressController.reset();
    _breathingController.reset();
    _rotationController.reset();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _progressController.dispose();
    _rotationController.dispose();
    _cycleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3941),
      appBar: AppBar(
        title: Text(_exerciseConfig['title']),
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
                    gradient: LinearGradient(
                      colors: [_exerciseConfig['color'], _exerciseConfig['color'].withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _exerciseConfig['icon'],
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _exerciseConfig['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _exerciseConfig['description'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _exerciseConfig['instructions'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
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
                        valueColor: AlwaysStoppedAnimation<Color>(_exerciseConfig['color']),
                        minHeight: 8,
                      ),
                    ],
                  );
                },
              ),
              
              const Spacer(),
              
              // Breathing Animation
              _buildBreathingAnimation(),
              
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
                        backgroundColor: _exerciseConfig['color'],
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

  Widget _buildBreathingAnimation() {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathingAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Column(
          children: [
            _buildAnimationForExerciseType(),
            const SizedBox(height: 20),
            Text(
              _currentPhase,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (_isActive)
              Text(
                _getInstructionText(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAnimationForExerciseType() {
    switch (widget.exerciseType) {
      case BreathingExerciseType.easeYourSleep:
        return _buildMoonAnimation();
      case BreathingExerciseType.destressYourDay:
        return _buildWaveAnimation();
      case BreathingExerciseType.strengthenYourFocus:
        return _buildSquareAnimation();
      case BreathingExerciseType.psychologicalSigh:
        return _buildDoubleCircleAnimation();
    }
  }

  Widget _buildMoonAnimation() {
    return Container(
      width: _breathingAnimation.value,
      height: _breathingAnimation.value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _exerciseConfig['color'].withOpacity(0.8),
            _exerciseConfig['color'].withOpacity(0.4),
            _exerciseConfig['color'].withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _exerciseConfig['color'].withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.bedtime,
          color: Colors.white,
          size: _breathingAnimation.value / 4,
        ),
      ),
    );
  }

  Widget _buildWaveAnimation() {
    return Transform.rotate(
      angle: _rotationAnimation.value,
      child: Container(
        width: _breathingAnimation.value,
        height: _breathingAnimation.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_breathingAnimation.value / 4),
          gradient: RadialGradient(
            colors: [
              _exerciseConfig['color'].withOpacity(0.8),
              _exerciseConfig['color'].withOpacity(0.4),
              _exerciseConfig['color'].withOpacity(0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: _exerciseConfig['color'].withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.spa,
            color: Colors.white,
            size: _breathingAnimation.value / 4,
          ),
        ),
      ),
    );
  }

  Widget _buildSquareAnimation() {
    return Container(
      width: _breathingAnimation.value,
      height: _breathingAnimation.value,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            _exerciseConfig['color'].withOpacity(0.8),
            _exerciseConfig['color'].withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _exerciseConfig['color'].withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.center_focus_strong,
          color: Colors.white,
          size: _breathingAnimation.value / 4,
        ),
      ),
    );
  }

  Widget _buildDoubleCircleAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: _breathingAnimation.value * 1.2,
          height: _breathingAnimation.value * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _exerciseConfig['color'].withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: _exerciseConfig['color'].withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        Container(
          width: _breathingAnimation.value,
          height: _breathingAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _exerciseConfig['color'].withOpacity(0.9),
                _exerciseConfig['color'].withOpacity(0.6),
                _exerciseConfig['color'].withOpacity(0.3),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.psychology,
              color: Colors.white,
              size: _breathingAnimation.value / 4,
            ),
          ),
        ),
      ],
    );
  }

  String _getInstructionText() {
    switch (_currentPhase) {
      case 'Breathe In':
      case 'First Inhale':
        return 'Inhale slowly through your nose...';
      case 'Second Inhale':
        return 'Take another small breath...';
      case 'Hold':
        return 'Hold your breath gently...';
      case 'Breathe Out':
      case 'Long Exhale':
        return 'Exhale slowly through your mouth...';
      default:
        return '';
    }
  }
}