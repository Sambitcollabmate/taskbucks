import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// Circular ring showing today's completed tasks vs the daily cap.
/// Green while in progress, gold once the cap is complete (PROJECT.md 5).
class TaskProgressCard extends StatelessWidget {
  final int completed;
  final int dailyLimit;

  const TaskProgressCard({
    super.key,
    required this.completed,
    required this.dailyLimit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = dailyLimit == 0
        ? 0.0
        : (completed / dailyLimit).clamp(0.0, 1.0);
    final isComplete = completed >= dailyLimit;
    final ringColor = isComplete
        ? AppColors.premiumGold
        : AppColors.earningsGreen;

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
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppColors.background,
                    valueColor: AlwaysStoppedAnimation(ringColor),
                  ),
                ),
                Text(
                  '$completed/$dailyLimit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's tasks",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  isComplete
                      ? "You've hit today's cap. Come back tomorrow!"
                      : '${dailyLimit - completed} more to reach your daily limit',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(LucideIcons.play, size: 14, color: ringColor),
                    const SizedBox(width: 4),
                    Text(
                      isComplete ? 'Cap reached' : 'Watch a video to earn',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ringColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
