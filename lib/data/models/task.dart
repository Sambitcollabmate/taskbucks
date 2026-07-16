/// Where a single task sits relative to today's progress. Tasks unlock in
/// order — see PROJECT.md 2 (free tier: 25 tasks/day) and the roadmap note
/// that users can't skip ahead out of order.
enum TaskState { done, next, locked }

class Task {
  final int id;
  final TaskState state;
  final double rate;

  const Task({required this.id, required this.state, required this.rate});
}
