import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// Dark stats strip — same "premium surface" gradient language as
/// Welcome's `LiveStatsStrip` and `UpgradeBanner`, driven by
/// `PaymentProofsSummary` instead of hardcoded values (this data is
/// explicitly sample-only right now — see `SampleDataBanner` above it on
/// the screen and the `// LEGAL-REVIEW:` note on `PaymentProofsService`).
class PayoutStatsStrip extends StatelessWidget {
  final double lastCycleTotal;
  final int totalEarners;

  const PayoutStatsStrip({
    super.key,
    required this.lastCycleTotal,
    required this.totalEarners,
  });

  @override
  Widget build(BuildContext context) {
    final amountFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final countFormat = NumberFormat.decimalPattern('en_IN');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.premiumSurfaceStart, AppColors.premiumSurfaceEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: LucideIcons.banknote,
              value: amountFormat.format(lastCycleTotal),
              label: 'Paid last cycle',
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.12)),
          Expanded(
            child: _StatItem(
              icon: LucideIcons.users,
              value: '${countFormat.format(totalEarners)}+',
              label: 'Earners paid',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.premiumGold),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
