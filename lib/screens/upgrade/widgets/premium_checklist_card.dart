import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// "What you get" checklist. The first two facts are PROJECT.md Section 2's
/// Premium-tier bullet; "Priority support" is a real, differentiated
/// benefit — Premium members get a faster stated reply time on Contact
/// (see `ContactScreen`'s tier-aware response-time copy), not just a claim.
class PremiumChecklistCard extends StatelessWidget {
  const PremiumChecklistCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      l10n.goPremiumBullet1,
      l10n.goPremiumBullet2,
      l10n.prioritySupportBullet,
    ];
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
          Text(l10n.whatYouGet, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          for (final item in items) ...[
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
            if (item != items.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
