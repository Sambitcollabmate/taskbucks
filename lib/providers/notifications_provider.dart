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

  NotificationsProvider({NotificationsService? service})
    : _service = service ?? NotificationsService() {
    load();
  }

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  NotificationFilter _filter = NotificationFilter.all;

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
  bool get hasUnread => _notifications.any((n) => !n.isRead);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void setFilter(NotificationFilter filter) {
    if (filter == _filter) return;
    _filter = filter;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _notifications = await _service.fetchNotifications();

    _isLoading = false;
    notifyListeners();
  }

  void markRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1 || _notifications[index].isRead) return;

    _notifications[index] = _notifications[index].copyWith(isRead: true);
    notifyListeners();
  }

  void markAllRead() {
    if (!hasUnread) return;
    _notifications = [for (final n in _notifications) n.copyWith(isRead: true)];
    notifyListeners();
  }
}

/// One app-wide instance (same pattern as `balanceProvider`) so Home's bell
/// badge and the Notifications screen itself read and write the same
/// read/unread state instead of each holding their own copy.
final notificationsProvider = NotificationsProvider();
