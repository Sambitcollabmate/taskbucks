import 'package:flutter/foundation.dart';

import '../data/models/wallet_summary.dart';
import '../data/services/wallet_service.dart';

/// Holds Wallet screen state — same role as [HomeProvider]/[TasksProvider]:
/// widgets that watch this rebuild whenever [notifyListeners] fires.
class WalletProvider extends ChangeNotifier {
  final WalletService _service;

  WalletProvider({WalletService? service}) : _service = service ?? WalletService() {
    load();
  }

  WalletSummary? _summary;
  bool _isLoading = false;

  WalletSummary? get summary => _summary;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _summary = await _service.fetchWalletSummary();

    _isLoading = false;
    notifyListeners();
  }
}
