import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Placeholder until Phase 3's Register screen is built (PROJECT.md 7) —
/// phone_input component, field order name → mobile → email → password →
/// referral code (PROJECT.md 2).
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Register — coming soon',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
