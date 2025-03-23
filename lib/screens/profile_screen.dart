// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 16),
            _buildTherapistConnection(context),
            const SizedBox(height: 16),
            _buildStatistics(context),
            const SizedBox(height: 16),
            _buildRecentActivity(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    // Mock user data
    const userName = 'Emily Smith';
    const userEmail = 'emily.smith@example.com';
    const difficultyLevel = 'intermediate';
    final createdAt = DateTime.now().subtract(const Duration(days: 30));

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          // Profile image and basic info
          Row(
            children: [
              // Profile image
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Text(
                  'E',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A75BC), // Primary color
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      userName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      userEmail,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        difficultyLevel.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Member since
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Member since ${DateFormat('MMMM yyyy').format(createdAt)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTherapistConnection(BuildContext context) {
    // Mock therapist data
    const isConnected = false;

    if (!isConnected) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          color: const Color(0xFFE6ECF8),
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Connect with your Therapist',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Share your progress with your Speech-Language Pathologist to receive personalized guidance.',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Therapist connection feature coming soon',
                        ),
                      ),
                    );
                  },
                  child: const Text('Connect Therapist'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildStatistics(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFFE6ECF8),
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        '82%',
                        'Adherence',
                        Icons.calendar_today,
                      ),
                      _buildDivider(),
                      _buildStatItem(
                        context,
                        '14',
                        'Total Sessions',
                        Icons.fitness_center,
                      ),
                      _buildDivider(),
                      _buildStatItem(
                        context,
                        '+15%',
                        'Improvement',
                        Icons.trending_up,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(context, '23', 'Days Active', Icons.timer),
                      _buildDivider(),
                      _buildStatItem(
                        context,
                        '7',
                        'Current Streak',
                        Icons.local_fire_department,
                        color: const Color(0xFFE43673), // Accent color
                      ),
                      _buildDivider(),
                      _buildStatItem(
                        context,
                        '12',
                        'Best Streak',
                        Icons.emoji_events,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: 40,
      child: VerticalDivider(
        color: Colors.grey.shade300,
        thickness: 1,
        width: 1,
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? Theme.of(context).primaryColor, size: 24),
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

  Widget _buildRecentActivity(BuildContext context) {
    // Mock activity data
    final activities = [
      {
        'type': 'exercise',
        'title': 'Completed 3 exercises',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'duration': 8,
        'completed': true,
      },
      {
        'type': 'milestone',
        'title': 'Reached 10 sessions milestone',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'icon': Icons.emoji_events,
      },
      {
        'type': 'exercise',
        'title': 'Completed 2 exercises',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'duration': 12,
        'completed': true,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to progress screen
                  Navigator.of(context).pushNamed('/progress');
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Activity list
          Column(
            children: activities.map((activity) {
              return _buildActivityItem(context, activity);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
  ) {
    final date = activity['date'] as DateTime;
    final dateFormatter = DateFormat('MMM d, y');
    final timeFormatter = DateFormat('h:mm a');

    IconData iconData;
    Color iconColor;

    if (activity['type'] == 'exercise') {
      iconData = Icons.fitness_center;
      iconColor = Theme.of(context).primaryColor;
    } else if (activity['type'] == 'milestone') {
      iconData = activity['icon'] as IconData? ?? Icons.emoji_events;
      iconColor = Colors.amber;
    } else {
      iconData = Icons.event_note;
      iconColor = Colors.grey;
    }

    return Card(
      color: const Color(0xFFE6ECF8),
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Activity icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: iconColor),
            ),

            const SizedBox(width: 16),

            // Activity details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dateFormatter.format(date)} at ${timeFormatter.format(date)}',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 96, 95, 95),
                        fontSize: 14),
                  ),
                ],
              ),
            ),

            // Duration or icon
            if (activity['type'] == 'exercise')
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${activity['duration']} min',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    activity['completed'] as bool
                        ? Icons.check_circle
                        : Icons.error,
                    color: activity['completed'] as bool
                        ? Colors.green
                        : Colors.orange,
                    size: 16,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
