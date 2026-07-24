import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/about_info.dart';

/// Three stat chips (founded year, earner count, states covered) — same
/// chip shape as Refer & Earn's `ReferStatsRow`, driven entirely by
/// [AboutInfo] rather than any hardcoded number.
class AboutStatsRow extends StatelessWidget {
  final AboutInfo info;

  const AboutStatsRow({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final countFormat = NumberFormat.decimalPattern('en_IN');

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: LucideIcons.calendarDays,
            iconColor: AppColors.primary,
            value: '${info.foundingYear}',
            label: 'Founded',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: LucideIcons.users,
            iconColor: AppColors.earningsGreen,
            value: '${countFormat.format(info.earnerCount)}+',
            label: 'Earners',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: LucideIcons.map,
            iconColor: AppColors.premiumGold,
            value: '${info.statesCovered}',
            label: 'States',
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
