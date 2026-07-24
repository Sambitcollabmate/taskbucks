import 'package:flutter/foundation.dart';

import '../data/models/withdraw_summary.dart';
import '../data/services/withdraw_service.dart';

/// Holds Withdraw screen state — same role as [WalletProvider]/[TasksProvider].
class WithdrawProvider extends ChangeNotifier {
  final WithdrawService _service;

  WithdrawProvider({WithdrawService? service}) : _service = service ?? WithdrawService() {
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

  Future<void> queueWithdrawal({
    required double amount,
    required WithdrawMethodType method,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    await _service.queueWithdrawal(amount: amount, method: method);

    _isSubmitting = false;
    notifyListeners();
  }
}
