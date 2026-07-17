import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Single leaderboard row — shared by Home's weekly leaders card (one row
/// per category: top referrer, top ad-watcher) and Refer & Earn's top-3
/// referrers card (medal-ranked by conversion count). `leading`/`trailing`
/// are widgets so each screen can show a category icon vs. a medal, and a
/// ₹ amount vs. a conversion count, while keeping the same row layout.
class LeaderRow extends StatelessWidget {
  final Widget leading;
  final String name;
  final String? subtitle;
  final Widget trailing;

  const LeaderRow({
    super.key,
    required this.leading,
    required this.name,
    this.subtitle,
    required this.trailing,
  });

  /// 36px circular icon badge — the style Home uses for category icons.
  static Widget iconBadge(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Icon(icon, size: 16, color: color),
    );
  }

  /// 36px medal badge for ranks 1-3 — the style Refer & Earn uses for its
  /// top-3 weekly referrers.
  static Widget medalBadge(int rank) {
    const medals = {1: '🥇', 2: '🥈', 3: '🥉'};
    return SizedBox(
      width: 36,
      height: 36,
      child: Center(
        child: Text(medals[rank] ?? '#$rank', style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
