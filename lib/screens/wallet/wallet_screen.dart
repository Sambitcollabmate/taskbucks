import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/balance_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/balance_hero_card.dart';
import '../../shared/widgets/notice_card.dart';
import '../../shared/widgets/txn_row.dart';
import '../settings/settings_screen.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/wallet_breakdown_card.dart';

/// Days remaining until the next monthly payout window (always the 1st).
int _daysUntilNextPayout() {
  final now = DateTime.now();
  final nextFirst = DateTime(now.year, now.month + 1, 1);
  return nextFirst.difference(DateTime(now.year, now.month, now.day)).inDays;
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletProvider(balanceProvider: context.read<BalanceProvider>()),
      child: const _WalletScreenBody(),
    );
  }
}

class _WalletScreenBody extends StatelessWidget {
  const _WalletScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<WalletProvider>(
          builder: (context, provider, _) {
            final l10n = AppLocalizations.of(context);
            final summary = provider.summary;
            final balance = context.watch<BalanceProvider>().balance;

            if (provider.isLoading && summary == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (summary == null) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Text(l10n.walletTitle, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  BalanceHeroCard(
                    balance: balance,
                    primaryLabel: l10n.withdrawLabel,
                    primaryIcon: LucideIcons.arrowUpRight,
                    onPrimaryTap: () => context.push('/withdraw'),
                    secondaryLabel: l10n.historyLabel,
                    secondaryIcon: LucideIcons.history,
                    onSecondaryTap: () => context.push('/transactions'),
                  ),
                  const SizedBox(height: 16),
                  NoticeCard(
                    variant: NoticeVariant.warn,
                    message: l10n.withdrawalWindowNotice(_daysUntilNextPayout()),
                  ),
                  const SizedBox(height: 16),
                  WalletBreakdownCard(breakdown: summary.breakdown),
                  const SizedBox(height: 16),
                  Text(l10n.paymentMethodTitle, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (summary.paymentMethod != null)
                    PaymentMethodCard(
                      method: summary.paymentMethod!,
                      onTap: () => context.push(
                        '/settings',
                        extra: SettingsSection.payment,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => context.push(
                        '/settings',
                        extra: SettingsSection.payment,
                      ),
                      child: NoticeCard(
                        variant: NoticeVariant.warn,
                        message: l10n.addUpiNotice,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(l10n.recentActivityTitle, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        for (final txn in summary.recentActivity) ...[
                          TxnRow(transaction: txn),
                          if (txn != summary.recentActivity.last)
                            const Divider(height: 24),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
