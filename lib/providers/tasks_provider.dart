import 'package:flutter/foundation.dart';

import '../data/models/bonus_ad_slot.dart';
import '../data/models/task.dart';
import '../data/models/tasks_summary.dart';
import '../data/services/tasks_service.dart';
import 'balance_provider.dart';

/// Holds Tasks screen state. Widgets that `watch` this rebuild whenever
/// [notifyListeners] fires (see HomeProvider for the same pattern).
class TasksProvider extends ChangeNotifier {
  final TasksService _service;
  final BalanceProvider _balanceProvider;

  /// [_balanceProvider] credits the shared balance (Home/Wallet read from
  /// the same instance) whenever a task or bonus ad completes here, so
  /// completing one on Tasks actually shows up on Home/Wallet instead of
  /// only bumping this screen's own "earned today" figure. Kept as an
  /// explicit initializer (not `this._balanceProvider`) because a private
  /// initializing formal would force call sites in other files to pass a
  /// private-named argument, which isn't accessible outside this library.
  TasksProvider({TasksService? service, required BalanceProvider balanceProvider})
    : _service = service ?? TasksService(),
      // ignore: prefer_initializing_formals
      _balanceProvider = balanceProvider {
    load();
  }

  TasksSummary? _summary;
  bool _isLoading = false;

  TasksSummary? get summary => _summary;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _summary = await _service.fetchTasks();

    _isLoading = false;
    notifyListeners();
  }

  /// Marks the current "next" task watched and unlocks the following one.
  // LEGAL-REVIEW / TODO(Phase 7): this simulates the reward locally. Once
  // AdMob is wired in, this must only run from onUserEarnedReward(), never
  // on tap (PROJECT.md Section 2) — replace this call site accordingly.
  void completeCurrentTask() {
    final summary = _summary;
    if (summary == null) return;

    final currentIndex = summary.tasks.indexWhere(
      (t) => t.state == TaskState.next,
    );
    if (currentIndex == -1) return;

    final updated = [...summary.tasks];
    updated[currentIndex] = Task(
      id: updated[currentIndex].id,
      state: TaskState.done,
      rate: updated[currentIndex].rate,
    );

    final nextLockedIndex = updated.indexWhere(
      (t) => t.state == TaskState.locked,
    );
    if (nextLockedIndex != -1) {
      updated[nextLockedIndex] = Task(
        id: updated[nextLockedIndex].id,
        state: TaskState.next,
        rate: updated[nextLockedIndex].rate,
      );
    }

    _summary = TasksSummary(
      tasks: updated,
      resetAt: summary.resetAt,
      bonusSlots: summary.bonusSlots,
    );
    _balanceProvider.credit(updated[currentIndex].rate);
    notifyListeners();
  }

  /// Marks a bonus ad slot watched. Unlike [completeCurrentTask], any
  /// available slot can be tapped: bonus slots aren't a sequential queue
  /// (PROJECT.md 2).
  // LEGAL-REVIEW / TODO(Phase 7): same as completeCurrentTask, simulates
  // the reward locally; must only run from onUserEarnedReward() once AdMob
  // is wired in.
  void completeBonusSlot(int id) {
    final summary = _summary;
    if (summary == null) return;

    final index = summary.bonusSlots.indexWhere((b) => b.id == id);
    if (index == -1 || summary.bonusSlots[index].state == BonusAdState.watched) {
      return;
    }

    final updated = [...summary.bonusSlots];
    updated[index] = BonusAdSlot(
      id: updated[index].id,
      state: BonusAdState.watched,
      rate: updated[index].rate,
    );

    _summary = TasksSummary(
      tasks: summary.tasks,
      resetAt: summary.resetAt,
      bonusSlots: updated,
    );
    _balanceProvider.credit(updated[index].rate);
    notifyListeners();
  }
}
