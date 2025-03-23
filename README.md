# LinguaLift


https://github.com/user-attachments/assets/a8baf1b5-66f5-4f75-96cc-ad33b859a5f5


LinguaLift is a smart tongue-strengthening mouthpiece and mobile application designed specifically for ALS therapy. The app works with a specialized sensor device to track, measure, and improve tongue strength and movement through guided exercises.

## Features

- **Personalized Exercise Routines**: ML-powered exercise recommendations based on user performance data
- **Real-time Feedback**: Visual pressure meter to guide proper tongue technique
- **Progress Tracking**: Comprehensive charts and statistics to monitor improvements
- **Therapist Integration**: Connect with healthcare professionals for remote monitoring
- **Exercise Library**: Various tongue-strengthening exercises for different difficulty levels
- **Reminders & Scheduling**: Smart notifications to maintain consistent therapy

## Technology

- Built with Flutter for cross-platform compatibility
- Implemented machine learning model that analyzes pressure patterns, consistency, and fatigue indicators
- Dynamic exercise difficulty adjustment based on previous session performance metrics
- Bluetooth connectivity for real-time data from the mouthpiece sensor
- Secure HIPAA-compliant data storage and analysis
- Backend API integration for therapist monitoring portal

## Machine Learning Implementation

The core of LinguaLift is our proprietary machine learning algorithm that:
- Processes raw sensor data to extract meaningful pressure patterns
- Identifies early signs of fatigue during exercises
- Personalizes exercise intensity based on user capability
- Automatically adjusts difficulty levels based on performance trends
- Predicts optimal exercise types for maximum therapeutic benefit

## Installation

### Prerequisites
- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- iOS 12.0+ / Android 5.0+

### Setup
1. Clone the repository:
   ```
   git clone https://github.com/sajeenth/LinguaLift.git
   ```
2. Navigate to the project directory:
   ```
   cd LinguaLift
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run
   ```

## App Screens

- **Home Screen**: Overview of progress, streak, and AI-recommended exercises
- **Exercise Screen**: Real-time feedback during tongue exercises with ML-driven guidance
- **Progress Screen**: Detailed charts showing strength and endurance improvements with predictive trends
- **Profile Screen**: User information and secure connection with therapist
- **Settings Screen**: Customize notifications, device connections, and app preferences

## Hardware Integration

The app works with the LinguaLift mouthpiece device which:
- Anchors securely to the upper teeth like a partial retainer
- Contains a high-precision pressure sensor to detect tongue movement and force
- Connects wirelessly to the app via Bluetooth
- Transmits 100+ data points per second for real-time analysis
- Is made from biocompatible, food-safe materials

## License

This project is licensed under the MIT License - see the LICENSE file for details.
