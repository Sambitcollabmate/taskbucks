import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/wallet_summary.dart';

/// Breaks the balance down into task/ad earnings, referral commissions, and
/// pending referral commission (PROJECT.md 2: referral ₹125 is "pending"
/// until the referred purchase clears).
class WalletBreakdownCard extends StatelessWidget {
  final WalletBreakdown breakdown;

  const WalletBreakdownCard({super.key, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
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
          Text('Balance breakdown', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          _BreakdownRow(
            icon: LucideIcons.listChecks,
            iconColor: AppColors.earningsGreen,
            label: 'Task & ad earnings',
            value: formatter.format(breakdown.taskAdEarnings),
          ),
          const Divider(height: 24),
          _BreakdownRow(
            icon: LucideIcons.userPlus,
            iconColor: AppColors.primary,
            label: 'Referral commissions',
            value: formatter.format(breakdown.referralCommissions),
          ),
          const Divider(height: 24),
          _BreakdownRow(
            icon: LucideIcons.clock,
            iconColor: AppColors.warning,
            label: 'Pending',
            value: formatter.format(breakdown.pendingAmount),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _BreakdownRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 17, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
