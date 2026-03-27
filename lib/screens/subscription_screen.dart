import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedPlan = 'yearly';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isPro = provider.user.isPro;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: IronForgeAppBar(
        showBack: true,
        title: 'Upgrade to Pro',
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A0800), Color(0xFF2A1000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Unleash Your\nPotential.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get unlimited access to all premium features',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPro)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: AppTheme.success),
                          SizedBox(width: 8),
                          Text('You are a Pro member!', style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    )
                  else ...[
                    // Choose plan label
                    const Text('Choose your plan', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    // Monthly plan
                    _PlanCard(
                      planId: 'monthly',
                      title: 'Monthly Plan',
                      price: '\$14.99',
                      period: '/month',
                      description: 'Cancel anytime',
                      isSelected: _selectedPlan == 'monthly',
                      onTap: () => setState(() => _selectedPlan = 'monthly'),
                    ),
                    const SizedBox(height: 12),
                    // Yearly plan
                    _PlanCard(
                      planId: 'yearly',
                      title: 'Yearly Plan',
                      price: '\$99.99',
                      period: '/year',
                      description: 'Save 44% · \$8.33/month',
                      isSelected: _selectedPlan == 'yearly',
                      isBestValue: true,
                      onTap: () => setState(() => _selectedPlan = 'yearly'),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Pro features
                  const Text('Pro Features', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  ..._features.map((f) => _FeatureItem(feature: f)),
                  const SizedBox(height: 20),
                  if (!isPro)
                    OrangeButton(
                      text: _selectedPlan == 'monthly' ? 'Start Monthly Plan · \$14.99' : 'Start Yearly Plan · \$99.99',
                      icon: Icons.bolt,
                      onPressed: () => _handleUpgrade(context, provider),
                    ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Cancel anytime · Secure Payment · No Hidden Fees',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUpgrade(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Confirm Upgrade', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          'Upgrade to Pro ${_selectedPlan == 'monthly' ? 'Monthly (\$14.99/month)' : 'Yearly (\$99.99/year)'}?',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.upgradeToPro();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Welcome to Pro! Enjoy unlimited access.'),
                  backgroundColor: AppTheme.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _features => [
    {'icon': Icons.block, 'title': 'Ad-Free Experience', 'desc': 'Train without interruptions'},
    {'icon': Icons.playlist_play, 'title': 'Personalized Plans', 'desc': 'AI-powered workout recommendations'},
    {'icon': Icons.download_outlined, 'title': 'Offline Access', 'desc': 'Download workouts for offline use'},
    {'icon': Icons.bar_chart, 'title': 'Advanced Analytics', 'desc': 'Detailed progress insights'},
    {'icon': Icons.videocam_outlined, 'title': 'HD Video Guides', 'desc': 'Expert form instruction videos'},
    {'icon': Icons.support_agent, 'title': 'Priority Support', 'desc': '24/7 dedicated assistance'},
  ];
}

class _PlanCard extends StatelessWidget {
  final String planId;
  final String title;
  final String price;
  final String period;
  final String description;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;

  const _PlanCard({
    required this.planId,
    required this.title,
    required this.price,
    required this.period,
    required this.description,
    required this.isSelected,
    required this.onTap,
    this.isBestValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                      if (isBestValue) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('BEST VALUE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(description, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 20)),
                Text(period, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final Map<String, dynamic> feature;

  const _FeatureItem({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(feature['icon'] as IconData, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature['title'] as String, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                Text(feature['desc'] as String, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
        ],
      ),
    );
  }
}
