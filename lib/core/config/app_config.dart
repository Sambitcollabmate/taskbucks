/// App-wide branding constants. Change here to rebrand across every screen.
class AppConfig {
  AppConfig._();

  static const String brandName = 'EarnBucks';
  static const String brandDomain = 'earnbucks.tech';

  /// Laravel API base URL (`earnbucks-api`, routes under `routes/api.php`'s
  /// `v1` prefix). Defaults to the live production API
  /// (`DEPLOYMENT.md`'s `api.earnbucks.tech`). Overridable via
  /// `dart_defines.json` (gitignored — copy `dart_defines.example.json` and
  /// fill it in), passed with
  /// `flutter run --dart-define-from-file=dart_defines.json` — needed for
  /// local/LAN dev against `php artisan serve`, since a physical device
  /// can't reach `localhost`/`10.0.2.2` either.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String resolveApiBaseUrl() {
    if (apiBaseUrl.isNotEmpty) return apiBaseUrl;
    return 'https://api.earnbucks.tech/api/v1';
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
