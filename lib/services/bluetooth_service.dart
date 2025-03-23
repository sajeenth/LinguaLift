// lib/services/bluetooth_service.dart
import 'dart:async';
import 'dart:math';

// Mock Bluetooth service that simulates connecting to and getting data from the LinguaLift device
class BluetoothService {
  bool _isConnected = false;
  Timer? _mockDataTimer;
  final _forceDataController = StreamController<double>.broadcast();

  // Public stream to listen for force data
  Stream<double> get forceDataStream => _forceDataController.stream;

  // Connection status
  bool get isConnected => _isConnected;

  // Connect to device
  Future<bool> connect() async {
    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    // 80% chance of successful connection for demo
    _isConnected = Random().nextDouble() < 0.8;

    if (_isConnected) {
      // Start sending mock data
      _startMockDataStream();
    }

    return _isConnected;
  }

  // Disconnect from device
  Future<void> disconnect() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isConnected = false;
    _stopMockDataStream();
  }

  // Scan for available devices
  Future<List<Map<String, dynamic>>> scanForDevices() async {
    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 3));

    // Return mock devices
    return [
      {
        'id': 'LL:01:23:45:67',
        'name': 'LinguaLift-01',
        'rssi': -75,
        'isConnectable': true,
      },
      {
        'id': 'LL:98:76:54:32',
        'name': 'LinguaLift-02',
        'rssi': -82,
        'isConnectable': true,
      },
    ];
  }

  // Start exercise mode - calibrates device and prepares for readings
  Future<bool> startExerciseMode() async {
    if (!_isConnected) return false;

    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  // End exercise mode
  Future<bool> endExerciseMode() async {
    if (!_isConnected) return false;

    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Start sending mock force data
  void _startMockDataStream() {
    _mockDataTimer?.cancel();
    _mockDataTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // Base value + noise + occasional peaks to simulate presses
      final baseValue = 10.0;
      final noise = Random().nextDouble() * 5;

      // Occasionally add a peak to simulate tongue press
      final hasPeak = Random().nextDouble() < 0.1;
      final peak = hasPeak ? 50 + Random().nextDouble() * 100 : 0;

      final value = baseValue + noise + peak;
      _forceDataController.add(value);
    });
  }

  // Stop mock data stream
  void _stopMockDataStream() {
    _mockDataTimer?.cancel();
    _mockDataTimer = null;
  }

  // Clean up resources
  void dispose() {
    _mockDataTimer?.cancel();
    _forceDataController.close();
  }
}

// Singleton instance
final bluetoothService = BluetoothService();
