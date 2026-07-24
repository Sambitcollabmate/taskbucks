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
  final PaymentMethod paymentMethod;
  final List<Transaction> recentActivity;

  const WalletSummary({
    required this.breakdown,
    required this.paymentMethod,
    required this.recentActivity,
  });
}
