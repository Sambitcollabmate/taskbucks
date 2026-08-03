import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// App-wide branding constants. Change here to rebrand across every screen.
class AppConfig {
  AppConfig._();

  static const String brandName = 'EarnBucks';
  static const String brandDomain = 'earnbucks.in';

  /// Laravel API base URL (`earnbucks-api`, routes under `routes/api.php`'s
  /// `v1` prefix). Overridable per-run via
  /// `flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8000/api/v1`
  /// (needed for a physical device, which can't reach `localhost`/`10.0.2.2`).
  /// Defaults assume `php artisan serve` on its default port 8000:
  /// - Android emulator: `10.0.2.2` aliases the host machine's `localhost`.
  /// - iOS simulator / desktop / web: `127.0.0.1` reaches the host directly.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String resolveApiBaseUrl() {
    if (apiBaseUrl.isNotEmpty) return apiBaseUrl;
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8000/api/v1';
    return 'http://127.0.0.1:8000/api/v1';
  }
}
