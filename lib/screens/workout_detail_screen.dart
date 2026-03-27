import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutModel workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool _isStarted = false;
  int _secondsElapsed = 0;
  late Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerStream = Stream.periodic(const Duration(seconds: 1), (x) => x);
  }

  String get _timeDisplay {
    final mins = _secondsElapsed ~/ 60;
    final secs = _secondsElapsed % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: IronForgeAppBar(
        showBack: true,
        title: widget.workout.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.workout.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppTheme.background.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DifficultyBadge(difficulty: widget.workout.difficulty),
                        const SizedBox(height: 8),
                        Text(widget.workout.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Stats row
            Row(
              children: [
                Expanded(child: _StatBox(icon: Icons.timer, label: 'Duration', value: '${widget.workout.duration} min')),
                const SizedBox(width: 12),
                Expanded(child: _StatBox(icon: Icons.local_fire_department, label: 'Calories', value: '${widget.workout.calories} kcal')),
                const SizedBox(width: 12),
                Expanded(child: _StatBox(icon: Icons.speed, label: 'Intensity', value: widget.workout.difficulty)),
              ],
            ),
            const SizedBox(height: 20),
            // Timer
            if (_isStarted)
              StreamBuilder<int>(
                stream: _timerStream,
                builder: (context, snap) {
                  if (snap.hasData) _secondsElapsed = snap.data! + 1;
                  return SurfaceCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, color: AppTheme.primary, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          _timeDisplay,
                          style: const TextStyle(color: AppTheme.primary, fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            if (_isStarted) const SizedBox(height: 16),
            // Description
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About this workout', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(widget.workout.description, style: const TextStyle(color: AppTheme.textSecondary, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Exercises list
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Exercises', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  ..._exercises.map((e) => _ExerciseItem(exercise: e)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OrangeButton(
              text: _isStarted ? 'Complete Workout' : 'Start Workout',
              icon: _isStarted ? Icons.check : Icons.play_arrow,
              onPressed: () {
                if (_isStarted) {
                  provider.addWorkoutLog(WorkoutLogEntry(
                    workoutName: widget.workout.name,
                    calories: widget.workout.calories,
                    date: DateTime.now(),
                    duration: _secondsElapsed ~/ 60,
                  ));
                  provider.startWorkout(widget.workout);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Great job! ${widget.workout.calories} calories burned!'),
                      backgroundColor: AppTheme.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  setState(() => _isStarted = true);
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _exercises => [
    {'name': 'Warm Up', 'sets': '1 set', 'reps': '5 min', 'icon': Icons.directions_run},
    {'name': 'Squats', 'sets': '4 sets', 'reps': '8-10 reps', 'icon': Icons.accessibility_new},
    {'name': 'Deadlift', 'sets': '3 sets', 'reps': '6-8 reps', 'icon': Icons.fitness_center},
    {'name': 'Leg Press', 'sets': '3 sets', 'reps': '12 reps', 'icon': Icons.sports_gymnastics},
    {'name': 'Lunges', 'sets': '3 sets', 'reps': '10 reps each', 'icon': Icons.directions_walk},
    {'name': 'Cool Down', 'sets': '1 set', 'reps': '5 min', 'icon': Icons.self_improvement},
  ];
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatBox({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primary, size: 22),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ExerciseItem extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const _ExerciseItem({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(exercise['icon'] as IconData, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise['name'] as String, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                Text('${exercise['sets']} · ${exercise['reps']}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.textMuted),
        ],
      ),
    );
  }
}
