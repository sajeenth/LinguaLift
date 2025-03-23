// lib/models/session.dart
import 'dart:convert';
import 'exercise.dart';

class ExerciseResult {
  final String exerciseId;
  final double maxForce; // Maximum force recorded in grams
  final double avgForce; // Average force in grams
  final int completedReps;
  final double avgHoldTime; // Average hold time in seconds
  final List<double>
  forceReadings; // List of force readings during the exercise

  ExerciseResult({
    required this.exerciseId,
    required this.maxForce,
    required this.avgForce,
    required this.completedReps,
    required this.avgHoldTime,
    required this.forceReadings,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'maxForce': maxForce,
      'avgForce': avgForce,
      'completedReps': completedReps,
      'avgHoldTime': avgHoldTime,
      'forceReadings': forceReadings,
    };
  }

  factory ExerciseResult.fromMap(Map<String, dynamic> map) {
    return ExerciseResult(
      exerciseId: map['exerciseId'],
      maxForce: map['maxForce'],
      avgForce: map['avgForce'],
      completedReps: map['completedReps'],
      avgHoldTime: map['avgHoldTime'],
      forceReadings: List<double>.from(map['forceReadings']),
    );
  }
}

class Session {
  final String id;
  final DateTime date;
  final int durationSeconds;
  final List<ExerciseResult> exerciseResults;
  final String notes;
  final bool completedFullSession;

  Session({
    required this.id,
    required this.date,
    required this.durationSeconds,
    required this.exerciseResults,
    this.notes = '',
    this.completedFullSession = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'durationSeconds': durationSeconds,
      'exerciseResults': exerciseResults.map((x) => x.toMap()).toList(),
      'notes': notes,
      'completedFullSession': completedFullSession,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      date: DateTime.parse(map['date']),
      durationSeconds: map['durationSeconds'],
      exerciseResults: List<ExerciseResult>.from(
        map['exerciseResults']?.map((x) => ExerciseResult.fromMap(x)),
      ),
      notes: map['notes'] ?? '',
      completedFullSession: map['completedFullSession'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source));

  // Generate random sample session data for demo purposes
  static List<Session> getSampleSessions() {
    final List<Session> sessions = [];
    final now = DateTime.now();

    // Generate sessions for the past 14 days
    for (int i = 13; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);

      // Skip some days to simulate missed sessions
      if (i % 5 == 3) continue;

      final results = <ExerciseResult>[];

      // Create random results for 2-3 exercises
      final numExercises = 2 + (i % 2);
      for (int j = 1; j <= numExercises; j++) {
        // Creating a slightly improving trend over time
        final improvement = (13 - i) * 0.5;

        results.add(
          ExerciseResult(
            exerciseId: j.toString(),
            maxForce: 150 + improvement + (date.day % 10),
            avgForce: 120 + improvement,
            completedReps: 8 + (i % 3),
            avgHoldTime: 3.0 + (i % 4) * 0.5,
            forceReadings: List.generate(
              10,
              (index) => 100 + improvement + (index * 5) + (date.day % 20),
            ),
          ),
        );
      }

      sessions.add(
        Session(
          id: 'session_${date.toString()}',
          date: date,
          durationSeconds: 180 + (i * 10),
          exerciseResults: results,
          completedFullSession: i % 7 != 6, // Occasionally mark as incomplete
        ),
      );
    }

    return sessions;
  }
}
