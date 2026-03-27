import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/activity_graph.dart';

class FitnessTrackerScreen extends StatefulWidget {
  const FitnessTrackerScreen({super.key});

  @override
  State<FitnessTrackerScreen> createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  int _caloriesLogged = 0;
  final TextEditingController _calorieController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _calorieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const IronForgeAppBar(title: 'Fitness Tracker'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CalendarWidget(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDaySelected: (day) => setState(() {
                _selectedDay = day;
                _focusedDay = day;
              }),
              onMonthChanged: (day) => setState(() => _focusedDay = day),
            ),
            const SizedBox(height: 20),
            // Activity Graph
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ACTIVITY TRENDS', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ActivityGraph(hourlyData: provider.hourlyActivity),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Calorie Tracker
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('CALORIE TRACKER', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => _showAddCaloriesDialog(context, provider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('ADD MEAL', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: AppTheme.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${provider.caloriesBurned + _caloriesLogged} / ${provider.caloriesGoal} kcal',
                        style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: ((provider.caloriesBurned + _caloriesLogged) / provider.caloriesGoal).clamp(0.0, 1.0),
                      backgroundColor: AppTheme.surfaceLight,
                      valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(provider.caloriesGoal - provider.caloriesBurned - _caloriesLogged).clamp(0, provider.caloriesGoal)} kcal remaining',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Water Intake
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Water Intake', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        '${provider.waterGlasses} / ${provider.waterGoal} glasses',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _WaterGlassGrid(provider: provider),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Workout Log
            SectionHeader(title: 'Workout Log', actionText: 'Show All', onAction: () {}),
            const SizedBox(height: 12),
            ...provider.workoutLog.take(5).map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _WorkoutLogItem(entry: entry),
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAddCaloriesDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Add Calories', style: TextStyle(color: AppTheme.textPrimary)),
        content: TextField(
          controller: _calorieController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Enter calories',
            hintStyle: TextStyle(color: AppTheme.textMuted),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.surfaceLight)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primary)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final cal = int.tryParse(_calorieController.text) ?? 0;
              setState(() => _caloriesLogged += cal);
              _calorieController.clear();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final Function(DateTime) onMonthChanged;

  const _CalendarWidget({
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(focusedDay.year, focusedDay.month);
    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final startWeekday = firstDayOfMonth.weekday % 7;

    return SurfaceCard(
      child: Column(
        children: [
          // Month header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppTheme.textPrimary),
                onPressed: () => onMonthChanged(DateTime(focusedDay.year, focusedDay.month - 1)),
              ),
              Text(
                DateFormat('MMMM yyyy').format(focusedDay).toUpperCase(),
                style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppTheme.textPrimary),
                onPressed: () => onMonthChanged(DateTime(focusedDay.year, focusedDay.month + 1)),
              ),
            ],
          ),
          // Weekday headers
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) => Expanded(
              child: Center(
                child: Text(d, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox();
              final day = index - startWeekday + 1;
              final date = DateTime(focusedDay.year, focusedDay.month, day);
              final isSelected = DateUtils.isSameDay(date, selectedDay);
              final isToday = DateUtils.isSameDay(date, DateTime.now());
              return GestureDetector(
                onTap: () => onDaySelected(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : isToday ? AppTheme.primary.withValues(alpha: 0.2) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected ? Colors.white : isToday ? AppTheme.primary : AppTheme.textPrimary,
                        fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WaterGlassGrid extends StatelessWidget {
  final AppProvider provider;

  const _WaterGlassGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (i) => _GlassButton(
            filled: i < provider.waterGlasses,
            onTap: () {
              if (i < provider.waterGlasses) {
                provider.removeWaterGlass();
              } else {
                provider.addWaterGlass();
              }
            },
          )),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (i) => _GlassButton(
            filled: (i + 4) < provider.waterGlasses,
            onTap: () {
              if ((i + 4) < provider.waterGlasses) {
                provider.removeWaterGlass();
              } else {
                provider.addWaterGlass();
              }
            },
          )),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 14, color: AppTheme.primary),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'AI can suggest any trends today.',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;

  const _GlassButton({required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: filled ? AppTheme.blue.withValues(alpha: 0.15) : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: filled ? AppTheme.blue : AppTheme.surfaceLight,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.water_drop,
          color: filled ? AppTheme.blue : AppTheme.textMuted,
          size: 22,
        ),
      ),
    );
  }
}

class _WorkoutLogItem extends StatelessWidget {
  final entry;

  const _WorkoutLogItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fitness_center, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.workoutName, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  DateFormat('MMM d · h:mm a').format(entry.date),
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${entry.calories}', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
              const Text('kcal', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
