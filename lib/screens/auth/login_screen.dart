import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Placeholder until Phase 3's Login screen is built (PROJECT.md 7).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Log in — coming soon',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
