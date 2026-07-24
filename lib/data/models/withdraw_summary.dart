/// Withdrawals only go to UPI or a verified bank account (PROJECT.md 2),
/// never PayPal/Payoneer.
enum WithdrawMethodType { upi, bank }

/// Fake data backing the Withdraw screen (PROJECT.md Phase 4). Available
/// balance itself isn't stored here: it comes from the shared
/// `BalanceProvider`, same single-source-of-truth fix Home/Wallet already
/// use, rather than a 4th independent copy of the number.
class WithdrawSummary {
  final String upiId;
  final DateTime upiAddedAt;
  final String bankAccountMasked;

  const WithdrawSummary({
    required this.upiId,
    required this.upiAddedAt,
    required this.bankAccountMasked,
  });

  /// New UPI IDs are capped at ₹5,000 for their first 24 hours as a fraud
  /// safeguard. The Withdraw screen only surfaces this as a notice; real
  /// enforcement (and the auto-retry it mentions) happens server-side.
  bool get isUpiRecentlyAdded =>
      DateTime.now().difference(upiAddedAt) < const Duration(hours: 24);
}

/// Withdrawals are processed once a month, on the 1st (PROJECT.md 2). If
/// [from] (defaults to now) already is the 1st, that's this window's date;
/// otherwise it's the 1st of the following month.
DateTime nextPayoutDate([DateTime? from]) {
  final today = from ?? DateTime.now();
  if (today.day == 1) return DateTime(today.year, today.month, 1);

  final nextMonth = today.month == 12 ? 1 : today.month + 1;
  final nextYear = today.month == 12 ? today.year + 1 : today.year;
  return DateTime(nextYear, nextMonth, 1);
}
