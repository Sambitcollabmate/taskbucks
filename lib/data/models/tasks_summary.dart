import 'task.dart';

class TasksSummary {
  final List<Task> tasks;
  final DateTime resetAt;

  const TasksSummary({required this.tasks, required this.resetAt});

  int get completedCount =>
      tasks.where((t) => t.state == TaskState.done).length;

  double get earnedToday => tasks
      .where((t) => t.state == TaskState.done)
      .fold(0.0, (sum, t) => sum + t.rate);

  /// The single unlockable task, if today's cap hasn't been fully claimed.
  Task? get currentTask {
    for (final task in tasks) {
      if (task.state == TaskState.next) return task;
    }
    return null;
  }
}
