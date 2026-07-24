/// What kind of event a notification represents — drives the icon/color in
/// `notification_row` (PROJECT.md 6.3) and where tapping the notification
/// deep-links to. Add new cases here as new notification-worthy events are
/// introduced, rather than hardcoding a new icon/deep-link per instance.
enum NotificationType {
  taskCredited,
  referralConverted,
  withdrawalQueued,
  streakBonus,
  newLoginDetected,
  premiumPromo,
}

/// The 3-tab grouping the Notifications screen filters by. Every
/// [NotificationType] belongs to exactly one category.
enum NotificationCategory { earnings, account, promotions }

extension NotificationTypeCategory on NotificationType {
  NotificationCategory get category {
    switch (this) {
      case NotificationType.taskCredited:
      case NotificationType.referralConverted:
      case NotificationType.withdrawalQueued:
      case NotificationType.streakBonus:
        return NotificationCategory.earnings;
      case NotificationType.newLoginDetected:
        return NotificationCategory.account;
      case NotificationType.premiumPromo:
        return NotificationCategory.promotions;
    }
  }
}
