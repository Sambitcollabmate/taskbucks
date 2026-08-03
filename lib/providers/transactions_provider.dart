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
/// screen as the list nears its scroll end) are both server-side now
/// (`GET /v1/transactions`, api_requirements.md §5) — switching [setFilter]
/// restarts from page 1 against the new filter rather than re-slicing a
/// locally-held full history.
class TransactionsProvider extends ChangeNotifier {
  final TransactionsService _service;

  TransactionsProvider({TransactionsService? service, TransactionFilter? initialFilter})
    : _service = service ?? TransactionsService(),
      _filter = initialFilter ?? TransactionFilter.all {
    load();
  }

  List<Transaction> _items = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  TransactionFilter _filter;
  int _page = 1;
  bool _hasMore = false;

  bool get isLoading => _isLoading;
  TransactionFilter get filter => _filter;
  List<Transaction> get visibleTransactions => _items;
  bool get hasMore => _hasMore;

  ({String? type, String? category, List<String>? categories}) get _filterParams {
    switch (_filter) {
      case TransactionFilter.all:
        return (type: null, category: null, categories: null);
      case TransactionFilter.tasks:
        return (type: null, category: null, categories: const ['task', 'ad']);
      case TransactionFilter.referrals:
        return (type: null, category: 'referral', categories: null);
      case TransactionFilter.withdrawals:
        return (type: null, category: 'withdrawal', categories: null);
    }
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final params = _filterParams;
    final result = await _service.fetchPage(
      page: 1,
      perPage: _pageSize,
      type: params.type,
      category: params.category,
      categories: params.categories,
    );
    _items = result.items;
    _page = result.currentPage;
    _hasMore = result.hasMore;

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(TransactionFilter filter) {
    if (filter == _filter) return;
    _filter = filter;
    load();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();

    final params = _filterParams;
    final result = await _service.fetchPage(
      page: _page + 1,
      perPage: _pageSize,
      type: params.type,
      category: params.category,
      categories: params.categories,
    );
    _items = [..._items, ...result.items];
    _page = result.currentPage;
    _hasMore = result.hasMore;

    _isLoadingMore = false;
    notifyListeners();
  }
}
