import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/transactions_provider.dart';
import '../../shared/widgets/txn_row.dart';
import 'widgets/transaction_filter_tabs.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionsProvider(),
      child: const _TransactionsScreenBody(),
    );
  }
}

class _TransactionsScreenBody extends StatefulWidget {
  const _TransactionsScreenBody();

  @override
  State<_TransactionsScreenBody> createState() => _TransactionsScreenBodyState();
}

class _TransactionsScreenBodyState extends State<_TransactionsScreenBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Fires "Load more" ~200px before the end of the scroll extent, instead
  // of a tap target, so a short filtered list (fits on one screen) never
  // has to render a stray button/space beneath it.
  void _onScroll() {
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }
    context.read<TransactionsProvider>().loadMore();
  }

  // A short page (e.g. the Withdrawals filter, or the very first page)
  // can fit entirely within the viewport, leaving nothing to scroll — so
  // the listener above never fires and loadMore() would never get called.
  // Called after every build (see the post-frame callback below), this
  // keeps eagerly loading the next page whenever there's still room below
  // the last row, until either the viewport is full or data runs out.
  void _maybeLoadMoreToFillScreen() {
    if (!mounted || !_scrollController.hasClients) return;
    final provider = context.read<TransactionsProvider>();
    if (!provider.hasMore) return;
    if (_scrollController.position.maxScrollExtent > 0) return;
    provider.loadMore();
  }

  void _onFilterSelected(TransactionFilter filter) {
    context.read<TransactionsProvider>().setFilter(filter);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Transactions'),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<TransactionsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.visibleTransactions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final transactions = provider.visibleTransactions;

            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _maybeLoadMoreToFillScreen(),
            );

            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  TransactionFilterTabs(
                    selected: provider.filter,
                    onSelected: _onFilterSelected,
                  ),
                  const SizedBox(height: 20),
                  if (transactions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No transactions yet',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (final txn in transactions) ...[
                            TxnRow(transaction: txn),
                            if (txn != transactions.last) const Divider(height: 24),
                          ],
                        ],
                      ),
                    ),
                  if (provider.hasMore)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
