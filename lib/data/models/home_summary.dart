  import 'daily_progress.dart';

/// Which weekly leaderboard a [LeaderboardEntry] belongs to.
enum LeaderboardCategory { topReferrer, topAdWatcher }

class LeaderboardEntry {
  final int rank;
  final String name;
  final double amount;
  final LeaderboardCategory category;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.amount,
    required this.category,
  });
}

class HomeSummary {
  final String userName;
  final int tasksCompletedToday;
  final int dailyTaskLimit;
  final bool isPremium;
  final List<LeaderboardEntry> weeklyLeaders;
  final List<DailyProgress> weekProgress;

  const HomeSummary({
    required this.userName,
    required this.tasksCompletedToday,
    required this.dailyTaskLimit,
    required this.isPremium,
    required this.weeklyLeaders,
    required this.weekProgress,
  });
}
