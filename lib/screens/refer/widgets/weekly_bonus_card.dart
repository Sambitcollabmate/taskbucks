import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/refer_summary.dart';
import '../../../l10n/app_localizations.dart';

/// Surfaces the new weekly referral bonus (PROJECT.md 2) on Refer & Earn.
/// Three states:
/// - not Premium: locked, since the bonus gates on the referrer holding
///   Premium regardless of referral volume. Links to Upgrade.
/// - Premium, slots active: this week's earned +5 bonus ad slots (from
///   hitting the threshold last week).
/// - Premium, no slots active: progress toward this week's threshold,
///   counted by the referred user's *purchase* week, not signup week, and
///   resets clean each week with no partial carryover.
class WeeklyBonusCard extends StatelessWidget {
  final ReferSummary summary;

  const WeeklyBonusCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!summary.isPremium) {
      return _CardShell(
        icon: LucideIcons.lock,
        iconColor: AppColors.textSecondary,
        title: l10n.weeklyReferralBonusTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.weeklyBonusLockedExplainer,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.push('/upgrade'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                l10n.upgradeToPremiumArrow,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (summary.bonusAdSlotsAvailable > 0) {
      return _CardShell(
        icon: LucideIcons.gift,
        iconColor: AppColors.earningsGreen,
        title: l10n.weeklyReferralBonusTitle,
        highlighted: true,
        child: Text(
          l10n.bonusSlotsActiveMessage(summary.bonusAdSlotsAvailable),
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.45,
          ),
        ),
      );
    }

    final remaining = (weeklyBonusConversionThreshold - summary.conversionsThisWeek)
        .clamp(0, weeklyBonusConversionThreshold);

    return _CardShell(
      icon: LucideIcons.gift,
      iconColor: AppColors.premiumGold,
      title: l10n.weeklyReferralBonusTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.weeklyBonusProgress(
              summary.conversionsThisWeek,
              weeklyBonusConversionThreshold,
              remaining,
              weeklyBonusAdSlots,
            ),
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: summary.conversionsThisWeek / weeklyBonusConversionThreshold,
              minHeight: 6,
              backgroundColor: AppColors.premiumGold.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.premiumGold),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  final bool highlighted;

  const _CardShell({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: highlighted
            ? LinearGradient(
                colors: [
                  AppColors.earningsGreen.withValues(alpha: 0.14),
                  AppColors.earningsGreen.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: highlighted ? null : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: highlighted
            ? Border.all(color: AppColors.earningsGreen.withValues(alpha: 0.35))
            : null,
        boxShadow: [
          BoxShadow(
            color: highlighted
                ? AppColors.earningsGreen.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
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
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: iconColor),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
