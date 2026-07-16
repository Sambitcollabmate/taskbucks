import '../models/task.dart';
import '../models/tasks_summary.dart';

/// Fake data source for the Tasks screen. Returns the same shape the real
/// Laravel endpoint will return once it exists (see PROJECT.md Section 4/7).
class TasksService {
  Future<TasksSummary> fetchTasks() async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Matches Home's tasksCompletedToday (14) / dailyTaskLimit (25):
    // 14 done, 1 next (unlockable now), 10 locked.
    const doneCount = 14;
    const totalCount = 25;

    final tasks = List.generate(totalCount, (i) {
      final id = i + 1;
      final TaskState state;
      if (id <= doneCount) {
        state = TaskState.done;
      } else if (id == doneCount + 1) {
        state = TaskState.next;
      } else {
        state = TaskState.locked;
      }
      return Task(id: id, state: state, rate: 2.0);
    });

    final now = DateTime.now();
    final resetAt = DateTime(now.year, now.month, now.day + 1);

    return TasksSummary(tasks: tasks, resetAt: resetAt);
  }
}
