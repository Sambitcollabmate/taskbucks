import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// App-wide branding constants. Change here to rebrand across every screen.
class AppConfig {
  AppConfig._();

  static const String brandName = 'EarnBucks';
  static const String brandDomain = 'earnbucks.tech';

  /// Laravel API base URL (`earnbucks-api`, routes under `routes/api.php`'s
  /// `v1` prefix). Overridable via `dart_defines.json` (gitignored — copy
  /// `dart_defines.example.json` and fill it in), passed with
  /// `flutter run --dart-define-from-file=dart_defines.json`. Needed for a
  /// physical device, which can't reach `localhost`/`10.0.2.2`.
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

  /// MSG91 Login-with-OTP widget credentials (MSG91_WIDGET_REVIEW.md). Both
  /// are client-side-safe by MSG91's own design (unlike the account
  /// `authkey`, which stays server-side in Laravel), but are still kept out
  /// of source — set via `dart_defines.json` (see [apiBaseUrl]'s doc above
  /// for the file-based setup; same file, same flag).
  static const String msg91WidgetId = String.fromEnvironment(
    'MSG91_WIDGET_ID',
    defaultValue: '',
  );

  static const String msg91AuthToken = String.fromEnvironment(
    'MSG91_AUTH_TOKEN',
    defaultValue: '',
  );
}
