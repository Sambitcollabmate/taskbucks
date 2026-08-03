import 'package:flutter/foundation.dart';

import '../data/models/app_notification.dart';
import '../data/models/notification_type.dart';
import '../data/services/notifications_service.dart';

/// Which of the Notifications screen's tabs is active. Maps onto
/// [NotificationCategory] — [all] shows everything.
enum NotificationFilter { all, earnings, account, promotions }

/// Holds Notifications screen state — same role as [TransactionsProvider]:
/// widgets that watch this rebuild whenever [notifyListeners] fires.
class NotificationsProvider extends ChangeNotifier {
  final NotificationsService _service;

  // Deliberately does NOT auto-load here: this is a top-level singleton
  // (see `notificationsProvider` below), constructed once at app startup —
  // long before a user is authenticated. `GET /v1/notifications` requires
  // `auth:sanctum`, so `AuthProvider` calls [load] itself once a session is
  // actually established (`completeLogin`/a valid restored session) and
  // [clear] on logout, instead of this eagerly firing an unauthenticated
  // request at import time.
  NotificationsProvider({NotificationsService? service})
    : _service = service ?? NotificationsService();

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  NotificationFilter _filter = NotificationFilter.all;
  // Server-computed across all notifications, not just the loaded page
  // (NotificationController::index's unread_count) — kept separate from
  // `_notifications` so it stays accurate even before full pagination
  // exists here.
  int _unreadCount = 0;

  List<AppNotification> get notifications {
    switch (_filter) {
      case NotificationFilter.all:
        return _notifications;
      case NotificationFilter.earnings:
        return _notifications
            .where((n) => n.type.category == NotificationCategory.earnings)
            .toList();
      case NotificationFilter.account:
        return _notifications
            .where((n) => n.type.category == NotificationCategory.account)
            .toList();
      case NotificationFilter.promotions:
        return _notifications
            .where((n) => n.type.category == NotificationCategory.promotions)
            .toList();
    }
  }

  bool get isLoading => _isLoading;
  NotificationFilter get filter => _filter;
  bool get hasUnread => _unreadCount > 0;
  int get unreadCount => _unreadCount;

  void setFilter(NotificationFilter filter) {
    if (filter == _filter) return;
    _filter = filter;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.fetchNotifications();
    _notifications = result.notifications;
    _unreadCount = result.unreadCount;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1 || _notifications[index].isRead) return;

    _notifications[index] = _notifications[index].copyWith(isRead: true);
    _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
    notifyListeners();

    await _service.markRead(id);
  }

  Future<void> markAllRead() async {
    if (!hasUnread) return;
    _notifications = [for (final n in _notifications) n.copyWith(isRead: true)];
    _unreadCount = 0;
    notifyListeners();

    await _service.markAllRead();
  }

  /// Called by `AuthProvider` on logout — clears the previous user's
  /// notifications from memory rather than leaving them visible (however
  /// briefly) to whoever logs into the app next on this device.
  void clear() {
    _notifications = [];
    _unreadCount = 0;
    _filter = NotificationFilter.all;
    notifyListeners();
  }
}

/// One app-wide instance (same pattern as `balanceProvider`) so Home's bell
/// badge and the Notifications screen itself read and write the same
/// read/unread state instead of each holding their own copy.
final notificationsProvider = NotificationsProvider();
