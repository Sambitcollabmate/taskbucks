/// Credit (money in) vs debit (money out) — drives the green/red amount
/// convention shared by Wallet, Transactions, and Notifications (see
/// PROJECT.md 6.3, `txn_row`).
enum TransactionType { credit, debit }

/// What generated the transaction, used to pick an icon in `txn_row`.
enum TransactionCategory { task, ad, referral, withdrawal, other }

class Transaction {
  final String id;
  final String title;
  final DateTime date;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;

  const Transaction({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    this.category = TransactionCategory.other,
  });
}
