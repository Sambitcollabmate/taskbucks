import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/phone_input.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/consent_checkbox.dart';

/// Register screen (PROJECT.md 7, Phase 3). Field order is locked to
/// name → mobile → optional email → password → optional referral code
/// (PROJECT.md 2). No tab bar; has a back button (pre-auth stack screen
/// the user can retreat from to Welcome — unlike Welcome itself).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralController = TextEditingController();

  bool _consentAccepted = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Real-time validation: the Send OTP button only lights up once these
    // two pass — never fire a fake OTP send on an invalid number (PROJECT.md
    // instructions for this screen).
    _nameController.addListener(_revalidate);
    _phoneController.addListener(_revalidate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _revalidate() => setState(() {});

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty && _phoneController.text.length == 10;

  void _onSendOtp() {
    if (!_isValid) return;
    context.push('/verify-phone', extra: _phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            Text(
              'Create your account',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            const Text(
              "Start earning in minutes — it's free.",
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            AuthTextField(
              controller: _nameController,
              label: 'Full name',
              hintText: 'Your name',
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Mobile number',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            PhoneInput(controller: _phoneController, onChanged: (_) {}),
            const SizedBox(height: 6),
            const Text(
              "We'll send a 6-digit OTP to verify this number.",
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: 'Email (optional)',
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Create a password',
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _referralController,
              label: 'Referral code (optional)',
              hintText: 'e.g. SAMBIT482',
            ),
            const SizedBox(height: 20),
            ConsentCheckbox(
              value: _consentAccepted,
              onChanged: (v) => setState(() => _consentAccepted = v),
              onTapTerms: () {},
              onTapPrivacy: () {},
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: _isValid
                      ? const LinearGradient(
                          colors: [
                            AppColors.primaryGradientStart,
                            AppColors.primaryGradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: _isValid ? null : AppColors.textSecondary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isValid ? _onSendOtp : null,
                    borderRadius: BorderRadius.circular(14),
                    child: Center(
                      child: Text(
                        'Send OTP',
                        style: TextStyle(
                          color: _isValid
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.7),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () => context.push('/login'),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
