import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/balance_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/balance_hero_card.dart';
import '../../shared/widgets/notice_card.dart';
import '../../shared/widgets/txn_row.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/wallet_breakdown_card.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletProvider(),
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
                  Text('Wallet', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  BalanceHeroCard(
                    balance: balance,
                    primaryLabel: 'Withdraw',
                    primaryIcon: LucideIcons.arrowUpRight,
                    onPrimaryTap: () => context.push('/withdraw'),
                    secondaryLabel: 'History',
                    secondaryIcon: LucideIcons.history,
                    onSecondaryTap: () => context.push('/transactions'),
                  ),
                  const SizedBox(height: 16),
                  const NoticeCard(
                    variant: NoticeVariant.warn,
                    message:
                        'Withdrawals are processed once a month, on the 1st, '
                        'to your UPI or verified bank account only.',
                  ),
                  const SizedBox(height: 16),
                  WalletBreakdownCard(breakdown: summary.breakdown),
                  const SizedBox(height: 16),
                  Text('Payment method', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  PaymentMethodCard(method: summary.paymentMethod),
                  const SizedBox(height: 20),
                  Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
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
