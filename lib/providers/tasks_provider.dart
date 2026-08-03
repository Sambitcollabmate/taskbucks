import 'package:flutter/foundation.dart';

import '../core/utils/uuid.dart';
import '../data/models/tasks_summary.dart';
import '../data/services/ad_mob_service.dart';
import '../data/services/tasks_service.dart';
import 'balance_provider.dart';

/// Holds Tasks screen state. Widgets that `watch` this rebuild whenever
/// [notifyListeners] fires (see HomeProvider for the same pattern).
class TasksProvider extends ChangeNotifier {
  final TasksService _service;
  final AdMobService _adMobService;
  final BalanceProvider _balanceProvider;

  /// [_balanceProvider] is updated with the server's authoritative
  /// `wallet_balance` after each completion (Home/Wallet read from the
  /// same instance), rather than locally incremented, now that a real
  /// backend exists. Kept as an explicit initializer (not
  /// `this._balanceProvider`) because a private initializing formal would
  /// force call sites in other files to pass a private-named argument,
  /// which isn't accessible outside this library.
  TasksProvider({
    TasksService? service,
    AdMobService? adMobService,
    required BalanceProvider balanceProvider,
  }) : _service = service ?? TasksService(),
       _adMobService = adMobService ?? AdMobService(),
       // ignore: prefer_initializing_formals
       _balanceProvider = balanceProvider {
    load();
  }

  TasksSummary? _summary;
  bool _isLoading = false;
  bool _isCompletingTask = false;
  int? _completingBonusSlotId;

  TasksSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  bool get isCompletingTask => _isCompletingTask;
  int? get completingBonusSlotId => _completingBonusSlotId;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _summary = await _service.fetchTasks();

    _isLoading = false;
    notifyListeners();
  }

  /// Watches the current "next" task and credits it. Real reward-crediting
  /// only ever trusts a verified AdMob impression server-side — see
  /// [AdMobService] for why this currently goes through the local-dev
  /// simulate endpoint rather than a real rewarded ad.
  //
  // LEGAL-REVIEW / TODO(Phase 7): once real AdMob is wired in, this must
  // only fire from onUserEarnedReward(), never directly on tap.
  Future<void> completeCurrentTask() async {
    final summary = _summary;
    final currentTask = summary?.currentTask;
    if (summary == null || currentTask == null || _isCompletingTask) return;

    _isCompletingTask = true;
    notifyListeners();

    try {
      final adTransactionId = await _adMobService.simulateAdWatch();
      final result = await _service.completeTask(
        currentTask.id,
        adTransactionId: adTransactionId,
        idempotencyKey: generateUuidV4(),
      );
      _summary = TasksSummary(
        tasks: result.tasks,
        resetAt: summary.resetAt,
        bonusSlots: summary.bonusSlots,
      );
      _balanceProvider.setBalance(result.walletBalance);
    } finally {
      _isCompletingTask = false;
      notifyListeners();
    }
  }

  /// Watches a bonus ad slot and credits it. Unlike [completeCurrentTask],
  /// any available slot can be tapped: bonus slots aren't a sequential
  /// queue (PROJECT.md 2).
  //
  // LEGAL-REVIEW / TODO(Phase 7): same as completeCurrentTask, goes
  // through the dev-simulate placeholder until real AdMob is wired in.
  Future<void> completeBonusSlot(int id) async {
    final summary = _summary;
    if (summary == null || _completingBonusSlotId != null) return;

    _completingBonusSlotId = id;
    notifyListeners();

    try {
      final adTransactionId = await _adMobService.simulateAdWatch();
      final result = await _service.completeBonusSlot(
        id,
        adTransactionId: adTransactionId,
        idempotencyKey: generateUuidV4(),
      );
      _summary = TasksSummary(
        tasks: summary.tasks,
        resetAt: summary.resetAt,
        bonusSlots: result.bonusSlots,
      );
      _balanceProvider.setBalance(result.walletBalance);
    } finally {
      _completingBonusSlotId = null;
      notifyListeners();
    }
  }
}
