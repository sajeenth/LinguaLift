// lib/widgets/progress_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';
import '../models/session.dart';

class ProgressChart extends StatelessWidget {
  final List<Session> sessions;
  final String exerciseId;
  final String metricType; // 'maxForce', 'avgForce', 'avgHoldTime'
  final String title;
  final int days;

  const ProgressChart({
    Key? key,
    required this.sessions,
    required this.exerciseId,
    this.metricType = 'maxForce',
    this.title = 'Progress',
    this.days = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter sessions to only include those with the specified exercise
    final relevantSessions =
        sessions
            .where(
              (session) => session.exerciseResults.any(
                (result) => result.exerciseId == exerciseId,
              ),
            )
            .toList();

    // Sort sessions by date
    relevantSessions.sort((a, b) => a.date.compareTo(b.date));

    // Filter to only include sessions from the last X days
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentSessions =
        relevantSessions
            .where((session) => session.date.isAfter(cutoffDate))
            .toList();

    // Extract data points
    final dataPoints = <FlSpot>[];

    for (int i = 0; i < recentSessions.length; i++) {
      final session = recentSessions[i];
      final exerciseResult = session.exerciseResults.firstWhere(
        (result) => result.exerciseId == exerciseId,
      );

      double value;
      switch (metricType) {
        case 'maxForce':
          value = exerciseResult.maxForce;
          break;
        case 'avgForce':
          value = exerciseResult.avgForce;
          break;
        case 'avgHoldTime':
          value = exerciseResult.avgHoldTime;
          break;
        default:
          value = exerciseResult.maxForce;
      }

      dataPoints.add(FlSpot(i.toDouble(), value));
    }

    // Handle empty data case
    if (dataPoints.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                const Icon(
                  Icons.timeline_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No data available for the selected period',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Calculate min and max values for Y axis
    final values = dataPoints.map((point) => point.y).toList();
    final minY = (values.reduce((a, b) => a < b ? a : b) * 0.8).clamp(
      0,
      double.infinity,
    );
    final maxY = values.reduce((a, b) => a > b ? a : b) * 1.2;

    // Get metric unit
    String unit;
    switch (metricType) {
      case 'maxForce':
      case 'avgForce':
        unit = 'g';
        break;
      case 'avgHoldTime':
        unit = 's';
        break;
      default:
        unit = '';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            // Chart
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: (maxY - minY) / 5,
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= recentSessions.length ||
                              value.toInt() % 3 != 0) {
                            return const SizedBox.shrink();
                          }

                          final date = recentSessions[value.toInt()].date;
                          final formatter = DateFormat('M/d');

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              formatter.format(date),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                      left: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  minX: 0,
                  maxX: (dataPoints.length - 1).toDouble(),
                  minY: minY.toDouble(),
                  maxY: maxY.toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: AppTheme.primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.primaryColor,
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final date = recentSessions[spot.x.toInt()].date;
                          final formatter = DateFormat('MMM d');
                          return LineTooltipItem(
                            '${formatter.format(date)}\n${spot.y.toStringAsFixed(1)} $unit',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Legend and summary
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getMetricName(metricType),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  // Show trend info if we have enough data
                  if (dataPoints.length >= 2)
                    _buildTrendIndicator(
                      context,
                      dataPoints.first.y,
                      dataPoints.last.y,
                      unit,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get human-readable metric name
  String _getMetricName(String metricType) {
    switch (metricType) {
      case 'maxForce':
        return 'Maximum Force (g)';
      case 'avgForce':
        return 'Average Force (g)';
      case 'avgHoldTime':
        return 'Average Hold Time (s)';
      default:
        return 'Value';
    }
  }

  // Build trend indicator with percentage change
  Widget _buildTrendIndicator(
    BuildContext context,
    double firstValue,
    double lastValue,
    String unit,
  ) {
    final percentChange = ((lastValue - firstValue) / firstValue * 100);
    final isPositive = percentChange >= 0;

    return Row(
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
