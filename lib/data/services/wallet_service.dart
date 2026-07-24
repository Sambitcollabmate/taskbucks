import '../models/transaction.dart';
import '../models/wallet_summary.dart';

/// Fake data source for the Wallet screen. Returns the same shape the real
/// Laravel endpoint will return once it exists (see PROJECT.md Section 4/7).
class WalletService {
  Future<WalletSummary> fetchWalletSummary() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    return WalletSummary(
      breakdown: const WalletBreakdown(
        taskAdEarnings: 1200,
        referralCommissions: 250,
        pendingAmount: 125,
      ),
      paymentMethod: const PaymentMethod(upiId: 'sambit@okhdfcbank', isDefault: true),
      recentActivity: [
        Transaction(
          id: 't1',
          title: 'Ad task reward',
          date: now.subtract(const Duration(hours: 3)),
          amount: 100,
          type: TransactionType.credit,
          category: TransactionCategory.task,
        ),
        Transaction(
          id: 't2',
          title: 'Referral commission — Ayesha K.',
          date: now.subtract(const Duration(hours: 9)),
          amount: 125,
          type: TransactionType.credit,
          category: TransactionCategory.referral,
        ),
        Transaction(
          id: 't3',
          title: 'Monthly withdrawal',
          date: now.subtract(const Duration(days: 2)),
          amount: 120,
          type: TransactionType.debit,
          category: TransactionCategory.withdrawal,
        ),
        Transaction(
          id: 't4',
          title: 'Ad task reward',
          date: now.subtract(const Duration(days: 2, hours: 4)),
          amount: 100,
          type: TransactionType.credit,
          category: TransactionCategory.ad,
        ),
        Transaction(
          id: 't5',
          title: 'Referral commission — Vikram S.',
          date: now.subtract(const Duration(days: 3)),
          amount: 125,
          type: TransactionType.credit,
          category: TransactionCategory.referral,
        ),
      ],
    );
  }
}
