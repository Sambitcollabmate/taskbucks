import '../models/app_notification.dart';
import '../models/notification_type.dart';

/// Fake data source for the Notifications screen — same fake-service-now/
/// real-API-later convention as the rest of the app (PROJECT.md Section
/// 4/7). Covers all 4 `NotificationType` cases with a mix of read/unread.
class NotificationsService {
  Future<List<AppNotification>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    return [
      AppNotification(
        id: 'n1',
        type: NotificationType.taskCredited,
        title: 'Task credited',
        body: 'You earned ₹100 for completing a video-ad task.',
        timestamp: now.subtract(const Duration(minutes: 20)),
      ),
      AppNotification(
        id: 'n2',
        type: NotificationType.referralConverted,
        title: 'Referral converted',
        body: 'Ay***a K. went Premium. You earned ₹125 referral commission.',
        timestamp: now.subtract(const Duration(hours: 3)),
      ),
      AppNotification(
        id: 'n3',
        type: NotificationType.streakBonus,
        title: 'Week streak bonus',
        body: "You hit your task cap every day this week — bonus credited.",
        timestamp: now.subtract(const Duration(hours: 9)),
        isRead: true,
      ),
      AppNotification(
        id: 'n4',
        type: NotificationType.withdrawalQueued,
        title: 'Withdrawal queued',
        body: 'Your payout is queued for the 1st and will go to your UPI ID.',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: 'n5',
        type: NotificationType.taskCredited,
        title: 'Task credited',
        body: 'You earned ₹100 for completing a video-ad task.',
        timestamp: now.subtract(const Duration(days: 1, hours: 4)),
        isRead: true,
      ),
      AppNotification(
        id: 'n6',
        type: NotificationType.referralConverted,
        title: 'Referral pending',
        body: "Vi***m S. signed up with your code. You'll earn ₹125 once "
            'they go Premium.',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }
}
