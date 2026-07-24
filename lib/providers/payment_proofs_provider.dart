import 'package:flutter/foundation.dart';

import '../data/models/payment_proofs_summary.dart';
import '../data/services/payment_proofs_service.dart';

/// Holds Payment Proofs screen state — same role as [AboutProvider]/
/// [ReferProvider]: widgets that watch this rebuild whenever
/// [notifyListeners] fires.
class PaymentProofsProvider extends ChangeNotifier {
  final PaymentProofsService _service;

  PaymentProofsProvider({PaymentProofsService? service})
      : _service = service ?? PaymentProofsService() {
    load();
  }

  PaymentProofsSummary? _summary;
  bool _isLoading = false;

  PaymentProofsSummary? get summary => _summary;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _summary = await _service.fetchSummary();

    _isLoading = false;
    notifyListeners();
  }
}
