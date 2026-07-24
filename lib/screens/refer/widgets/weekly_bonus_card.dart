import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/refer_summary.dart';

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
    if (!summary.isPremium) {
      return _CardShell(
        icon: LucideIcons.lock,
        iconColor: AppColors.textSecondary,
        title: 'Weekly referral bonus',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get 5 Premium referrals converting in the same week and '
              "you'll earn +5 bonus ad slots the week after, but this "
              'perk is Premium-only. Upgrade to start qualifying.',
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.push('/upgrade'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                'Upgrade to Premium →',
                style: TextStyle(
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
        title: 'Weekly referral bonus',
        child: Text(
          '🎉 ${summary.bonusAdSlotsAvailable} bonus ad slots are active '
          'this week. Head to Tasks to watch them, in any order, any '
          'time before the week ends.',
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
      title: 'Weekly referral bonus',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${summary.conversionsThisWeek} of $weeklyBonusConversionThreshold '
            "Premium referrals converted this week. Get $remaining more to "
            'convert this same week for +$weeklyBonusAdSlots bonus ad '
            'slots next week.',
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

  const _CardShell({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
