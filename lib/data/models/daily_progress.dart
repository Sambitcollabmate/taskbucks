/// One day's task progress within the current week streak.
class DailyProgress {
  final DateTime date;
  final int completed;
  final int limit;

  const DailyProgress({
    required this.date,
    required this.completed,
    required this.limit,
  });

  bool get isFuture {
    final today = DateTime.now();
    final justDate = DateTime(date.year, date.month, date.day);
    final justToday = DateTime(today.year, today.month, today.day);
    return justDate.isAfter(justToday);
  }

  bool get isToday {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  double get ratio => limit == 0 ? 0 : (completed / limit).clamp(0.0, 1.0);

  bool get isComplete => completed >= limit && limit > 0;
}
