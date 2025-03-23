// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'exercise_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Mock data
  final String _userName = "Emily Smith";
  final List<Map<String, dynamic>> _exercises = [
    {
      'id': '1',
      'name': 'Tongue Press',
      'description':
          'Press your tongue firmly against the sensor pad and hold.',
      'duration': 60,
      'reps': 5,
      'holdTime': 3,
      'difficulty': 'beginner',
    },
    {
      'id': '2',
      'name': 'Swallow Exercise',
      'description':
          'Practice swallowing while applying gentle pressure on the sensor.',
      'duration': 120,
      'reps': 10,
      'holdTime': 2,
      'difficulty': 'beginner',
    },
    {
      'id': '3',
      'name': 'Tongue Strength',
      'description':
          'Apply maximum pressure with your tongue against the sensor.',
      'duration': 90,
      'reps': 8,
      'holdTime': 5,
      'difficulty': 'intermediate',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const ExerciseListScreen();
      case 2:
        return const ProgressScreen();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App bar with greeting
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Welcome Back, ${_userName.split(' ')[0]}',
                style: const TextStyle(
                  color: Color(0xFF2C3E50),
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: Colors.black87,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                color: Colors.black87,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Stats section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildStatsSection(),
            ),
          ),

          // Today's recommended exercises
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Exercises',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1; // Switch to exercises tab
                      });
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),

          // Exercise cards
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final exercise = _exercises[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildExerciseCard(exercise),
                );
              }, childCount: _exercises.length),
            ),
          ),

          // Tips section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTipsCard(),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sunday',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          'March 23, 2025',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFE6ECF8),
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('7', 'Day Streak', Icons.calendar_today),
                _buildStatItem('3', 'Last Session', Icons.fitness_center),
                _buildStatItem('+12%', 'Progress', Icons.trending_up),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, color: Color.fromARGB(255, 95, 103, 103)),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    String difficultyText = exercise['difficulty'];
    Color difficultyColor;

    switch (difficultyText.toLowerCase()) {
      case 'beginner':
        difficultyColor = Colors.green;
        break;
      case 'intermediate':
        difficultyColor = Colors.orange;
        break;
      case 'advanced':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = Colors.grey;
    }

    return Card(
      elevation: 0.5,
      color: const Color(0xFFE6ECF8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with title and difficulty badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: difficultyColor, width: 1),
                  ),
                  child: Text(
                    difficultyText[0].toUpperCase() +
                        difficultyText.substring(1),
                    style: TextStyle(
                      color: difficultyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              exercise['description'],
              style: const TextStyle(color: Color.fromARGB(255, 95, 103, 103)),
            ),

            const SizedBox(height: 16),

            // Exercise details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildExerciseDetail(
                  '${(exercise['duration'] ?? 60) ~/ 60} min',
                  'Duration',
                  Icons.timer_outlined,
                ),
                _buildExerciseDetail(
                  '${exercise['reps']} reps',
                  'Repetitions',
                  Icons.repeat,
                ),
                _buildExerciseDetail(
                  '${exercise['holdTime']} sec',
                  'Hold Time',
                  Icons.hourglass_bottom,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Start button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExerciseScreen(exerciseData: exercise),
                    ),
                  );
                },
                child: const Text('START EXERCISE'),
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
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, color: Color.fromARGB(255, 95, 103, 103)),
        ),
      ],
    );
  }

  Widget _buildTipsCard() {
    return Card(
      elevation: 0.5,
      color: const Color(0xFFE6ECF8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Daily Tip',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'For best results, try to maintain consistent pressure throughout each exercise. Focus on quality over quantity.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Did you know? Regular tongue exercises can improve swallowing function by up to 20% according to recent studies.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: const Color(0xFFD2DCF4),
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: const Color.fromARGB(255, 84, 84, 84),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center_outlined),
          activeIcon: Icon(Icons.fitness_center),
          label: 'Exercises',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Beginner', 'Intermediate', 'Advanced'];
    final exercises = [
      {
        'id': '1',
        'name': 'Tongue Press',
        'description':
            'Press your tongue firmly against the sensor pad and hold.',
        'duration': 60,
        'reps': 5,
        'holdTime': 3,
        'difficulty': 'beginner',
      },
      {
        'id': '2',
        'name': 'Swallow Exercise',
        'description':
            'Practice swallowing while applying gentle pressure on the sensor.',
        'duration': 120,
        'reps': 10,
        'holdTime': 2,
        'difficulty': 'beginner',
      },
      {
        'id': '3',
        'name': 'Tongue Strength',
        'description':
            'Apply maximum pressure with your tongue against the sensor.',
        'duration': 90,
        'reps': 8,
        'holdTime': 5,
        'difficulty': 'intermediate',
      },
      {
        'id': '4',
        'name': 'Tongue Endurance',
        'description': 'Apply moderate pressure for an extended time.',
        'duration': 180,
        'reps': 3,
        'holdTime': 15,
        'difficulty': 'advanced',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Exercises'), elevation: 0),
      body: Column(
        children: [
          // Categories filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = index == 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(categories[index]),
                      onSelected: (selected) {
                        // Filter would be applied here
                      },
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),

          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  color: const Color(0xFFE6ECF8),
                  elevation: 0.5,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      exercise['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(exercise['description'] as String),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(exercise['duration'] as int) ~/ 60} min',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.repeat,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${exercise['reps']} reps',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExerciseScreen(exerciseData: exercise),
                          ),
                        );
                      },
                      child: const Text('START'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
