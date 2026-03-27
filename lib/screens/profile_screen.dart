import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const IronForgeAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            SurfaceCard(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppTheme.primary,
                        backgroundImage: user.profileImageUrl != null
                            ? AssetImage(user.profileImageUrl!)
                            : null,
                        child: user.profileImageUrl == null
                            ? const Icon(Icons.person, color: Colors.white, size: 44)
                            : null,
                      ),
                      if (user.isPro)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.warning,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star, color: Colors.white, size: 14),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(user.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 22)),
                  Text(user.email, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  const SizedBox(height: 8),
                  if (user.isPro)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.warning.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: AppTheme.warning, size: 14),
                          SizedBox(width: 4),
                          Text('PRO MEMBER', style: TextStyle(color: AppTheme.warning, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    )
                  else
                    OrangeButton(
                      text: 'Upgrade to Pro',
                      icon: Icons.bolt,
                      width: 200,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen())),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Stats
            Row(
              children: [
                Expanded(child: _StatCard(label: 'Workouts', value: '${provider.workoutLog.length}')),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Calories', value: '${provider.caloriesBurned}k')),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Streak', value: '5🔥')),
              ],
            ),
            const SizedBox(height: 16),
            // Body stats
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Body Stats', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _BodyStatItem(label: 'Height', value: '${user.height.toInt()} cm')),
                      Expanded(child: _BodyStatItem(label: 'Weight', value: '${user.weight.toInt()} kg')),
                      Expanded(child: _BodyStatItem(label: 'BMI', value: user.bmi.toStringAsFixed(1))),
                      Expanded(child: _BodyStatItem(label: 'Age', value: '${user.age}')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Goal
            SurfaceCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.flag, color: AppTheme.primary),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Goal', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      Text(user.goal, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Settings menu
            SurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsItem(icon: Icons.settings, label: 'Settings'),
                  _SettingsItem(icon: Icons.notifications, label: 'Notifications'),
                  _SettingsItem(icon: Icons.privacy_tip, label: 'Privacy Policy'),
                  _SettingsItem(icon: Icons.help, label: 'Help & Support'),
                  _SettingsItem(icon: Icons.logout, label: 'Sign Out', color: AppTheme.error, showDivider: false),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 22)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _BodyStatItem extends StatelessWidget {
  final String label;
  final String value;

  const _BodyStatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final bool showDivider;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.color,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color ?? AppTheme.textSecondary, size: 20),
          title: Text(label, style: TextStyle(color: color ?? AppTheme.textPrimary, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
          onTap: () {},
        ),
        if (showDivider)
          Divider(height: 1, color: AppTheme.surfaceLight, indent: 16, endIndent: 16),
      ],
    );
  }
}
