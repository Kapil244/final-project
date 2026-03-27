import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/training_library_screen.dart';
import 'screens/fitness_tracker_screen.dart';
import 'screens/bmi_calculator_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://rzggjbvngvwgctwxmrmg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6Z2dqYnZuZ3Z3Z2N0d3htcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ0NDQ3NzcsImV4cCI6MjA5MDAyMDc3N30.HR5rAQtfaqtnt501uqbWHfXbgV1L10AYVa9io0gN98k',
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const IronForgeApp());
}

class IronForgeApp extends StatelessWidget {
  const IronForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Iron Forge',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: provider.isLoggedIn ? const MainShell() : const LoginScreen(),
          );
        },
      ),
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    TrainingLibraryScreen(),
    FitnessTrackerScreen(),
    BMICalculatorScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: provider.selectedNavIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                  currentIndex: provider.selectedNavIndex,
                  onTap: () => provider.setNavIndex(0),
                ),
                _NavItem(
                  icon: Icons.play_circle_outline,
                  activeIcon: Icons.play_circle,
                  label: 'Programs',
                  index: 1,
                  currentIndex: provider.selectedNavIndex,
                  onTap: () => provider.setNavIndex(1),
                ),
                _NavItem(
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart,
                  label: 'Tracker',
                  index: 2,
                  currentIndex: provider.selectedNavIndex,
                  onTap: () => provider.setNavIndex(2),
                ),
                _NavItem(
                  icon: Icons.monitor_weight_outlined,
                  activeIcon: Icons.monitor_weight,
                  label: 'BMI',
                  index: 3,
                  currentIndex: provider.selectedNavIndex,
                  onTap: () => provider.setNavIndex(3),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  index: 4,
                  currentIndex: provider.selectedNavIndex,
                  onTap: () => provider.setNavIndex(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  bool get isActive => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.primary : AppTheme.textMuted,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
