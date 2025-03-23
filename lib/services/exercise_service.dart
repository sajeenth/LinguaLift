// lib/services/exercise_service.dart
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise.dart';
import '../models/session.dart';

class ExerciseService {
  // In-memory cache
  List<Exercise> _exercises = [];
  List<Session> _sessions = [];

  // Storage keys
  static const String _exercisesKey = 'exercises';
  static const String _sessionsKey = 'sessions';

  // Initialize service with mock data for demo
  Future<void> initialize() async {
    // Load from SharedPreferences or use sample data if not found
    final prefs = await SharedPreferences.getInstance();

    try {
      final exercisesJson = prefs.getStringList(_exercisesKey);
      if (exercisesJson != null && exercisesJson.isNotEmpty) {
        _exercises =
            exercisesJson.map((json) => Exercise.fromJson(json)).toList();
      } else {
        _exercises = Exercise.getSampleExercises();
        await _saveExercises();
      }

      final sessionsJson = prefs.getStringList(_sessionsKey);
      if (sessionsJson != null && sessionsJson.isNotEmpty) {
        _sessions = sessionsJson.map((json) => Session.fromJson(json)).toList();
      } else {
        _sessions = Session.getSampleSessions();
        await _saveSessions();
      }
    } catch (e) {
      // If there's an error, fall back to sample data
      _exercises = Exercise.getSampleExercises();
      _sessions = Session.getSampleSessions();
    }
  }

  // Get all exercises
  List<Exercise> getAllExercises() {
    return List.from(_exercises);
  }

  // Get exercises by difficulty
  List<Exercise> getExercisesByDifficulty(String difficulty) {
    return _exercises
        .where((exercise) => exercise.difficulty == difficulty)
        .toList();
  }

  // Get exercise by ID
  Exercise? getExerciseById(String id) {
    try {
      return _exercises.firstWhere((exercise) => exercise.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get recommended exercises
  List<Exercise> getRecommendedExercises() {
    return _exercises.where((exercise) => exercise.isRecommended).toList();
  }

  // Get all sessions
  List<Session> getAllSessions() {
    return List.from(_sessions)..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get sessions within date range
  List<Session> getSessionsInRange(DateTime start, DateTime end) {
    return _sessions
        .where(
          (session) =>
              session.date.isAfter(start) && session.date.isBefore(end),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get most recent session
  Session? getMostRecentSession() {
    if (_sessions.isEmpty) return null;

    return _sessions.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }

  // Get session by ID
  Session? getSessionById(String id) {
    try {
      return _sessions.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  // Record a new exercise session
  Future<Session> recordSession(
    List<ExerciseResult> results,
    int durationSeconds, [
    String notes = '',
  ]) async {
    final session = Session(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      durationSeconds: durationSeconds,
      exerciseResults: results,
      notes: notes,
      completedFullSession: true,
    );

    _sessions.add(session);

    // Save to persistent storage
    await _saveSessions();

    return session;
  }

  // Save exercises to SharedPreferences
  Future<void> _saveExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final exercisesJson =
        _exercises.map((exercise) => exercise.toJson()).toList();
    await prefs.setStringList(_exercisesKey, exercisesJson);
  }

  // Save sessions to SharedPreferences
  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = _sessions.map((session) => session.toJson()).toList();
    await prefs.setStringList(_sessionsKey, sessionsJson);
  }

  // Calculate exercise statistics for a given ID
  Map<String, dynamic> getExerciseStats(String exerciseId) {
    // Find all sessions with this exercise
    final relevantSessions =
        _sessions
            .where(
              (session) => session.exerciseResults.any(
                (result) => result.exerciseId == exerciseId,
              ),
            )
            .toList();

    if (relevantSessions.isEmpty) {
      return {
        'totalSessions': 0,
        'averageForce': 0.0,
        'maxForce': 0.0,
        'progress': 0.0,
      };
    }

    // Extract all results for this exercise
    final results =
        relevantSessions
            .expand((session) => session.exerciseResults)
            .where((result) => result.exerciseId == exerciseId)
            .toList();

    // Calculate statistics
    final maxForce = results.map((result) => result.maxForce).reduce(max);

    final avgForce =
        results.map((result) => result.avgForce).reduce((a, b) => a + b) /
        results.length;

    // Calculate progress (comparing first vs. last session)
    results.sort(
      (a, b) => relevantSessions
          .firstWhere((s) => s.exerciseResults.contains(a))
          .date
          .compareTo(
            relevantSessions
                .firstWhere((s) => s.exerciseResults.contains(b))
                .date,
          ),
    );

    double progress = 0;
    if (results.length > 1) {
      final firstAvg = results.first.avgForce;
      final lastAvg = results.last.avgForce;
      progress = ((lastAvg - firstAvg) / firstAvg) * 100;
    }

    return {
      'totalSessions': relevantSessions.length,
      'averageForce': avgForce,
      'maxForce': maxForce,
      'progress': progress,
    };
  }
}

// Singleton instance
final exerciseService = ExerciseService();
