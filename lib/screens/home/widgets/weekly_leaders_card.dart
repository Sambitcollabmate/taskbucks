import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/home_summary.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/leader_row.dart';

/// Weekly bonus mechanic is still TBD (PROJECT.md Section 2) — this just
/// surfaces this week's current top referrer / top ad-watcher standings.
class WeeklyLeadersCard extends StatelessWidget {
  final List<LeaderboardEntry> leaders;

  const WeeklyLeadersCard({super.key, required this.leaders});

  String _categoryLabel(AppLocalizations l10n, LeaderboardCategory category) {
    switch (category) {
      case LeaderboardCategory.topReferrer:
        return l10n.topReferrer;
      case LeaderboardCategory.topAdWatcher:
        return l10n.topAdWatcher;
    }
  }

  IconData _categoryIcon(LeaderboardCategory category) {
    switch (category) {
      case LeaderboardCategory.topReferrer:
        return LucideIcons.userPlus;
      case LeaderboardCategory.topAdWatcher:
        return LucideIcons.playCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

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
                l10n.thisWeeksLeaders,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final entry in leaders) ...[
            LeaderRow(
              leading: LeaderRow.iconBadge(_categoryIcon(entry.category), AppColors.primary),
              name: entry.name,
              subtitle: _categoryLabel(l10n, entry.category),
              trailing: Text(
                formatter.format(entry.amount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.earningsGreen,
                ),
              ),
            ),
            if (entry != leaders.last) const Divider(height: 20),
          ],
          const Divider(height: 20),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.weeklyBonusFootnote,
              maxLines: 1,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
