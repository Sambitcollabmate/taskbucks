import 'package:flutter/foundation.dart';

import '../data/models/tasks_summary.dart';
import '../data/services/adsterra_task_service.dart';
import '../data/services/tasks_service.dart';

/// Holds Tasks screen state. Widgets that `watch` this rebuild whenever
/// [notifyListeners] fires (see HomeProvider for the same pattern).
///
/// Wallet balance is no longer updated from here: task/bonus-slot credit
/// now happens out of band via AdsterraTaskService.completeFromReturn
/// (called from app_router's `/` redirect once the user returns from the
/// Adsterra task page), which updates the app-wide `balanceProvider`
/// singleton directly since this TasksProvider instance may not even be
/// mounted at that point.
class TasksProvider extends ChangeNotifier {
  final TasksService _service;
  final AdsterraTaskService _adsterraService;

  TasksProvider({
    TasksService? service,
    AdsterraTaskService? adsterraService,
  }) : _service = service ?? TasksService(),
       _adsterraService = adsterraService ?? AdsterraTaskService() {
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

  /// Opens the Adsterra task page for the current "next" task. Only starts
  /// the browser session — the actual credit happens later, out of band,
  /// once the user returns via the `earnbucks://task-complete` deep link
  /// (app_router's `/` redirect calls
  /// [AdsterraTaskService.completeFromReturn] and this screen's next
  /// [load] picks up the result), since the app may be backgrounded for
  /// the whole 15s+ the user spends on the task page in between.
  Future<void> completeCurrentTask() async {
    final currentTask = _summary?.currentTask;
    if (_summary == null || currentTask == null || _isCompletingTask) return;

    _isCompletingTask = true;
    notifyListeners();

    try {
      await _adsterraService.startTask(kind: 'task', id: currentTask.id);
    } finally {
      _isCompletingTask = false;
      notifyListeners();
    }
  }

  /// Opens the Adsterra task page for bonus ad slot [id]. Unlike
  /// [completeCurrentTask], any available slot can be tapped: bonus slots
  /// aren't a sequential queue (PROJECT.md 2). Same out-of-band completion
  /// as above.
  Future<void> completeBonusSlot(int id) async {
    if (_summary == null || _completingBonusSlotId != null) return;

    _completingBonusSlotId = id;
    notifyListeners();

    try {
      await _adsterraService.startTask(kind: 'bonus', id: id);
    } finally {
      _completingBonusSlotId = null;
      notifyListeners();
    }
  }
}
