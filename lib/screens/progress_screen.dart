// lib/screens/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _selectedPeriod = 'Week'; // 'Week', 'Month', 'Year'
  String _selectedExerciseId = '1';

  // Mock exercise data
  final List<Map<String, dynamic>> _exercises = [
    {
      'id': '1',
      'name': 'Tongue Press',
      'description':
          'Press your tongue firmly against the sensor pad and hold.',
    },
    {
      'id': '2',
      'name': 'Swallow Exercise',
      'description':
          'Practice swallowing while applying gentle pressure on the sensor.',
    },
    {
      'id': '3',
      'name': 'Tongue Strength',
      'description':
          'Apply maximum pressure with your tongue against the sensor.',
    },
  ];

  // Mock session data
  final List<Map<String, dynamic>> _sessions = [
    {
      'id': '1',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'duration': 120,
      'completed': true,
      'exercises': [
        {
          'id': '1',
          'maxForce': 165.4,
          'avgForce': 130.2,
          'reps': 8,
          'holdTime': 3.2,
        },
        {
          'id': '2',
          'maxForce': 140.0,
          'avgForce': 110.5,
          'reps': 12,
          'holdTime': 2.5,
        },
      ],
    },
    {
      'id': '2',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'duration': 180,
      'completed': true,
      'exercises': [
        {
          'id': '1',
          'maxForce': 155.7,
          'avgForce': 120.8,
          'reps': 7,
          'holdTime': 3.0,
        },
        {
          'id': '3',
          'maxForce': 178.3,
          'avgForce': 145.1,
          'reps': 5,
          'holdTime': 4.8,
        },
      ],
    },
    {
      'id': '3',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'duration': 150,
      'completed': false,
      'exercises': [
        {
          'id': '1',
          'maxForce': 150.2,
          'avgForce': 118.5,
          'reps': 6,
          'holdTime': 2.8,
        },
      ],
    },
    {
      'id': '4',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'duration': 120,
      'completed': true,
      'exercises': [
        {
          'id': '1',
          'maxForce': 145.8,
          'avgForce': 115.0,
          'reps': 5,
          'holdTime': 2.5,
        },
        {
          'id': '2',
          'maxForce': 132.0,
          'avgForce': 105.5,
          'reps': 10,
          'holdTime': 2.2,
        },
      ],
    },
    {
      'id': '5',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'duration': 90,
      'completed': true,
      'exercises': [
        {
          'id': '1',
          'maxForce': 140.3,
          'avgForce': 110.1,
          'reps': 5,
          'holdTime': 2.3,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Tracking'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time period selector
              _buildPeriodSelector(),

              const SizedBox(height: 16),

              // Exercise selector
              _buildExerciseSelector(),

              const SizedBox(height: 24),

              // Summary card
              _buildSummaryCard(),

              const SizedBox(height: 24),

              // Progress charts
              _buildProgressCharts(),

              const SizedBox(height: 24),

              // Recent sessions
              _buildRecentSessions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      color: const Color(0xFFE6ECF8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPeriodButton('Week'),
            _buildPeriodButton('Month'),
            _buildPeriodButton('Year'),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = _selectedPeriod == period;

    return TextButton(
      onPressed: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      style: TextButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        foregroundColor:
            isSelected ? Colors.white : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(period),
    );
  }

  Widget _buildExerciseSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedExerciseId,
      decoration: InputDecoration(
        labelText: 'Select Exercise',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: _exercises.map((exercise) {
        return DropdownMenuItem<String>(
          value: exercise['id'] as String,
          child: Text(exercise['name'] as String),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedExerciseId = value;
          });
        }
      },
    );
  }

  Widget _buildSummaryCard() {
    // Get exercise name
    final selectedExercise = _exercises.firstWhere(
      (exercise) => exercise['id'] == _selectedExerciseId,
      orElse: () => _exercises.first,
    );

    return Card(
      color: const Color(0xFFE6ECF8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise Summary: ${selectedExercise['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('4', 'Sessions', Icons.fitness_center),
                _buildSummaryItem('165 g', 'Max Force', Icons.speed),
                _buildSummaryItem(
                  '+15%',
                  'Progress',
                  Icons.trending_up,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String value,
    String label,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? Theme.of(context).primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProgressCharts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Trends',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Maximum Force Chart
        Card(
          color: const Color(0xFFE6ECF8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Maximum Force (g)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Chart
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 30,
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  value.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() % 2 != 0) {
                                return const SizedBox.shrink();
                              }

                              // Mock date values
                              final dates = [
                                DateTime.now().subtract(
                                  const Duration(days: 10),
                                ),
                                DateTime.now().subtract(
                                  const Duration(days: 7),
                                ),
                                DateTime.now().subtract(
                                  const Duration(days: 5),
                                ),
                                DateTime.now().subtract(
                                  const Duration(days: 3),
                                ),
                                DateTime.now().subtract(
                                  const Duration(days: 1),
                                ),
                              ];

                              if (value.toInt() < dates.length) {
                                final date = dates[value.toInt()];
                                final formatter = DateFormat('M/d');

                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    formatter.format(date),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          left: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      minX: 0,
                      maxX: 4,
                      minY: 100,
                      maxY: 200,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 140.3),
                            const FlSpot(1, 145.8),
                            const FlSpot(2, 150.2),
                            const FlSpot(3, 155.7),
                            const FlSpot(4, 165.4),
                          ],
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: Theme.of(context).primaryColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Legend and summary
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Maximum Force (g)',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      // Trend indicator
                      Row(
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '+17.9%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Average Hold Time Chart
        Card(
          color: const Color(0xFFE6ECF8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Average Hold Time (s)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Chart
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 1,
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  value.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() % 2 != 0) {
                                return const SizedBox.shrink();
                              }

                              // Mock date values
                              final dates = [
                                DateTime.now().subtract(
                                  const Duration(days: 10),
                                ),
                                DateTime.now().subtract(
                                  const Duration(days: 7),
                                ),
                                DateTime.now().subtract(
                                  const Duration(days: 5),
                                ),
                                DateTime.now().subtract(
                                  const Duration(days: 3),
                                ),
                                DateTime.now().subtract(
                                  const Duration(days: 1),
                                ),
                              ];

                              if (value.toInt() < dates.length) {
                                final date = dates[value.toInt()];
                                final formatter = DateFormat('M/d');

                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    formatter.format(date),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                          left: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      minX: 0,
                      maxX: 4,
                      minY: 2,
                      maxY: 4,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 2.3),
                            const FlSpot(1, 2.5),
                            const FlSpot(2, 2.8),
                            const FlSpot(3, 3.0),
                            const FlSpot(4, 3.2),
                          ],
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: const Color(
                            0xFFE43673,
                          ), // Different color for variety
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: const Color(0xFFE43673),
                                strokeWidth: 1,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFFE43673).withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Legend and summary
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE43673),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Average Hold Time (s)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Trend indicator
                      Row(
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '+39.1%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Sessions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Session list
        ..._sessions.take(3).map((session) => _buildSessionItem(session)),

        // View all button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('View all sessions feature coming soon'),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('View All History'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionItem(Map<String, dynamic> session) {
    // Format date
    final date = session['date'] as DateTime;
    final timeFormatter = DateFormat('h:mm a');

    // Find the exercise result for selected exercise
    List<Map<String, dynamic>> exerciseResults =
        session['exercises'] as List<Map<String, dynamic>>;
    Map<String, dynamic>? selectedExerciseResult;
    for (var result in exerciseResults) {
      if (result['id'] == _selectedExerciseId) {
        selectedExerciseResult = result;
        break;
      }
    }

    return Card(
      color: const Color(0xFFE6ECF8),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Date container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d').format(date),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Session details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session at ${timeFormatter.format(date)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: ${session['duration'] ~/ 60} min',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (selectedExerciseResult != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Completed ${selectedExerciseResult['reps']} reps with ${selectedExerciseResult['maxForce']}g max',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Session status
            Icon(
              session['completed'] as bool ? Icons.check_circle : Icons.info,
              color:
                  session['completed'] as bool ? Colors.green : Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
