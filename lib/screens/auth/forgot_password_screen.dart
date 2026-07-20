import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Placeholder until Phase 3's Forgot Password screen is built (PROJECT.md
/// 7) — reuses phone_input + otp_row.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Forgot Password — coming soon',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
