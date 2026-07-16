import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Placeholder until Phase 2's Refer & Earn screen is built (PROJECT.md 7).
class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const SafeArea(
        child: Center(
          child: Text(
            'Refer & Earn — coming soon',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
