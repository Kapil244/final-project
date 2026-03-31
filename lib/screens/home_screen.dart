import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    WelcomeSection(),
                    AICoachBanner(),
                    TodayWorkoutCard(),
                    QuickActionsRow(),
                    DailyActivitySection(),
                    WeeklyChartSection(),
                    MuscleHeatmapSection(),
                    NutritionSection(),
                    PersonalRecordsSection(),
                    UpcomingScheduleSection(),
                    LeaderboardSection(),
                    RecoverySection(),
                    RecommendedSection(),
                    AchievementsSection(),
                    SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(),
    );
  }
}



class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppProvider p) => p.user);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          IFAvatar(label: user.name[0], color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Good Morning,',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text(user.name,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary, size: 22),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none,
                    color: AppColors.textPrimary, size: 22),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome Back! 👋',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("You've hit your goals 5 days in a row!",
              style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(7, (index) {
              final isActive = index < 5;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: isActive ? AppColors.primary : AppColors.textMuted,
                  size: 20,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AICoachBanner extends StatelessWidget {
  const AICoachBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: IFCard(
        color: AppColors.blueSoft.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt, color: AppColors.blue, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Fitness Coach',
                      style: TextStyle(
                          color: AppColors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Text('Based on yesterday’s Leg Day, I suggest 20m of foam rolling.',
                      style: TextStyle(
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                          fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {},
              child: const Text('Ask Coach',
                  style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayWorkoutCard extends StatelessWidget {
  const TodayWorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final workout = provider.workouts[1]; // Upper Body Power
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Today’s Workout', action: 'View Plan →'),
          const SizedBox(height: 12),
          IFCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: Row(
                    children: [
                      const DifficultyBadge(difficulty: 'Intermediate'),
                      const Spacer(),
                      Text('${workout.calories} kcal',
                          style: const TextStyle(
                              color: AppColors.orange,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(workout.name,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(workout.description,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _WorkoutStat(icon: Icons.timer_outlined, label: '${workout.duration} min'),
                          const SizedBox(width: 16),
                          const _WorkoutStat(icon: Icons.fitness_center_outlined, label: '12 Sets'),
                          const Spacer(),
                          const OrangeButton(
                            text: 'Start',
                            width: 80,
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const IFProgressBar(progress: 0.45, color: AppColors.orange),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WorkoutStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }
}

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _QuickActionItem(icon: Icons.menu_book, label: 'Journal', color: AppColors.blue),
          _QuickActionItem(icon: Icons.restaurant, label: 'Meals', color: AppColors.green),
          _QuickActionItem(icon: Icons.water_drop, label: 'Water', color: AppColors.skyBlue),
          _QuickActionItem(icon: Icons.group, label: 'Group', color: AppColors.purple),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickActionItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}


class DailyActivitySection extends StatelessWidget {
  const DailyActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Daily Activity', action: 'View Trends →'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _ActivityCard(
                icon: Icons.directions_walk,
                label: 'Steps',
                value: provider.steps.toString(),
                goal: '10,000',
                progress: provider.steps / 10000,
                color: AppColors.blue,
              ),
              _ActivityCard(
                icon: Icons.local_fire_department,
                label: 'Calories',
                value: provider.caloriesBurned.toString(),
                goal: '2,500',
                progress: provider.caloriesBurned / 2500,
                color: AppColors.orange,
              ),
              _ActivityCard(
                icon: Icons.update,
                label: 'Active min',
                value: provider.activeMinutes.toString(),
                goal: '60',
                progress: provider.activeMinutes / 60,
                color: AppColors.green,
              ),
              _ActivityCard(
                icon: Icons.water_drop,
                label: 'Water',
                value: '${provider.waterGlasses} glasses',
                goal: '${provider.waterGoal} glasses',
                progress: provider.waterGlasses / provider.waterGoal,
                color: AppColors.skyBlue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          IFCard(
            color: AppColors.red.withValues(alpha: 0.05),
            border: Border.all(color: AppColors.red.withValues(alpha: 0.1)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, color: AppColors.red, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Heart Rate', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('72', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Text('bpm', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 60,
                  height: 30,
                  child: CustomPaint(painter: _HeartbeatPainter()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String goal;
  final double progress;
  final Color color;

  const _ActivityCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.goal,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IFCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Goal: $goal', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
            ],
          ),
          IFProgressBar(progress: progress, color: color, height: 4),
        ],
      ),
    );
  }
}

class _HeartbeatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * 0.2, size.height / 2);
    path.lineTo(size.width * 0.3, size.height * 0.2);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.5, size.height / 2);
    path.lineTo(size.width * 0.7, size.height / 2);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width * 0.9, size.height * 0.6);
    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WeeklyChartSection extends StatelessWidget {
  const WeeklyChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: IFCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'Weekly Progress', trailing: Text('84%', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold))),
            SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Bar(label: 'M', height: 0.6, color: AppColors.primary),
                  _Bar(label: 'T', height: 0.8, color: AppColors.primary),
                  _Bar(label: 'W', height: 0.4, color: AppColors.primary),
                  _Bar(label: 'T', height: 0.9, color: AppColors.primary),
                  _Bar(label: 'F', height: 0.7, color: AppColors.primary),
                  _Bar(label: 'S', height: 0.3, color: AppColors.primary),
                  _Bar(label: 'S', height: 0.5, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double height;
  final Color color;
  const _Bar({required this.label, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 140 * height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 30,
            height: 140 * height * 0.6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }
}


class MuscleHeatmapSection extends StatelessWidget {
  const MuscleHeatmapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Muscle Fatigue', action: 'Heatmap Details →'),
          const SizedBox(height: 12),
          IFCard(
            child: Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MuscleIndicator(label: 'Chest', progress: 0.85, color: AppColors.red),
                      SizedBox(height: 14),
                      _MuscleIndicator(label: 'Back', progress: 0.65, color: AppColors.orange),
                      SizedBox(height: 14),
                      _MuscleIndicator(label: 'Legs', progress: 0.45, color: AppColors.green),
                      SizedBox(height: 14),
                      _MuscleIndicator(label: 'Arms', progress: 0.30, color: AppColors.blue),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 0.8,
                    child: CustomPaint(painter: MuscleHeatmapPainter()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleIndicator extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;
  const _MuscleIndicator({required this.label, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
            Text('${(progress * 100).toInt()}%', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        IFProgressBar(progress: progress, color: color, height: 6),
      ],
    );
  }
}

class MuscleHeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    void drawPart(Rect rect, Color color) {
      paint.color = color.withValues(alpha: 0.3);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);
      paint.color = color;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.5;
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);
      paint.style = PaintingStyle.fill;
    }

    // Simplified Body Shape
    drawPart(Rect.fromLTWH(size.width * 0.25, size.height * 0.05, size.width * 0.5, size.height * 0.1), AppColors.textMuted); // Head
    drawPart(Rect.fromLTWH(size.width * 0.1, size.height * 0.18, size.width * 0.8, size.height * 0.3), AppColors.red); // Torso/Chest
    drawPart(Rect.fromLTWH(size.width * 0.15, size.height * 0.52, size.width * 0.3, size.height * 0.4), AppColors.green); // L Leg
    drawPart(Rect.fromLTWH(size.width * 0.55, size.height * 0.52, size.width * 0.3, size.height * 0.4), AppColors.green); // R Leg
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NutritionSection extends StatelessWidget {
  const NutritionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Nutrition Today', trailing: NewBadge()),
          const SizedBox(height: 10),
          IFCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Remaining', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        Text('1,240 kcal', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: 0.65,
                            strokeWidth: 6,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                          const Center(
                            child: Icon(Icons.restaurant, color: AppColors.primary, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NutritionItem(label: 'Protein', value: '84/160g', color: AppColors.orange, progress: 0.52),
                    _NutritionItem(label: 'Carbs', value: '142/220g', color: AppColors.blue, progress: 0.64),
                    _NutritionItem(label: 'Fats', value: '45/70g', color: AppColors.yellow, progress: 0.64),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double progress;
  const _NutritionItem({required this.label, required this.value, required this.color, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: IFProgressBar(progress: progress, color: color, height: 4),
        ),
      ],
    );
  }
}


class PersonalRecordsSection extends StatelessWidget {
  const PersonalRecordsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Personal Records', action: 'All PRs →'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: const [
              PersonalRecordCard(
                label: 'Bench Press',
                value: '120 kg',
                date: '2 days ago',
                icon: Icons.fitness_center,
                color: AppColors.orange,
                progress: 0.85,
              ),
              PersonalRecordCard(
                label: 'Deadlift',
                value: '185 kg',
                date: '1 week ago',
                icon: Icons.fitness_center,
                color: AppColors.purple,
                progress: 0.92,
              ),
              PersonalRecordCard(
                label: '5k Run',
                value: '22:45',
                date: '3 weeks ago',
                icon: Icons.directions_run,
                color: AppColors.blue,
                progress: 0.78,
              ),
              PersonalRecordCard(
                label: 'Squat',
                value: '145 kg',
                date: 'Yesterday',
                icon: Icons.fitness_center,
                color: AppColors.green,
                progress: 0.88,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PersonalRecordCard extends StatelessWidget {
  final String label;
  final String value;
  final String date;
  final IconData icon;
  final Color color;
  final double progress;

  const PersonalRecordCard({
    super.key,
    required this.label,
    required this.value,
    required this.date,
    required this.icon,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return IFCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 16),
              ),
              const Icon(Icons.workspace_premium, color: AppColors.yellow, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              Text(date, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
            ],
          ),
          IFProgressBar(progress: progress, color: color, height: 4),
        ],
      ),
    );
  }
}

class UpcomingScheduleSection extends StatelessWidget {
  const UpcomingScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Upcoming Classes', action: 'Schedule Detail →'),
          SizedBox(height: 12),
          IFCard(
            child: Column(
              children: [
                _ScheduleItem(
                  time: '18:00',
                  title: 'Crossfit Advanced',
                  coach: 'Coach Alex',
                  color: AppColors.orange,
                  isActive: true,
                ),
                Divider(color: AppColors.border, height: 24),
                _ScheduleItem(
                  time: '19:30',
                  title: 'Yoga Flow',
                  coach: 'Coach Elena',
                  color: AppColors.skyBlue,
                  isActive: false,
                ),
                Divider(color: AppColors.border, height: 24),
                _ScheduleItem(
                  time: '20:45',
                  title: 'HIIT Intensive',
                  coach: 'Coach Marc',
                  color: AppColors.red,
                  isActive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final String coach;
  final Color color;
  final bool isActive;

  const _ScheduleItem({
    required this.time,
    required this.title,
    required this.coach,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? color : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            time,
            style: TextStyle(
              color: isActive ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
            Text(coach, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
        const Spacer(),
        Icon(Icons.chevron_right, color: AppColors.textMuted.withValues(alpha: 0.5)),
      ],
    );
  }
}


class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Community Leaderboard', action: 'Full Ranking →'),
          SizedBox(height: 12),
          IFCard(
            child: Column(
              children: [
                _LeaderboardItem(rank: 1, name: 'Sarah Jenkins', points: '12,450', avatarUrl: null, color: AppColors.orange),
                Divider(color: AppColors.border, height: 20),
                _LeaderboardItem(rank: 2, name: 'Kevin Durant', points: '11,820', avatarUrl: null, color: AppColors.blue),
                Divider(color: AppColors.border, height: 20),
                _LeaderboardItem(rank: 3, name: 'Michael Chen', points: '10,950', avatarUrl: null, color: AppColors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final String? avatarUrl;
  final Color color;

  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.points,
    this.avatarUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            rank.toString(),
            style: TextStyle(
              color: rank == 1 ? AppColors.yellow : AppColors.textMuted,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IFAvatar(size: 32, label: name[0], color: color),
        const SizedBox(width: 12),
        Text(name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14)),
        const Spacer(),
        Text('$points pts', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}

class RecoverySection extends StatelessWidget {
  const RecoverySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Recovery & Readiness', action: 'Details →'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: IFCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bedtime, color: AppColors.purple, size: 16),
                          SizedBox(width: 8),
                          Text('Sleep', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('7h 24m', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('84% Quality', style: TextStyle(color: AppColors.green.withValues(alpha: 0.8), fontSize: 11)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: IFCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, color: AppColors.yellow, size: 16),
                          SizedBox(width: 8),
                          Text('Readiness', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Optimum', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Go for it!', style: TextStyle(color: AppColors.green.withValues(alpha: 0.8), fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Recommended For You', action: 'Refresh →'),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _RecommendedCard(
                  title: 'Mobility Flow',
                  duration: '15 min',
                  level: 'Beginner',
                  imageUrl: null,
                  color: AppColors.skyBlue,
                ),
                SizedBox(width: 12),
                _RecommendedCard(
                  title: 'Core Strength',
                  duration: '20 min',
                  level: 'Intermediate',
                  imageUrl: null,
                  color: AppColors.purple,
                ),
                SizedBox(width: 12),
                _RecommendedCard(
                  title: 'HIIT Cardio',
                  duration: '25 min',
                  level: 'Advanced',
                  imageUrl: null,
                  color: AppColors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final String title;
  final String duration;
  final String level;
  final String? imageUrl;
  final Color color;

  const _RecommendedCard({
    required this.title,
    required this.duration,
    required this.level,
    this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: color.withValues(alpha: 0.1),
              child: Center(
                child: Icon(Icons.play_circle_outline, color: color, size: 32),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('$duration • $level', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Recent Achievements', action: 'Showcase →'),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _AchievementBadge(icon: Icons.bolt, color: AppColors.orange, label: 'Early Bird'),
                SizedBox(width: 16),
                _AchievementBadge(icon: Icons.favorite, color: AppColors.red, label: 'Heart Hero'),
                SizedBox(width: 16),
                _AchievementBadge(icon: Icons.water_drop, color: AppColors.skyBlue, label: 'Hydrated'),
                SizedBox(width: 16),
                _AchievementBadge(icon: Icons.timer, color: AppColors.purple, label: 'Consistent'),
                SizedBox(width: 16),
                _AchievementBadge(icon: Icons.emoji_events, color: AppColors.yellow, label: 'Champion'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _AchievementBadge({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
      ],
    );
  }
}

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        showUnselectedLabels: true,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center_rounded), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

