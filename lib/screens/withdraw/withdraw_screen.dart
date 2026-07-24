import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/withdraw_summary.dart';
import '../../providers/balance_provider.dart';
import '../../providers/withdraw_provider.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import '../../shared/widgets/notice_card.dart';
import '../auth/widgets/auth_text_field.dart';
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
      create: (_) => WithdrawProvider(),
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
  WithdrawMethodType _method = WithdrawMethodType.upi;
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

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid withdrawal amount.')),
      );
      return;
    }
    if (amount > balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can't withdraw more than your available balance.")),
      );
      return;
    }

    await provider.queueWithdrawal(amount: amount, method: _method);
    if (!mounted) return;

    final dateFormat = DateFormat('d MMM yyyy');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Withdrawal requested — queued for the ${dateFormat.format(nextPayoutDate())} payout cycle.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Withdraw'),
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

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                const Text(
                  'Available balance',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
                  message:
                      'Withdrawals are processed once a month, on the 1st, '
                      'to UPI or a verified bank account only. Your request '
                      'will be queued for ${dateFormat.format(payoutDate)}, '
                      'not transferred right away.',
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _amountController,
                  label: 'Amount',
                  hintText: 'Enter amount',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payout method',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                WithdrawMethodRow(
                  type: WithdrawMethodType.upi,
                  label: 'UPI',
                  detail: summary.upiId,
                  selected: _method == WithdrawMethodType.upi,
                  onTap: () => setState(() => _method = WithdrawMethodType.upi),
                ),
                const SizedBox(height: 10),
                WithdrawMethodRow(
                  type: WithdrawMethodType.bank,
                  label: 'Bank transfer',
                  detail: summary.bankAccountMasked,
                  selected: _method == WithdrawMethodType.bank,
                  onTap: () => setState(() => _method = WithdrawMethodType.bank),
                ),
                if (_method == WithdrawMethodType.upi && summary.isUpiRecentlyAdded) ...[
                  const SizedBox(height: 12),
                  const NoticeCard(
                    variant: NoticeVariant.warn,
                    message:
                        'This UPI ID was added in the last 24 hours, so '
                        'withdrawals to it are capped at ₹5,000 during that '
                        "window. If a transfer fails for that reason, it "
                        'may auto-retry once the 24 hours pass.',
                  ),
                ],
                const SizedBox(height: 24),
                GradientCtaButton(
                  label: provider.isSubmitting
                      ? 'Queuing...'
                      : 'Queue withdrawal for ${dateFormat.format(payoutDate)}',
                  onTap: () => _onSubmit(provider, balance),
                ),
                const SizedBox(height: 10),
                const Text(
                  'First-time withdrawals may need manual verification.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
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
