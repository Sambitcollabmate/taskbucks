import 'package:flutter/foundation.dart';

import '../data/models/refer_summary.dart';
import '../data/services/refer_service.dart';

/// Holds Refer & Earn screen state — same role as [HomeProvider]/
/// [WalletProvider]: widgets that watch this rebuild whenever
/// [notifyListeners] fires.
class ReferProvider extends ChangeNotifier {
  final ReferService _service;

  ReferProvider({ReferService? service}) : _service = service ?? ReferService() {
    load();
  }

  ReferSummary? _summary;
  bool _isLoading = false;

  ReferSummary? get summary => _summary;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _summary = await _service.fetchReferSummary();

    _isLoading = false;
    notifyListeners();
  }
}
