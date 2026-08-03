import 'package:flutter/foundation.dart';

import '../data/models/home_summary.dart';
import '../data/services/home_service.dart';
import 'balance_provider.dart';

/// Holds Home screen state. Similar role to a small React context/store:
/// widgets that `watch` this get rebuilt whenever [notifyListeners] fires.
class HomeProvider extends ChangeNotifier {
  final HomeService _service;
  final BalanceProvider _balanceProvider;

  HomeProvider({required this._balanceProvider, HomeService? service})
      : _service = service ?? HomeService() {
    load();
  }

  HomeSummary? _summary;
  bool _isLoading = false;

  HomeSummary? get summary => _summary;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.fetchHomeSummary();
    _summary = result.summary;
    _balanceProvider.setBalance(result.balance);

    _isLoading = false;
    notifyListeners();
  }
}
