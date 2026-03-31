import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../theme/app_theme.dart';

class ActivityGraph extends StatelessWidget {
  final List<ActivityDataPoint> hourlyData;

  const ActivityGraph({super.key, required this.hourlyData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 100,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.surfaceLight.withValues(alpha: 0.5),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 3,
                    getTitlesWidget: (value, meta) {
                      final hour = value.toInt();
                      if (hour >= 6 && hour <= 20) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Text(
                            '$hour:00',
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 100,
                    getTitlesWidget: (value, meta) {
                      if (value % 100 != 0) return const SizedBox();
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
                      );
                    },
                    reservedSize: 35,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 6,
              maxX: 18,
              minY: 0,
              maxY: 300, 
              lineBarsData: [
                _lineData(
                  spots: hourlyData.map((e) => FlSpot(e.hour.toDouble(), e.calories.toDouble())).toList(),
                  color: AppTheme.primary,
                  isFilled: true,
                ),
                _lineData(
                  spots: hourlyData.map((e) => FlSpot(e.hour.toDouble(), e.water * 100)).toList(), // Scale water (e.g., 2 glasses * 100 = 200)
                  color: AppTheme.blue,
                  isFilled: false,
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => AppTheme.surface,
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      if (spot.barIndex == 0) {
                        return LineTooltipItem(
                          'Calories: ${spot.y.toInt()} kcal',
                          const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                        );
                      } else {
                        return LineTooltipItem(
                          'Water: ${(spot.y / 100).toStringAsFixed(1)} glasses',
                          const TextStyle(color: AppTheme.blue, fontWeight: FontWeight.bold, fontSize: 12),
                        );
                      }
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: AppTheme.primary, label: 'Calories (kcal)'),
            SizedBox(width: 24),
            _LegendItem(color: AppTheme.blue, label: 'Water (glasses)'),
          ],
        ),
      ],
    );
  }

  LineChartBarData _lineData({required List<FlSpot> spots, required Color color, bool isFilled = false}) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: isFilled,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
