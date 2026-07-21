import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

const _items = [
  '30 tasks/day, up from Free\'s 25',
  'Same ₹/task rate — no reduced payout per task',
  'Cancel anytime — benefits continue until the end of the paid cycle',
];

/// "What you get" checklist — the 3 Premium facts stated in PROJECT.md
/// Section 2's Premium-tier bullet, broken into rows. Don't add benefits
/// beyond what's written there.
class PremiumChecklistCard extends StatelessWidget {
  const PremiumChecklistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What you get', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          for (final item in _items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.circleCheck,
                  size: 18,
                  color: AppColors.earningsGreen,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (item != _items.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
