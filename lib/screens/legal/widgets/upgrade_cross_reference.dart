import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// Points at the Upgrade screen's cancellation terms instead of repeating
/// them here — Refund's "Premium Subscription Cancellation" section uses
/// this so the two pages can't drift out of sync with each other.
class UpgradeCrossReference extends StatelessWidget {
  final String message;

  const UpgradeCrossReference({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: const TextStyle(
            fontSize: 13.5,
            color: AppColors.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => context.push('/upgrade'),
          borderRadius: BorderRadius.circular(8),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View subscription terms on the Upgrade screen',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 6),
              Icon(LucideIcons.arrowRight, size: 15, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
