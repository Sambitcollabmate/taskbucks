import '../../core/network/api_client.dart';
import '../models/app_notification.dart';
import '../models/notification_type.dart';

/// Real `GET /v1/notifications`/`PATCH /v1/notifications/{id}/read`/
/// `PATCH /v1/notifications/read-all` calls (api_requirements.md §8).
class NotificationsService {
  /// Fetches a single large-ish page rather than building out full
  /// infinite-scroll (no pagination UI existed for this screen even before
  /// a real backend did) — `unreadCount` is server-computed across *all*
  /// notifications, not just this page, so it stays correct regardless.
  Future<({List<AppNotification> notifications, int unreadCount})> fetchNotifications() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/notifications', queryParameters: {'per_page': 50});
      final json = response.data as Map<String, dynamic>;
      return (
        notifications: (json['data'] as List)
            .cast<Map<String, dynamic>>()
            .map(_fromJson)
            .toList(),
        unreadCount: json['unread_count'] as int,
      );
    });
  }

  Future<void> markRead(String id) {
    return ApiClient.call((dio) => dio.patch('/notifications/$id/read'));
  }

  Future<void> markAllRead() {
    return ApiClient.call((dio) => dio.patch('/notifications/read-all'));
  }

  AppNotification _fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(),
      type: _typeFromWire(json['type'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool,
    );
  }

  NotificationType _typeFromWire(String wire) {
    return switch (wire) {
      'task_credited' => NotificationType.taskCredited,
      'referral_converted' => NotificationType.referralConverted,
      'withdrawal_queued' => NotificationType.withdrawalQueued,
      'streak_bonus' => NotificationType.streakBonus,
      'new_login_detected' => NotificationType.newLoginDetected,
      _ => NotificationType.premiumPromo,
    };
  }
}
