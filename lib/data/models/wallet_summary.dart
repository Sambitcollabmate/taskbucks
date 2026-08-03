import 'transaction.dart';

/// Balance breakdown shown on Wallet — task/ad earnings, referral
/// commissions, and bonus rewards (weekly leaderboard gifts + bonus ad
/// slots) as three separate, already-cleared totals.
class WalletBreakdown {
  final double taskAdEarnings;
  final double referralCommissions;
  final double bonusRewards;

  const WalletBreakdown({
    required this.taskAdEarnings,
    required this.referralCommissions,
    required this.bonusRewards,
  });
}

/// Withdrawals go to UPI or a verified bank account only (PROJECT.md 2) —
/// this fake data models the UPI case, the only one wired up so far.
class PaymentMethod {
  final String upiId;
  final bool isDefault;

  const PaymentMethod({required this.upiId, required this.isDefault});
}

class WalletSummary {
  final WalletBreakdown breakdown;
  // Null when the user hasn't added a UPI ID yet (GET /v1/wallet's
  // payment_method.upi_id can be null) — no bank-account UI exists yet
  // (PROJECT.md/api_requirements.md §6), so UPI is the only method this
  // models.
  final PaymentMethod? paymentMethod;
  final List<Transaction> recentActivity;

  const WalletSummary({
    required this.breakdown,
    required this.paymentMethod,
    required this.recentActivity,
  });
}
