import 'package:flutter/widgets.dart';

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

  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.hindi:
        return const Locale('hi');
    }
  }
}

/// Single source of truth for the selected display language, shared across
/// Profile's "App language" row and its picker sheet (same singleton
/// pattern as `balanceProvider`/`notificationsProvider`), and consumed by
/// `MaterialApp.router`'s `locale` to drive real l10n.
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
