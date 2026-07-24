import 'package:flutter/foundation.dart';

import '../data/models/transaction.dart';
import '../data/services/transactions_service.dart';

/// Filter tab shown on the Transactions screen. Maps onto
/// [TransactionCategory] — [tasks] covers both `task` and `ad` categories
/// since those both surface under the Tasks tab elsewhere in the app.
enum TransactionFilter { all, tasks, referrals, withdrawals }

const _pageSize = 8;

/// Holds Transactions screen state — same role as [WalletProvider]: widgets
/// that watch this rebuild whenever [notifyListeners] fires.
///
/// Filtering and infinite-scroll pagination ([loadMore], called by the
/// screen as the list nears its scroll end) both happen client-side over
/// the full fake history returned by [TransactionsService]. TODO: once a
/// real Laravel endpoint exists, move both to server-side query params
/// instead of loading the whole history and slicing it here (PROJECT.md
/// Section 4).
class TransactionsProvider extends ChangeNotifier {
  final TransactionsService _service;

  TransactionsProvider({TransactionsService? service, TransactionFilter? initialFilter})
    : _service = service ?? TransactionsService(),
      _filter = initialFilter ?? TransactionFilter.all {
    load();
  }

  List<Transaction> _all = [];
  bool _isLoading = false;
  TransactionFilter _filter;
  int _visibleCount = _pageSize;

  bool get isLoading => _isLoading;
  TransactionFilter get filter => _filter;

  List<Transaction> get _filtered {
    switch (_filter) {
      case TransactionFilter.all:
        return _all;
      case TransactionFilter.tasks:
        return _all
            .where(
              (t) =>
                  t.category == TransactionCategory.task ||
                  t.category == TransactionCategory.ad,
            )
            .toList();
      case TransactionFilter.referrals:
        return _all.where((t) => t.category == TransactionCategory.referral).toList();
      case TransactionFilter.withdrawals:
        return _all.where((t) => t.category == TransactionCategory.withdrawal).toList();
    }
  }

  List<Transaction> get visibleTransactions => _filtered.take(_visibleCount).toList();

  bool get hasMore => _visibleCount < _filtered.length;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _all = await _service.fetchTransactions();

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(TransactionFilter filter) {
    if (filter == _filter) return;
    _filter = filter;
    _visibleCount = _pageSize;
    notifyListeners();
  }

  void loadMore() {
    _visibleCount += _pageSize;
    notifyListeners();
  }
}
