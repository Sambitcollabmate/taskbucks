import '../models/daily_progress.dart';
import '../models/home_summary.dart';

/// Fake data source for the Home screen. Returns the same shape the real
/// Laravel endpoint will return once it exists (see PROJECT.md Section 4/7).
class HomeService {
  Future<HomeSummary> fetchHomeSummary() async {
    await Future.delayed(const Duration(milliseconds: 400));

    const dailyLimit = 25;
    const tasksCompletedToday = 14;

    return HomeSummary(
      userName: 'Sambit',
      tasksCompletedToday: tasksCompletedToday,
      dailyTaskLimit: dailyLimit,
      isPremium: false,
      // Scaled to the new ₹100/task, ₹125/referral rates (PROJECT.md 2,
      // 2026-07-23 update): same underlying weekly volume as before (23
      // referral conversions, 64 completed tasks), just priced at the new
      // rates instead of the old ₹15/₹2.
      weeklyLeaders: const [
        LeaderboardEntry(
          rank: 1,
          name: 'Ayesha K.',
          amount: 2875,
          category: LeaderboardCategory.topReferrer,
        ),
        LeaderboardEntry(
          rank: 1,
          name: 'Vikram S.',
          amount: 6400,
          category: LeaderboardCategory.topAdWatcher,
        ),
      ],
      weekProgress: _buildWeekProgress(
        dailyLimit: dailyLimit,
        tasksCompletedToday: tasksCompletedToday,
      ),
    );
  }

  List<DailyProgress> _buildWeekProgress({
    required int dailyLimit,
    required int tasksCompletedToday,
  }) {
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));

    // Sample completed-task counts for Mon..Sun of the current week —
    // a mix of a full day, partial days, and a missed day, so all three
    // streak colors show up in the fake data.
    const sampleCompleted = [25, 18, 0, 22, 25, 0, 0];

    return List.generate(7, (i) {
      final date = DateTime(monday.year, monday.month, monday.day + i);
      final isToday =
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final isFuture = DateTime(
        date.year,
        date.month,
        date.day,
      ).isAfter(DateTime(today.year, today.month, today.day));

      final completed = isToday
          ? tasksCompletedToday
          : (isFuture ? 0 : sampleCompleted[i]);

      return DailyProgress(date: date, completed: completed, limit: dailyLimit);
    });
  }
}
