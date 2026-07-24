import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/app_notification.dart';
import '../../data/models/notification_type.dart';

/// Single notification row (PROJECT.md 6.3) — icon + title + body +
/// timestamp. Unread shows a colored dot next to the title and a tinted
/// row background; read shows muted/gray title and body text. Tapping is
/// the caller's responsibility (mark-read + deep-link) via [onTap].
class NotificationRow extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationRow({super.key, required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.taskCredited:
        return LucideIcons.playCircle;
      case NotificationType.referralConverted:
        return LucideIcons.userPlus;
      case NotificationType.withdrawalQueued:
        return LucideIcons.arrowUpRight;
      case NotificationType.streakBonus:
        return LucideIcons.flame;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.taskCredited:
        return AppColors.earningsGreen;
      case NotificationType.referralConverted:
        return AppColors.primary;
      case NotificationType.withdrawalQueued:
        return AppColors.premiumGold;
      case NotificationType.streakBonus:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final dateFormat = DateFormat('d MMM, h:mm a');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnread ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, size: 16, color: _iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isUnread
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8, top: 5),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUnread
                          ? AppColors.textSecondary
                          : AppColors.textSecondary.withValues(alpha: 0.65),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(notification.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
