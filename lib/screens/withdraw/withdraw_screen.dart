import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/withdraw_summary.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/balance_provider.dart';
import '../../providers/withdraw_provider.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import '../../shared/widgets/notice_card.dart';
import '../auth/widgets/auth_text_field.dart';
import '../settings/settings_screen.dart';
import 'widgets/withdraw_method_row.dart';

/// Push-only screen (PROJECT.md 6.1), reached from Wallet's Withdraw
/// button and Notifications' withdrawal-queued rows. Withdrawals are
/// processed once a month, on the 1st, to UPI or a verified bank account
/// only (PROJECT.md 2) — this screen only ever queues/requests a payout,
/// it never claims one is instant or complete, since the actual transfer
/// doesn't happen until the next 1st.
class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WithdrawProvider(balanceProvider: context.read<BalanceProvider>()),
      child: const _WithdrawScreenBody(),
    );
  }
}

class _WithdrawScreenBody extends StatefulWidget {
  const _WithdrawScreenBody();

  @override
  State<_WithdrawScreenBody> createState() => _WithdrawScreenBodyState();
}

class _WithdrawScreenBodyState extends State<_WithdrawScreenBody> {
  final _amountController = TextEditingController();
  final _method = WithdrawMethodType.upi;
  bool _prefilled = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _prefillAmount(double balance) {
    if (_prefilled) return;
    _prefilled = true;
    _amountController.text =
        balance == balance.roundToDouble() ? balance.toStringAsFixed(0) : balance.toStringAsFixed(2);
  }

  Future<void> _onSubmit(WithdrawProvider provider, double balance) async {
    if (provider.isSubmitting) return;
    final l10n = AppLocalizations.of(context);

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidAmount)),
      );
      return;
    }
    if (amount > balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cannotExceedBalance)),
      );
      return;
    }

    try {
      await provider.queueWithdrawal(amount: amount, method: _method);
      if (!mounted) return;
      final dateFormat = DateFormat('d MMM yyyy');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.withdrawalRequestedMessage(dateFormat.format(nextPayoutDate())),
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final balance = context.watch<BalanceProvider>().balance;
    final dateFormat = DateFormat('d MMM yyyy');
    final payoutDate = nextPayoutDate();
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(l10n.withdrawTitle),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<WithdrawProvider>(
          builder: (context, provider, _) {
            final summary = provider.summary;

            if (provider.isLoading && summary == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (summary == null) {
              return const SizedBox.shrink();
            }

            _prefillAmount(balance);

            final now = DateTime.now();
            final daysUntilPayout =
                payoutDate.difference(DateTime(now.year, now.month, now.day)).inDays;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                Text(
                  l10n.availableBalance,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormat.format(balance),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                NoticeCard(
                  variant: NoticeVariant.warn,
                  message: l10n.withdrawWindowNotice(daysUntilPayout),
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _amountController,
                  label: l10n.amountLabel,
                  hintText: l10n.enterAmountHint,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.payoutMethodLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                if (summary.upiId != null)
                  WithdrawMethodRow(
                    type: WithdrawMethodType.upi,
                    label: l10n.upiMethodLabel,
                    detail: summary.upiId!,
                    selected: true,
                    onTap: () {},
                  )
                else
                  GestureDetector(
                    onTap: () => context.push('/settings', extra: SettingsSection.payment),
                    child: NoticeCard(
                      variant: NoticeVariant.warn,
                      message: l10n.addUpiBeforeWithdrawNotice,
                    ),
                  ),
                // No bank-account add/edit flow exists yet, so `bank` isn't
                // a selectable option here (api_requirements.md §6,
                // 2026-07-28 decision) — only UPI is offered.
                if (summary.isUpiRecentlyAdded) ...[
                  const SizedBox(height: 12),
                  NoticeCard(
                    variant: NoticeVariant.warn,
                    message: l10n.recentUpiCapNotice,
                  ),
                ],
                const SizedBox(height: 24),
                GradientCtaButton(
                  label: provider.isSubmitting
                      ? l10n.queuingLabel
                      : l10n.queueWithdrawalFor(dateFormat.format(payoutDate)),
                  onTap: () => _onSubmit(provider, balance),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.firstTimeWithdrawalNotice,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
