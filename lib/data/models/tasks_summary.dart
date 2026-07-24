import 'bonus_ad_slot.dart';
import 'task.dart';

class TasksSummary {
  final List<Task> tasks;
  final DateTime resetAt;

  /// This week's bonus ad slots (PROJECT.md 2), empty unless the user
  /// hit last week's weekly-referral-bonus threshold. Separate from
  /// [tasks] since these aren't part of the sequential daily queue.
  final List<BonusAdSlot> bonusSlots;

  const TasksSummary({
    required this.tasks,
    required this.resetAt,
    this.bonusSlots = const [],
  });

  int get completedCount =>
      tasks.where((t) => t.state == TaskState.done).length;

  int get bonusSlotsWatched =>
      bonusSlots.where((b) => b.state == BonusAdState.watched).length;

  int get bonusSlotsRemaining => bonusSlots.length - bonusSlotsWatched;

  double get earnedToday =>
      tasks.where((t) => t.state == TaskState.done).fold(0.0, (sum, t) => sum + t.rate) +
      bonusSlots
          .where((b) => b.state == BonusAdState.watched)
          .fold(0.0, (sum, b) => sum + b.rate);

  /// The single unlockable task, if today's cap hasn't been fully claimed.
  Task? get currentTask {
    for (final task in tasks) {
      if (task.state == TaskState.next) return task;
    }
    return null;
  }
}
