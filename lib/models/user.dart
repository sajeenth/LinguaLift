// lib/models/user.dart
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final DateTime createdAt;
  final DateTime lastActive;
  final String difficultyLevel; // 'beginner', 'intermediate', 'advanced'
  final Map<String, dynamic> settings;
  final bool isTherapistConnected;
  final String? therapistId;
  final String? therapistName;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl = '',
    required this.createdAt,
    required this.lastActive,
    required this.difficultyLevel,
    required this.settings,
    this.isTherapistConnected = false,
    this.therapistId,
    this.therapistName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'difficultyLevel': difficultyLevel,
      'settings': settings,
      'isTherapistConnected': isTherapistConnected,
      'therapistId': therapistId,
      'therapistName': therapistName,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      lastActive: DateTime.parse(map['lastActive']),
      difficultyLevel: map['difficultyLevel'],
      settings: Map<String, dynamic>.from(map['settings']),
      isTherapistConnected: map['isTherapistConnected'] ?? false,
      therapistId: map['therapistId'],
      therapistName: map['therapistName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  // Get sample user for demo
  static User getSampleUser() {
    return User(
      id: 'user123',
      name: 'Emily Smith',
      email: 'emily.smith@example.com',
      profileImageUrl: 'assets/images/avatar.png',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActive: DateTime.now(),
      difficultyLevel: 'intermediate',
      settings: {
        'notifications': true,
        'remindersEnabled': true,
        'reminderTime': '09:00',
        'bluetoothAutoConnect': true,
        'darkMode': false,
        'soundEffects': true,
      },
      isTherapistConnected: true,
      therapistId: 'therapist456',
      therapistName: 'Dr. Sarah Johnson',
    );
  }
}
