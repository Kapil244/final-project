import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLogin = true;
  bool _isPhoneMode = false;
  bool _isOtpSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleAuth() async {
    final provider = context.read<AppProvider>();
    bool success = false;
    
    if (_isLogin) {
      success = await provider.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      success = await provider.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );
      
      if (success) {
        setState(() {
          _isLogin = true;
          _passwordController.clear();
        });
      }
    }

    if (!mounted) return;
    
    if (provider.errorMessage != null) {
      final isHint = provider.errorMessage!.contains('confirm') || 
                     provider.errorMessage!.contains('Check your inbox') ||
                     provider.errorMessage!.contains('Account created');
      
      _showSnackBar(provider.errorMessage!, isHint ? Colors.blue : AppTheme.error);
    }
  }

  void _handlePhoneAuth() async {
    final provider = context.read<AppProvider>();
    bool success = false;
    
    if (!_isOtpSent) {
      if (_phoneController.text.trim().isEmpty) {
        _showSnackBar('Please enter your phone number', AppTheme.error);
        return;
      }
      success = await provider.sendOtp(_phoneController.text.trim());
      if (success) {
        setState(() => _isOtpSent = true);
        _showSnackBar('OTP sent! Please check your messages.', Colors.blue);
      }
    } else {
      if (_otpController.text.trim().isEmpty) {
        _showSnackBar('Please enter the OTP', AppTheme.error);
        return;
      }
      success = await provider.verifyOtp(
        _phoneController.text.trim(),
        _otpController.text.trim(),
      );
    }

    if (!mounted) return;
    
    if (provider.errorMessage != null) {
      _showSnackBar(provider.errorMessage!, AppTheme.error);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Premium Background with Animated Gradients
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: AppTheme.background),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: FadeInDown(
              duration: const Duration(seconds: 2),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withValues(alpha: 0.15),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: FadeInUp(
              duration: const Duration(seconds: 2),
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.blue.withValues(alpha: 0.15),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.fitness_center, color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeIn(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        'IRON FORGE',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeIn(
                      delay: const Duration(milliseconds: 500),
                      child: Text(
                        _isPhoneMode 
                          ? 'Quick & Secure Access' 
                          : (_isLogin ? 'Forge Your Best Self' : 'Start Your Journey'),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Auth Mode Switcher
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: _AuthTabSwitcher(
                        isPhoneMode: _isPhoneMode,
                        onChanged: (val) => setState(() {
                          _isPhoneMode = val;
                          _isOtpSent = false;
                        }),
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Glassmorphism Card
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (_isPhoneMode) ...[
                                  _buildTextField(
                                    controller: _phoneController,
                                    label: 'PHONE NUMBER',
                                    hint: '+1 234 567 8900',
                                    icon: Icons.phone_android,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  if (_isOtpSent) ...[
                                    const SizedBox(height: 20),
                                    _buildTextField(
                                      controller: _otpController,
                                      label: 'OTP CODE',
                                      hint: '123456',
                                      icon: Icons.lock_clock,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                  const SizedBox(height: 32),
                                  OrangeButton(
                                    text: provider.isLoading 
                                      ? 'PLEASE WAIT...' 
                                      : (_isOtpSent ? 'VERIFY & LOGIN' : 'SEND OTP'),
                                    onPressed: provider.isLoading ? () {} : _handlePhoneAuth,
                                  ),
                                  if (_isOtpSent)
                                    TextButton(
                                      onPressed: () => setState(() => _isOtpSent = false),
                                      child: const Text('Resend Code', style: TextStyle(color: AppTheme.primary)),
                                    ),
                                ] else ...[
                                  if (!_isLogin) ...[
                                    _buildTextField(
                                      controller: _nameController,
                                      label: 'FULL NAME',
                                      hint: 'John Doe',
                                      icon: Icons.person_outline,
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                  _buildTextField(
                                    controller: _emailController,
                                    label: 'EMAIL ADDRESS',
                                    hint: 'alex@ironforge.com',
                                    icon: Icons.alternate_email,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    controller: _passwordController,
                                    label: 'PASSWORD',
                                    hint: '••••••••',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                  ),
                                  const SizedBox(height: 32),
                                  OrangeButton(
                                    text: provider.isLoading 
                                      ? 'PLEASE WAIT...' 
                                      : (_isLogin ? 'LOGIN' : 'CREATE ACCOUNT'),
                                    onPressed: provider.isLoading ? () {} : _handleAuth,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    if (!_isPhoneMode)
                      FadeIn(
                        delay: const Duration(milliseconds: 1000),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin ? "Don't have an account? " : "Already have an account? ",
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () => setState(() => _isLogin = !_isLogin),
                              child: Text(
                                _isLogin ? 'Sign Up' : 'Login',
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          if (provider.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.primary.withValues(alpha: 0.7), size: 20),
              hintText: hint,
              hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.5), fontSize: 15),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthTabSwitcher extends StatelessWidget {
  final bool isPhoneMode;
  final Function(bool) onChanged;

  const _AuthTabSwitcher({
    required this.isPhoneMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'Email',
              isActive: !isPhoneMode,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _TabButton(
              title: 'Phone',
              isActive: isPhoneMode,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : AppTheme.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
