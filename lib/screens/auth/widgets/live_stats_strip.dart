import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// Dark strip on Welcome echoing the same core claims as the rest of the
/// app (25 tasks/day free-tier cap, monthly UPI payout — PROJECT.md 2).
/// Same dark charcoal gradient as [UpgradeBanner] so gold/dark reads as one
/// consistent "premium surface" language across the app.
class LiveStatsStrip extends StatelessWidget {
  const LiveStatsStrip({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const Row(
        children: [
          Expanded(
            child: _StatItem(icon: LucideIcons.playCircle, value: '25', label: 'Tasks/day'),
          ),
          _StatDivider(),
          Expanded(
            // TODO: replace with real data once API exists.
            child: _StatItem(icon: LucideIcons.users, value: '12,000+', label: 'Earners'),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: LucideIcons.calendarCheck,
              value: 'Monthly',
              label: 'UPI payout',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.12));
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
