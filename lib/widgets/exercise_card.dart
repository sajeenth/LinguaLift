// lib/widgets/exercise_card.dart
import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../config/app_theme.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;
  final bool showDetails;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    this.onTap,
    this.showDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                      exercise.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  _buildDifficultyBadge(exercise.difficulty),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                exercise.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              if (showDetails) ...[
                const SizedBox(height: 16),

                // Exercise details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailItem(
                      context,
                      Icons.timer_outlined,
                      '${exercise.durationSeconds ~/ 60} min',
                      'Duration',
                    ),
                    _buildDetailItem(
                      context,
                      Icons.repeat,
                      '${exercise.reps} reps',
                      'Repetitions',
                    ),
                    _buildDetailItem(
                      context,
                      Icons.hourglass_bottom,
                      '${exercise.holdSeconds} sec',
                      'Hold Time',
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // Start button
              if (onTap != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('START EXERCISE'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Build difficulty badge with appropriate color
  Widget _buildDifficultyBadge(String difficulty) {
    Color badgeColor;

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        badgeColor = Colors.green;
        break;
      case 'intermediate':
        badgeColor = Colors.orange;
        break;
      case 'advanced':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        difficulty[0].toUpperCase() + difficulty.substring(1),
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Build detail item with icon and text
  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
