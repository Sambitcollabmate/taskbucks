import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Placeholder until Phase 3's Verify Phone screen is built (PROJECT.md 7)
/// — otp_row component, reused from Forgot Password.
class VerifyPhoneScreen extends StatelessWidget {
  const VerifyPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Verify Phone — coming soon',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
