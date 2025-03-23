// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings values with default states
  bool _notificationsEnabled = true;
  bool _remindersEnabled = true;
  String _reminderTime = '09:00';
  bool _bluetoothAutoConnect = true;
  bool _darkMode = false;
  bool _soundEffects = true;
  bool _isScanning = false;
  List<Map<String, dynamic>> _availableDevices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationSettings(),
            const Divider(height: 1),
            _buildDeviceSettings(),
            const Divider(height: 1),
            _buildAppSettings(),
            const Divider(height: 1),
            _buildAccountSettings(),
            const Divider(height: 1),
            _buildAboutSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Notifications'),

        // Notifications toggle
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive app notifications'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;

              // If turning off notifications, also turn off reminders
              if (!value) {
                _remindersEnabled = false;
              }
            });
          },
          secondary: const Icon(Icons.notifications),
        ),

        // Daily reminders toggle
        SwitchListTile(
          title: const Text('Daily Exercise Reminders'),
          subtitle: const Text('Get reminded to do your daily exercises'),
          value: _remindersEnabled,
          onChanged: _notificationsEnabled
              ? (value) {
                  setState(() {
                    _remindersEnabled = value;
                  });
                }
              : null,
          secondary: const Icon(Icons.alarm),
        ),

        // Reminder time picker
        if (_remindersEnabled && _notificationsEnabled)
          ListTile(
            title: const Text('Reminder Time'),
            subtitle: Text(_reminderTime),
            leading: const Icon(Icons.access_time),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showTimePickerDialog();
            },
          ),
      ],
    );
  }

  void _showTimePickerDialog() async {
    final initialTime = TimeOfDay(
      hour: int.parse(_reminderTime.split(':')[0]),
      minute: int.parse(_reminderTime.split(':')[1]),
    );

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _reminderTime =
            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Widget _buildDeviceSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Device'),

        // Auto-connect toggle
        SwitchListTile(
          title: const Text('Auto-connect to Device'),
          subtitle: const Text('Automatically connect to last used device'),
          value: _bluetoothAutoConnect,
          onChanged: (value) {
            setState(() {
              _bluetoothAutoConnect = value;
            });
          },
          secondary: const Icon(Icons.bluetooth),
        ),

        // Scan for devices button
        ListTile(
          title: const Text('Scan for Devices'),
          leading: const Icon(Icons.search),
          trailing: _isScanning
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _isScanning
              ? null
              : () {
                  _scanForDevices();
                },
        ),

        // Show available devices if any
        if (_availableDevices.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'Available Devices',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          ...List.generate(_availableDevices.length, (index) {
            final device = _availableDevices[index];
            return ListTile(
              title: Text(device['name'] as String),
              subtitle: Text('Signal: ${device['rssi']} dBm'),
              leading: const Icon(Icons.bluetooth_connected),
              trailing: ElevatedButton(
                onPressed: () {
                  _connectToDevice(device);
                },
                child: const Text('Connect'),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            );
          }),
        ],
      ],
    );
  }

  Future<void> _scanForDevices() async {
    setState(() {
      _isScanning = true;
    });

    // Simulate device scanning
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _availableDevices = [
        {'id': 'LL:01:23:45:67', 'name': 'LinguaLift-01', 'rssi': -75},
        {'id': 'LL:98:76:54:32', 'name': 'LinguaLift-02', 'rssi': -82},
      ];
      _isScanning = false;
    });
  }

  void _connectToDevice(Map<String, dynamic> device) {
    // Show connection progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Connecting to ${device['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Please wait while we connect to your device...'),
          ],
        ),
      ),
    );

    // Simulate connection delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close dialog

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to ${device['name']}'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear devices list after connecting
      setState(() {
        _availableDevices = [];
      });
    });
  }

  Widget _buildAppSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('App Settings'),

        // Dark mode toggle
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: _darkMode,
          onChanged: (value) {
            setState(() {
              _darkMode = value;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Theme changing will be available in future update',
                ),
              ),
            );
          },
          secondary: const Icon(Icons.dark_mode),
        ),

        // Sound effects toggle
        SwitchListTile(
          title: const Text('Sound Effects'),
          subtitle: const Text('Play sounds during exercises'),
          value: _soundEffects,
          onChanged: (value) {
            setState(() {
              _soundEffects = value;
            });
          },
          secondary: const Icon(Icons.volume_up),
        ),

        // Language selection
        ListTile(
          title: const Text('Language'),
          subtitle: const Text('English (US)'),
          leading: const Icon(Icons.language),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Language options will be available in future update',
                ),
              ),
            );
          },
        ),

        // Data backup
        ListTile(
          title: const Text('Backup & Restore'),
          subtitle: const Text('Manage your data'),
          leading: const Icon(Icons.backup),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Backup features will be available in future update',
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    // Mock user data
    const userName = 'Emily Smith';
    const userEmail = 'emily.smith@example.com';
    const isTherapistConnected = true;
    const therapistName = 'Dr. Sarah Johnson';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Account'),

        // Account details
        ListTile(
          title: const Text(userName),
          subtitle: const Text(userEmail),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Text('E', style: TextStyle(color: Colors.white)),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Account editing will be available in future update',
                ),
              ),
            );
          },
        ),

        // Change password
        ListTile(
          title: const Text('Change Password'),
          leading: const Icon(Icons.lock),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Password change will be available in future update',
                ),
              ),
            );
          },
        ),

        // Therapist connection
        ListTile(
          title: const Text('Therapist Connection'),
          subtitle: isTherapistConnected
              ? const Text('Connected to $therapistName')
              : const Text('Not connected'),
          leading: const Icon(Icons.medical_services),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Therapist connection settings will be available in future update',
                ),
              ),
            );
          },
        ),

        // Sign out button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              _showSignOutDialog();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Sign out will be available in future update',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('About'),

        // App version
        ListTile(
          title: const Text('App Version'),
          subtitle: const Text('1.0.0 (Beta)'),
          leading: const Icon(Icons.info),
        ),

        // Privacy policy
        ListTile(
          title: const Text('Privacy Policy'),
          leading: const Icon(Icons.privacy_tip),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Privacy policy will be available in future update',
                ),
              ),
            );
          },
        ),

        // Terms of service
        ListTile(
          title: const Text('Terms of Service'),
          leading: const Icon(Icons.description),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Terms of service will be available in future update',
                ),
              ),
            );
          },
        ),

        // Help & support
        ListTile(
          title: const Text('Help & Support'),
          leading: const Icon(Icons.help),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showHelpDialog();
          },
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Contact Us',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('Email: support@lingualift.com'),
            Text('Phone: (555) 123-4567'),
            SizedBox(height: 16),
            Text(
              'Hours of Operation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('Monday - Friday: 9:00 AM - 5:00 PM'),
            Text('Saturday - Sunday: Closed'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CLOSE'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Contact form will be available in future update',
                  ),
                ),
              );
            },
            child: const Text('CONTACT US'),
          ),
        ],
      ),
    );
  }
}
