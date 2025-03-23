// lib/widgets/feedback_meter.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class FeedbackMeter extends StatelessWidget {
  final double value; // Current value (0.0 to 1.0)
  final double targetValue; // Target value (0.0 to 1.0)
  final double minValue; // Minimum value for display purposes
  final double maxValue; // Maximum value for display purposes
  final bool showTarget; // Whether to show target marker
  final String? label; // Optional label to display
  final bool showValue; // Whether to show current value
  final String unit; // Unit of measurement to display

  const FeedbackMeter({
    Key? key,
    required this.value,
    this.targetValue = 0.7,
    this.minValue = 0.0,
    this.maxValue = 300.0,
    this.showTarget = true,
    this.label,
    this.showValue = true,
    this.unit = 'g',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate normalized value (0.0 to 1.0)
    final normalizedValue = (value - minValue) / (maxValue - minValue);
    final clampedValue = normalizedValue.clamp(0.0, 1.0);

    // Calculate target position
    final normalizedTarget = (targetValue - minValue) / (maxValue - minValue);
    final clampedTarget = normalizedTarget.clamp(0.0, 1.0);

    // Determine color based on value
    Color meterColor;
    if (clampedValue < 0.3) {
      meterColor = Colors.grey;
    } else if (clampedValue < clampedTarget * 0.8) {
      meterColor = AppTheme.warningColor;
    } else if (clampedValue >= clampedTarget) {
      meterColor = AppTheme.successColor;
    } else {
      meterColor = AppTheme.primaryColor;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional label
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(label!, style: Theme.of(context).textTheme.titleMedium),
          ),

        // Current value display
        if (showValue)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Force:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${value.toStringAsFixed(1)} $unit',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: meterColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

        // Meter container
        Container(
          height: 24,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Filled portion
              FractionallySizedBox(
                widthFactor: clampedValue,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: meterColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Target marker
              if (showTarget)
                Positioned(
                  left: MediaQuery.of(context).size.width * clampedTarget - 2,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 4, color: Colors.black54),
                ),
            ],
          ),
        ),

        // Scale markers
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minValue.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (showTarget)
                Text(
                  '${targetValue.toStringAsFixed(0)} $unit',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              Text(
                maxValue.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
