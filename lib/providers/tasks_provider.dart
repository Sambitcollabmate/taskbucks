import 'package:flutter/foundation.dart';

import '../data/models/task.dart';
import '../data/models/tasks_summary.dart';
import '../data/services/tasks_service.dart';

/// Holds Tasks screen state. Widgets that `watch` this rebuild whenever
/// [notifyListeners] fires (see HomeProvider for the same pattern).
class TasksProvider extends ChangeNotifier {
  final TasksService _service;

  TasksProvider({TasksService? service})
    : _service = service ?? TasksService() {
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

    _summary = TasksSummary(tasks: updated, resetAt: summary.resetAt);
    notifyListeners();
  }
}
