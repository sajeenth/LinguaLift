// lib/config/routes.dart
import 'package:flutter/material.dart';

// Import screens
import '../screens/home_screen.dart';
import '../screens/exercise_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String exercise = '/exercise';
  static const String progress = '/progress';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    exercise: (context) => const ExerciseScreen(),
    progress: (context) => const ProgressScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
