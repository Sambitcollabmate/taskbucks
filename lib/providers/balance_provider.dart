import 'package:flutter/foundation.dart';

/// Single source of truth for the user's current balance, shared across
/// Home, Wallet, and Tasks. Before this existed, each screen's fake
/// service carried its own independent `balance` number (HomeSummary,
/// WalletSummary), so completing a task on Tasks never showed up on Home
/// or Wallet and the three screens could silently drift out of sync. A
/// real backend would have exactly one balance column behind every
/// endpoint; this is the fake-data equivalent of that until Phase 7.
class BalanceProvider extends ChangeNotifier {
  double _balance;

  BalanceProvider({double initialBalance = 1575}) : _balance = initialBalance;

  double get balance => _balance;

  void credit(double amount) {
    _balance += amount;
    notifyListeners();
  }

  /// Applies the real `balance` figure from `GET /v1/wallet` or
  /// `GET /v1/home` (api_requirements.md) — called by
  /// `WalletProvider`/`HomeProvider` after each fetch so this stays the
  /// server's authoritative number instead of only ever being
  /// locally-incremented via [credit].
  void setBalance(double balance) {
    if (_balance == balance) return;
    _balance = balance;
    notifyListeners();
  }
}

/// One app-wide instance (PROJECT.md pattern also used for `authProvider`
/// in `core/router/app_router.dart`) so Home/Wallet/Tasks all read and
/// write the same balance rather than each holding their own copy.
final balanceProvider = BalanceProvider();
