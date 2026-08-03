import '../../core/network/api_client.dart';
import '../models/withdraw_summary.dart';

class WithdrawalQueueResult {
  final double availableBalance;

  const WithdrawalQueueResult({required this.availableBalance});
}

/// Real `GET`/`POST /v1/withdrawals` calls (api_requirements.md §6).
class WithdrawService {
  Future<WithdrawSummary> fetchWithdrawSummary() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/withdrawals');
      final json = response.data as Map<String, dynamic>;
      return WithdrawSummary(
        upiId: json['upi_id'] as String?,
        upiAddedAt: json['upi_added_at'] == null
            ? null
            : DateTime.parse(json['upi_added_at'] as String),
        bankAccountMasked: json['bank_account_masked'] as String?,
      );
    });
  }

  /// [method] is always `upi` in practice (see [WithdrawMethodType]'s doc
  /// comment) — kept as a param for when `bank` becomes real.
  Future<WithdrawalQueueResult> queueWithdrawal({
    required double amount,
    required WithdrawMethodType method,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/withdrawals', data: {
        'amount': amount,
        'method': method.name,
      });
      final json = response.data as Map<String, dynamic>;
      return WithdrawalQueueResult(
        availableBalance: double.parse(json['available_balance'] as String),
      );
    });
  }
}
