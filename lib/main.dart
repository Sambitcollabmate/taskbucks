import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/balance_provider.dart';
import 'providers/language_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const EarnBucksApp());
}

class EarnBucksApp extends StatelessWidget {
  const EarnBucksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<BalanceProvider>.value(value: balanceProvider),
        ChangeNotifierProvider<NotificationsProvider>.value(
          value: notificationsProvider,
        ),
        ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, language, _) {
          return MaterialApp.router(
            title: AppConfig.brandName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: appRouter,
            locale: language.language.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          );
        },
      ),
    );
  }
}
