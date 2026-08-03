import 'package:flutter/foundation.dart';

import '../data/models/wallet_summary.dart';
import '../data/services/wallet_service.dart';
import 'balance_provider.dart';

/// Holds Wallet screen state — same role as [HomeProvider]/[TasksProvider]:
/// widgets that watch this rebuild whenever [notifyListeners] fires.
class WalletProvider extends ChangeNotifier {
  final WalletService _service;
  final BalanceProvider _balanceProvider;

  WalletProvider({required this._balanceProvider, WalletService? service})
      : _service = service ?? WalletService() {
    load();
  }

  WalletSummary? _summary;
  bool _isLoading = false;

  WalletSummary? get summary => _summary;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.fetchWalletSummary();
    _summary = result.summary;
    _balanceProvider.setBalance(result.balance);

    _isLoading = false;
    notifyListeners();
  }
}
