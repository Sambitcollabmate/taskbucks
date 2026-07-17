import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/top_referrer.dart';
import '../../../shared/widgets/leader_row.dart';

/// This week's top-3 referrers by conversion count. The weekly bonus gift
/// for the #1 spot is a real mechanic (PROJECT.md 2) but its exact value is
/// still TBD — don't invent an amount here, just say a bonus exists.
class TopReferrersCard extends StatelessWidget {
  final List<TopReferrer> topReferrers;

  const TopReferrersCard({super.key, required this.topReferrers});

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
          Row(
            children: [
              const Icon(LucideIcons.trophy, size: 18, color: AppColors.premiumGold),
              const SizedBox(width: 8),
              Text(
                "This week's top referrers",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final referrer in topReferrers) ...[
            LeaderRow(
              leading: LeaderRow.medalBadge(referrer.rank),
              name: referrer.maskedUsername,
              trailing: Text(
                '${referrer.conversions} conversions',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.earningsGreen,
                ),
              ),
            ),
            if (referrer != topReferrers.last) const Divider(height: 20),
          ],
          const SizedBox(height: 12),
          Text(
            'Top referrer this week wins a bonus gift.',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
