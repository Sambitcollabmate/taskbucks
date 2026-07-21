import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// Small trust signals under the hero — SSL/security, payout track record,
/// and supported payout rails (UPI/Bank only, per PROJECT.md 2). Each pill
/// is `Expanded` so the row always spans the same full width as the cards
/// above/below it, instead of only being as wide as the pills' content —
/// and stays on a single line since the pills share that width equally.
class TrustPillsRow extends StatelessWidget {
  const TrustPillsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _TrustPill(icon: LucideIcons.shieldCheck, label: 'SSL secured')),
        SizedBox(width: 8),
        Expanded(child: _TrustPill(icon: LucideIcons.badgeCheck, label: '7 yrs paying')),
        SizedBox(width: 8),
        Expanded(child: _TrustPill(icon: LucideIcons.landmark, label: 'UPI · Bank')),
      ],
    );
  }
}

class _TrustPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 13, color: AppColors.earningsGreen),
          const SizedBox(width: 5),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
