import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:earnbucks/l10n/app_localizations.dart';
import 'package:earnbucks/shared/widgets/balance_hero_card.dart';

void main() {
  testWidgets('BalanceHeroCard renders the available balance', (
    WidgetTester tester,
  ) async {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BalanceHeroCard(
            balance: 1234.56,
            primaryLabel: 'Wallet',
            primaryIcon: LucideIcons.wallet,
            onPrimaryTap: () {},
            secondaryLabel: 'Refer & earn',
            secondaryIcon: LucideIcons.userPlus,
            onSecondaryTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Available balance'), findsOneWidget);
    expect(find.text(formatter.format(1234.56)), findsOneWidget);
  });
}
