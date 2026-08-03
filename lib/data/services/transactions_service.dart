import '../../core/network/api_client.dart';
import '../models/transaction.dart';
import 'wallet_service.dart';

class TransactionsPage {
  final List<Transaction> items;
  final int currentPage;
  final int lastPage;

  const TransactionsPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasMore => currentPage < lastPage;
}

/// Real `GET /v1/transactions` call (api_requirements.md §5) —
/// server-side paginated/filtered, replacing the old fake full-history +
/// client-side slice.
class TransactionsService {
  Future<TransactionsPage> fetchPage({
    required int page,
    int perPage = 15,
    String? type,
    String? category,
    List<String>? categories,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.get('/transactions', queryParameters: {
        'page': page,
        'per_page': perPage,
        if (type != null) 'type': type,
        if (category != null) 'category': category,
        if (categories != null) 'categories[]': categories,
      });
      final json = response.data as Map<String, dynamic>;
      final meta = json['meta'] as Map<String, dynamic>;
      return TransactionsPage(
        items: (json['data'] as List)
            .cast<Map<String, dynamic>>()
            .map(transactionFromJson)
            .toList(),
        currentPage: meta['current_page'] as int,
        lastPage: meta['last_page'] as int,
      );
    });
  }
}
