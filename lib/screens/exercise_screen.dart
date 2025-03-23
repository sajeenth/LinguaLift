// lib/screens/exercise_screen.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ExerciseScreen extends StatefulWidget {
  final Map<String, dynamic>? exerciseData;

  const ExerciseScreen({Key? key, this.exerciseData}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  bool _isConnected = false;
  bool _isConnecting = true;
  bool _isExerciseActive = false;
  double _currentForce = 0;
  double _maxForce = 0;
  int _completedReps = 0;
  int _remainingTime = 0;
  int _holdTime = 0;
  bool _isHolding = false;

  late AnimationController _repAnimationController;
  late Animation<double> _repAnimation;

  Timer? _exerciseTimer;
  Timer? _forceSimulationTimer;

  // Random for simulating force data
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for rep counter
    _repAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _repAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _repAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Set initial remaining time from exercise data or default
    _remainingTime = widget.exerciseData?['duration'] ?? 60;

    // Simulate connecting
    _simulateConnection();
  }

  @override
  void dispose() {
    _exerciseTimer?.cancel();
    _forceSimulationTimer?.cancel();
    _repAnimationController.dispose();
    super.dispose();
  }

  // Simulate device connection
  Future<void> _simulateConnection() async {
    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isConnected = true;
      _isConnecting = false;
    });
  }

  // Start the exercise session with mock data
  void _startExercise() {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect to the device first')),
      );
      return;
    }

    setState(() {
      _isExerciseActive = true;
      _currentForce = 0;
      _maxForce = 0;
      _completedReps = 0;
      _remainingTime = widget.exerciseData?['duration'] ?? 60;
    });

    // Start exercise timer
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _endExercise();
        }
      });
    });

    // Simulate force data
    _forceSimulationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _simulateForceData();
    });
  }

  // Simulate force data from device
  void _simulateForceData() {
    if (!_isExerciseActive) return;

    // Base value + noise
    final baseValue = 10.0;
    final noise = _random.nextDouble() * 5;

    // Occasional peak to simulate tongue press
    final hasPeak = _random.nextDouble() < 0.1;
    final peak = hasPeak ? 50 + _random.nextDouble() * 100 : 0;

    final value = baseValue + noise + peak;

    setState(() {
      _currentForce = value;

      // Update max force if current force is higher
      if (value > _maxForce) {
        _maxForce = value;
      }

      // Simulate hold detection
      final targetForce = 150.0; // Target force in grams

      if (value >= targetForce * 0.7) {
        if (!_isHolding) {
          _isHolding = true;
          _holdTime = 0;
        } else {
          _holdTime++;

          // Check if hold is complete (target hold time reached)
          final targetHoldTime = (widget.exerciseData?['holdTime'] ?? 3) *
              10; // Convert to 100ms units
          if (_holdTime >= targetHoldTime) {
            _holdTime = 0;
            _isHolding = false;
            _completedReps++;

            // Animate rep counter
            _repAnimationController.forward(from: 0.0);
          }
        }
      } else {
        // Reset hold if force drops below threshold
        _isHolding = false;
        _holdTime = 0;
      }
    });
  }

  // End the exercise session
  void _endExercise() {
    _exerciseTimer?.cancel();
    _forceSimulationTimer?.cancel();

    setState(() {
      _isExerciseActive = false;
    });

    // Show completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exercise Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            Text('You completed $_completedReps reps!'),
            Text('Maximum force: ${_maxForce.toStringAsFixed(1)}g'),
            Text(
              'Duration: ${widget.exerciseData?['duration'] ~/ 60} minutes',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: const Text('DONE'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startExercise(); // Restart exercise
            },
            child: const Text('REPEAT'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseData?['name'] ?? 'Exercise'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise details
            Card(
              color: const Color(0xFFE6ECF8),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exerciseData?['description'] ??
                          'Focus on proper technique',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildExerciseDetail(
                          '${widget.exerciseData?['duration'] ~/ 60 ?? 1} min',
                          'Duration',
                          Icons.timer_outlined,
                        ),
                        _buildExerciseDetail(
                          '${widget.exerciseData?['reps'] ?? 5} reps',
                          'Target',
                          Icons.repeat,
                        ),
                        _buildExerciseDetail(
                          '${widget.exerciseData?['holdTime'] ?? 3} sec',
                          'Hold Time',
                          Icons.hourglass_bottom,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Connection status
            if (_isConnecting)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Connecting to device...'),
                  ],
                ),
              )
            else if (!_isConnected)
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.bluetooth_disabled,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Not connected to device',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _simulateConnection,
                      child: const Text('CONNECT'),
                    ),
                  ],
                ),
              )
            else if (!_isExerciseActive)
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.bluetooth_connected,
                      size: 48,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Device connected',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _startExercise,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'START EXERCISE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    // Timer
                    Card(
                      color: const Color(0xFFE6ECF8),
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Time Remaining:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Force meter
                    Card(
                      color: const Color(0xFFE6ECF8),
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Force',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Current:'),
                                Text(
                                  '${_currentForce.toStringAsFixed(1)} g',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isHolding
                                        ? Colors.green
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Maximum:'),
                                Text(
                                  '${_maxForce.toStringAsFixed(1)} g',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Force meter visualization
                            Container(
                              height: 24,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  // Filled portion
                                  FractionallySizedBox(
                                    widthFactor: (_currentForce / 300).clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    heightFactor: 1.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _isHolding
                                            ? Colors.green
                                            : Theme.of(
                                                context,
                                              ).primaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),

                                  // Target marker
                                  Positioned(
                                    left: MediaQuery.of(context).size.width *
                                            0.5 -
                                        32,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 4,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Scale markers
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '0',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    '150 g',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    '300',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Rep counter
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Completed Reps',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          ScaleTransition(
                            scale: _repAnimation,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$_completedReps',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Target: ${widget.exerciseData?['reps'] ?? 5}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Stop button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _endExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('STOP EXERCISE'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDetail(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
