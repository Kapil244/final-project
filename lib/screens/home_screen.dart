import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/activity_graph.dart';
import 'workout_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: IronForgeAppBar(
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primary,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeSection(userName: user.name, goal: user.goal),
            const SizedBox(height: 20),
            _FeaturedWorkoutCard(provider: provider),
            const SizedBox(height: 20),
            _QuickActionsRow(provider: provider),
            const SizedBox(height: 24),
            _DailyActivitySection(provider: provider),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  final String userName;
  final String goal;

  const _WelcomeSection({required this.userName, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $userName!',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'On fire! Your goals: 5 days in a row 🔥',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

class _FeaturedWorkoutCard extends StatelessWidget {
  final AppProvider provider;

  const _FeaturedWorkoutCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final workout = provider.workouts.first;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutDetailScreen(workout: workout)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      'assets/images/hero_workout.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppTheme.background.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('TODAY\'S WORKOUT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text('${workout.duration} min', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      const SizedBox(width: 12),
                      Icon(Icons.local_fire_department_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text('${workout.calories} kcal', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      const SizedBox(width: 12),
                      DifficultyBadge(difficulty: workout.difficulty),
                    ],
                  ),
                  const SizedBox(height: 14),
                  OrangeButton(
                    text: 'Start Now',
                    icon: Icons.play_arrow,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutDetailScreen(workout: workout)));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  final AppProvider provider;

  const _QuickActionsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GradientCard(
            onTap: () => provider.setNavIndex(0),
            gradientColors: [AppTheme.primary, AppTheme.primaryDark],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.bolt, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('QUICK START', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SurfaceCard(
            color: AppTheme.surfaceLight,
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.history, color: AppTheme.textSecondary, size: 20),
                SizedBox(width: 8),
                Text('HISTORY', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyActivitySection extends StatelessWidget {
  final AppProvider provider;

  const _DailyActivitySection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Daily Activity', actionText: 'View Trends'),
        const SizedBox(height: 14),
        SurfaceCard(
          padding: const EdgeInsets.all(20),
          child: ActivityGraph(hourlyData: provider.hourlyActivity),
        ),
      ],
    );
  }
}

