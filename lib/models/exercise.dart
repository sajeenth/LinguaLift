// lib/models/exercise.dart
import 'dart:convert';

class Exercise {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int durationSeconds;
  final int reps;
  final int holdSeconds;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final bool isRecommended;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.durationSeconds,
    required this.reps,
    required this.holdSeconds,
    required this.difficulty,
    this.isRecommended = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'durationSeconds': durationSeconds,
      'reps': reps,
      'holdSeconds': holdSeconds,
      'difficulty': difficulty,
      'isRecommended': isRecommended,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      durationSeconds: map['durationSeconds'],
      reps: map['reps'],
      holdSeconds: map['holdSeconds'],
      difficulty: map['difficulty'],
      isRecommended: map['isRecommended'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source));

  // Sample exercises for demo purposes
  static List<Exercise> getSampleExercises() {
    return [
      Exercise(
        id: '1',
        name: 'Tongue Press',
        description:
            'Press your tongue firmly against the sensor pad and hold.',
        imageUrl: 'assets/images/tongue_press.png',
        durationSeconds: 60,
        reps: 5,
        holdSeconds: 3,
        difficulty: 'beginner',
        isRecommended: true,
      ),
      Exercise(
        id: '2',
        name: 'Swallow Exercise',
        description:
            'Practice swallowing while applying gentle pressure on the sensor.',
        imageUrl: 'assets/images/swallow_exercise.png',
        durationSeconds: 120,
        reps: 10,
        holdSeconds: 2,
        difficulty: 'beginner',
      ),
      Exercise(
        id: '3',
        name: 'Tongue Strength',
        description:
            'Apply maximum pressure with your tongue against the sensor.',
        imageUrl: 'assets/images/tongue_strength.png',
        durationSeconds: 90,
        reps: 8,
        holdSeconds: 5,
        difficulty: 'intermediate',
      ),
      Exercise(
        id: '4',
        name: 'Tongue Endurance',
        description: 'Apply moderate pressure for an extended time.',
        imageUrl: 'assets/images/endurance.png',
        durationSeconds: 180,
        reps: 3,
        holdSeconds: 15,
        difficulty: 'advanced',
      ),
    ];
  }
}
