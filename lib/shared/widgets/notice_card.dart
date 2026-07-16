import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';

enum NoticeVariant { info, warn }

/// Inline info/warn banner reused across Wallet (payout notice), Refer &
/// Earn (trigger-disclosure) and Withdraw (new-UPI warning) — see
/// PROJECT.md 6.3.
class NoticeCard extends StatelessWidget {
  final String message;
  final NoticeVariant variant;

  const NoticeCard({
    super.key,
    required this.message,
    this.variant = NoticeVariant.info,
  });

  @override
  Widget build(BuildContext context) {
    final isWarn = variant == NoticeVariant.warn;
    final color = isWarn ? AppColors.warning : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isWarn ? LucideIcons.triangleAlert : LucideIcons.info,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withValues(alpha: 0.85),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
