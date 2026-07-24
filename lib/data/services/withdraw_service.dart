import '../models/withdraw_summary.dart';

/// Fake data source for the Withdraw screen. Returns the same shape the
/// real Laravel endpoint will return once it exists (see PROJECT.md
/// Section 4/7). `upiAddedAt` is set inside the last 24 hours so the
/// new-UPI ₹5,000 notice shows up without extra setup; push it further
/// into the past to see the steady-state (no notice) case.
class WithdrawService {
  Future<WithdrawSummary> fetchWithdrawSummary() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return WithdrawSummary(
      upiId: 'sambit@okhdfcbank',
      upiAddedAt: DateTime.now().subtract(const Duration(hours: 6)),
      bankAccountMasked: 'HDFC Bank •••• 4521',
    );
  }

  Future<void> queueWithdrawal({
    required double amount,
    required WithdrawMethodType method,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: POST to a real Laravel /withdrawals endpoint once it exists
    // (PROJECT.md Phase 7). Fake success only for now — nothing here
    // actually deducts from BalanceProvider, since a real withdrawal
    // wouldn't clear the balance until the payout cycle actually runs.
  }
}
