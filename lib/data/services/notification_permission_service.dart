import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

/// Wraps Android 13+'s POST_NOTIFICATIONS runtime permission (a no-op on
/// platforms that don't require it, e.g. iOS/older Android — permission_handler
/// handles that fallback itself). [hasPrompted] is persisted so the app asks
/// at most once at its deliberate moment (first task completion), never as
/// a repeated nag — same secure-storage pattern as `SessionService`.
class NotificationPermissionService {
  static const _promptedKey = 'notification_permission_prompted';

  final FlutterSecureStorage _storage;

  NotificationPermissionService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<bool> hasPrompted() async {
    final value = await _storage.read(key: _promptedKey);
    return value == 'true';
  }

  Future<void> markPrompted() => _storage.write(key: _promptedKey, value: 'true');

  Future<PermissionStatus> status() => Permission.notification.status;

  Future<PermissionStatus> request() => Permission.notification.request();
}
