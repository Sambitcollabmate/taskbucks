import 'package:flutter/foundation.dart';

/// Languages the app can display in — English is the only one actually
/// localized today; Hindi is selectable so the picker (and Profile's "App
/// language" row) reflect the real intended feature, but the app's copy
/// doesn't change yet. Real l10n wiring is a later phase, same fake-now/
/// real-later pattern as AdMob and Google Play Billing (see PROJECT.md 7).
enum AppLanguage { english, hindi }

extension AppLanguageLabel on AppLanguage {
  String get label {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'हिंदी';
    }
  }
}

/// Single source of truth for the selected display language, shared across
/// Profile's "App language" row and its picker sheet (same singleton
/// pattern as `balanceProvider`/`notificationsProvider`).
class LanguageProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }
}

final languageProvider = LanguageProvider();
