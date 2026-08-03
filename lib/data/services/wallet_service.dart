import '../../core/network/api_client.dart';
import '../models/transaction.dart';
import '../models/wallet_summary.dart';

/// Real `GET /v1/wallet` call (api_requirements.md §4). `balance` is
/// returned separately from [WalletSummary] since it belongs to the
/// shared `BalanceProvider`, not this screen-scoped summary (PROJECT.md
/// 6.3's `balance_hero_card` addendum) — the caller applies it there.
class WalletService {
  Future<({WalletSummary summary, double balance})> fetchWalletSummary() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/wallet');
      final json = response.data as Map<String, dynamic>;
      final breakdown = json['breakdown'] as Map<String, dynamic>;
      final paymentMethodJson = json['payment_method'] as Map<String, dynamic>?;
      final activity = json['recent_activity'] as List;

      return (
        balance: double.parse(json['balance'] as String),
        summary: WalletSummary(
          breakdown: WalletBreakdown(
            taskAdEarnings: double.parse(breakdown['task_ad_earnings'] as String),
            referralCommissions: double.parse(breakdown['referral_commissions'] as String),
            bonusRewards: double.parse(breakdown['bonus_rewards'] as String),
          ),
          paymentMethod: paymentMethodJson == null || paymentMethodJson['upi_id'] == null
              ? null
              : PaymentMethod(
                  upiId: paymentMethodJson['upi_id'] as String,
                  isDefault: paymentMethodJson['is_default'] as bool? ?? false,
                ),
          recentActivity: activity
              .cast<Map<String, dynamic>>()
              .map(transactionFromJson)
              .toList(),
        ),
      );
    });
  }
}

TransactionCategory transactionCategoryFromWire(String wire) {
  return switch (wire) {
    'task' => TransactionCategory.task,
    'ad' => TransactionCategory.ad,
    'referral' => TransactionCategory.referral,
    'withdrawal' => TransactionCategory.withdrawal,
    'streak_bonus' => TransactionCategory.streakBonus,
    'premium_renewal' => TransactionCategory.premiumRenewal,
    _ => TransactionCategory.other,
  };
}

Transaction transactionFromJson(Map<String, dynamic> json) {
  return Transaction(
    id: json['id'].toString(),
    title: json['title'] as String,
    date: DateTime.parse(json['date'] as String),
    amount: double.parse(json['amount'] as String),
    type: json['type'] == 'debit' ? TransactionType.debit : TransactionType.credit,
    category: transactionCategoryFromWire(json['category'] as String),
  );
}
