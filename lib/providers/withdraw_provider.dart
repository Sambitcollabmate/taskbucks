import 'package:flutter/foundation.dart';

import '../data/models/withdraw_summary.dart';
import '../data/services/withdraw_service.dart';
import 'balance_provider.dart';

/// Holds Withdraw screen state — same role as [WalletProvider]/[TasksProvider].
class WithdrawProvider extends ChangeNotifier {
  final WithdrawService _service;
  final BalanceProvider _balanceProvider;

  WithdrawProvider({required this._balanceProvider, WithdrawService? service})
      : _service = service ?? WithdrawService() {
    load();
  }

  WithdrawSummary? _summary;
  bool _isLoading = false;
  bool _isSubmitting = false;

  WithdrawSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _summary = await _service.fetchWithdrawSummary();

    _isLoading = false;
    notifyListeners();
  }

  /// Lets the caller's [ApiException] (invalid amount, no UPI set, recent-
  /// UPI cap, etc. — `WithdrawalController::store`) propagate rather than
  /// swallowing it, so the screen can show the server's actual message.
  Future<void> queueWithdrawal({
    required double amount,
    required WithdrawMethodType method,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final result = await _service.queueWithdrawal(amount: amount, method: method);
      _balanceProvider.setBalance(result.availableBalance);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
