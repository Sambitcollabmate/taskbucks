import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/bonus_ad_slot.dart';

/// "Bonus ads" section (PROJECT.md 2), the weekly referral bonus's +5
/// slots, shown only when any are active this week. Deliberately a
/// separate section below "Today's tasks," styled gold instead of pink/
/// gray, so it never reads as extending the daily task cap: these are a
/// weekly allowance, not part of the sequential daily queue, and every
/// available tile is independently tappable in any order.
class BonusAdsSection extends StatelessWidget {
  final List<BonusAdSlot> slots;
  final ValueChanged<int> onWatch;

  const BonusAdsSection({super.key, required this.slots, required this.onWatch});

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();

    final watchedCount = slots.where((s) => s.state == BonusAdState.watched).length;
    final remaining = slots.length - watchedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.premiumGold.withValues(alpha: 0.14),
                AppColors.premiumGold.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.premiumGold.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Text('🎁', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      remaining == 0
                          ? 'All ${slots.length} bonus slots watched this week 🎉'
                          : '$remaining bonus ad slot${remaining == 1 ? '' : 's'} left this week',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      "From last week's referral bonus. Watch any time before "
                      'the week resets.',
                      style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bonus ads', style: Theme.of(context).textTheme.titleLarge),
            Text(
              '$watchedCount of ${slots.length} watched',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final slot = slots[index];
            return _BonusTile(
              slot: slot,
              onTap: slot.state == BonusAdState.available
                  ? () => onWatch(slot.id)
                  : null,
            );
          },
        ),
      ],
    );
  }
}

class _BonusTile extends StatelessWidget {
  final BonusAdSlot slot;
  final VoidCallback? onTap;

  const _BonusTile({required this.slot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (slot.state == BonusAdState.watched) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.premiumGold.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Icon(LucideIcons.check, color: AppColors.premiumGold, size: 18),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.premiumGold.withValues(alpha: 0.85),
                AppColors.premiumGold,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.premiumGold.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(LucideIcons.gift, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}
