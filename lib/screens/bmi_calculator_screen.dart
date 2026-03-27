import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  String _selectedGender = 'Male';
  bool _calculated = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const IronForgeAppBar(title: 'BMI Calculator'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gender selector
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gender',
                      style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: ['Male', 'Female'].map((g) {
                      final isSelected = g == _selectedGender;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: g == 'Male' ? 8 : 0),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedGender = g),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    g == 'Male' ? Icons.male : Icons.female,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(g,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Height slider
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Height',
                          style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            user.height.toInt().toString(),
                            style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 32),
                          ),
                          const SizedBox(width: 4),
                          const Text('cm',
                              style: TextStyle(
                                  color: AppTheme.textMuted, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  Slider(
                    value: user.height,
                    min: 100,
                    max: 250,
                    onChanged: (v) {
                      provider.updateUserHeight(v);
                      setState(() => _calculated = false);
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('100 cm',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 11)),
                      Text('250 cm',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Weight slider
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Weight',
                          style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            user.weight.toInt().toString(),
                            style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 32),
                          ),
                          const SizedBox(width: 4),
                          const Text('kg',
                              style: TextStyle(
                                  color: AppTheme.textMuted, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  Slider(
                    value: user.weight,
                    min: 30,
                    max: 200,
                    onChanged: (v) {
                      provider.updateUserWeight(v);
                      setState(() => _calculated = false);
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('30 kg',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 11)),
                      Text('200 kg',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Calculate button
            OrangeButton(
              text: '  Calculate BMI',
              icon: Icons.calculate,
              onPressed: () => setState(() => _calculated = true),
            ),
            const SizedBox(height: 20),
            // BMI Result
            if (_calculated) ...[
              _BMIResult(user: user),
              const SizedBox(height: 16),
              _BMIScale(bmi: user.bmi),
              const SizedBox(height: 16),
              _BMITips(category: user.bmiCategory),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _BMIResult extends StatelessWidget {
  final user;

  const _BMIResult({required this.user});

  Color get _bmiColor {
    final b = user.bmi as double;
    if (b < 18.5) return const Color(0xFF2196F3);
    if (b < 25) return const Color(0xFF4CAF50);
    if (b < 30) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: [
          const Text('YOUR BMI',
              style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            user.bmi.toStringAsFixed(1),
            style: TextStyle(
              color: _bmiColor,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _bmiColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.bmiCategory,
              style: TextStyle(
                  color: _bmiColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Text(user.height.toInt().toString(),
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                const Text('Height (cm)',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
              ]),
              Container(width: 1, height: 40, color: AppTheme.surfaceLight),
              Column(children: [
                Text(user.weight.toInt().toString(),
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                const Text('Weight (kg)',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _BMIScale extends StatelessWidget {
  final double bmi;

  const _BMIScale({required this.bmi});

  @override
  Widget build(BuildContext context) {
    // Normalize BMI to 0-1 scale (10 to 40 range)
    final normalized = ((bmi - 10) / 30).clamp(0.0, 1.0);

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BMI Scale',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 16),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 16,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2196F3),
                        Color(0xFF4CAF50),
                        Color(0xFFFFC107),
                        Color(0xFFF44336)
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * normalized * 0.7,
                top: -2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary, width: 3),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Underweight\n<18.5',
                  style: TextStyle(color: Color(0xFF2196F3), fontSize: 10),
                  textAlign: TextAlign.center),
              Text('Normal\n18.5-24.9',
                  style: TextStyle(color: Color(0xFF4CAF50), fontSize: 10),
                  textAlign: TextAlign.center),
              Text('Overweight\n25-29.9',
                  style: TextStyle(color: Color(0xFFFFC107), fontSize: 10),
                  textAlign: TextAlign.center),
              Text('Obese\n>30',
                  style: TextStyle(color: Color(0xFFF44336), fontSize: 10),
                  textAlign: TextAlign.center),
            ],
          ),
        ],
      ),
    );
  }
}

class _BMITips extends StatelessWidget {
  final String category;

  const _BMITips({required this.category});

  String get _tip {
    switch (category) {
      case 'Underweight':
        return 'Consider increasing calorie intake with nutrient-dense foods and strength training to build muscle mass.';
      case 'Healthy Weight':
        return 'Great job! Maintain your healthy weight with regular exercise and a balanced diet.';
      case 'Overweight':
        return 'Focus on a calorie deficit through diet and consistent cardio + strength training.';
      default:
        return 'Consult a healthcare professional for a personalized weight management plan.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline,
              color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pro Tip',
                    style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(_tip,
                    style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
