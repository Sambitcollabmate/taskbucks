import '../models/transaction.dart';

/// Fake data source for the Transactions screen. Returns the same shape the
/// real Laravel endpoint will return once it exists (see PROJECT.md
/// Section 4/7) — the full chronological history, not just Wallet's
/// 5-item recent-activity slice.
class TransactionsService {
  Future<List<Transaction>> fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    return [
      Transaction(
        id: 'tx1',
        title: 'Ad task reward',
        date: now.subtract(const Duration(hours: 3)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.task,
      ),
      Transaction(
        id: 'tx2',
        title: 'Referral commission — Ayesha K.',
        date: now.subtract(const Duration(hours: 9)),
        amount: 125,
        type: TransactionType.credit,
        category: TransactionCategory.referral,
      ),
      Transaction(
        id: 'tx3',
        title: '7-day streak bonus',
        date: now.subtract(const Duration(days: 1)),
        amount: 10,
        type: TransactionType.credit,
        category: TransactionCategory.streakBonus,
      ),
      Transaction(
        id: 'tx4',
        title: 'Monthly withdrawal',
        date: now.subtract(const Duration(days: 2)),
        amount: 120,
        type: TransactionType.debit,
        category: TransactionCategory.withdrawal,
      ),
      Transaction(
        id: 'tx5',
        title: 'Ad task reward',
        date: now.subtract(const Duration(days: 2, hours: 4)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.ad,
      ),
      Transaction(
        id: 'tx6',
        title: 'Referral commission — Vikram S.',
        date: now.subtract(const Duration(days: 3)),
        amount: 125,
        type: TransactionType.credit,
        category: TransactionCategory.referral,
      ),
      Transaction(
        id: 'tx7',
        title: 'Ad task reward',
        date: now.subtract(const Duration(days: 3, hours: 6)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.task,
      ),
      Transaction(
        id: 'tx8',
        title: 'Ad task reward',
        date: now.subtract(const Duration(days: 4)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.task,
      ),
      Transaction(
        id: 'tx9',
        title: 'Referral commission — Priya M.',
        date: now.subtract(const Duration(days: 5)),
        amount: 125,
        type: TransactionType.credit,
        category: TransactionCategory.referral,
      ),
      Transaction(
        id: 'tx10',
        title: 'Ad task reward',
        date: now.subtract(const Duration(days: 5, hours: 2)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.ad,
      ),
      Transaction(
        id: 'tx11',
        title: '3-day streak bonus',
        date: now.subtract(const Duration(days: 6)),
        amount: 5,
        type: TransactionType.credit,
        category: TransactionCategory.streakBonus,
      ),
      Transaction(
        id: 'tx12',
        title: 'Ad task reward',
        date: now.subtract(const Duration(days: 6, hours: 5)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.task,
      ),
      Transaction(
        id: 'tx13',
        title: 'Monthly withdrawal',
        date: now.subtract(const Duration(days: 32)),
        amount: 95,
        type: TransactionType.debit,
        category: TransactionCategory.withdrawal,
      ),
      Transaction(
        id: 'tx14',
        title: 'Referral commission — Rohit T.',
        date: now.subtract(const Duration(days: 8)),
        amount: 125,
        type: TransactionType.credit,
        category: TransactionCategory.referral,
      ),
      Transaction(
        id: 'tx15',
        title: 'Ad task reward',
        date: now.subtract(const Duration(days: 9)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.task,
      ),
      Transaction(
        id: 'tx16',
        title: 'Ad task reward',
        date: now.subtract(const Duration(days: 9, hours: 3)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.ad,
      ),
      Transaction(
        id: 'tx17',
        title: 'Referral commission — Sneha D.',
        date: now.subtract(const Duration(days: 10)),
        amount: 125,
        type: TransactionType.credit,
        category: TransactionCategory.referral,
      ),
      Transaction(
        id: 'tx18',
        title: 'Ad task reward',
        date: now.subtract(const Duration(days: 11)),
        amount: 100,
        type: TransactionType.credit,
        category: TransactionCategory.task,
      ),
    ];
  }
}
