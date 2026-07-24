import 'package:flutter/foundation.dart';

import '../data/models/app_notification.dart';
import '../data/services/notifications_service.dart';

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

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get hasUnread => _notifications.any((n) => !n.isRead);

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
