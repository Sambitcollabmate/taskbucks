import 'transaction.dart';

/// Balance breakdown shown on Wallet — task/ad earnings and referral
/// commissions are already cleared; `pendingAmount` is referral commission
/// not yet credited (PROJECT.md 2: referral ₹15 shows "pending" until the
/// referred user's Premium purchase clears).
class WalletBreakdown {
  final double taskAdEarnings;
  final double referralCommissions;
  final double pendingAmount;

  const WalletBreakdown({
    required this.taskAdEarnings,
    required this.referralCommissions,
    required this.pendingAmount,
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
  final double balance;
  final WalletBreakdown breakdown;
  final PaymentMethod paymentMethod;
  final List<Transaction> recentActivity;

  const WalletSummary({
    required this.balance,
    required this.breakdown,
    required this.paymentMethod,
    required this.recentActivity,
  });
}
