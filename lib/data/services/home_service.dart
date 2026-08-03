import '../../core/network/api_client.dart';
import '../models/daily_progress.dart';
import '../models/home_summary.dart';

/// Real `GET /v1/home` call (api_requirements.md §2). `balance` is returned
/// separately from [HomeSummary] since it belongs to the shared
/// `BalanceProvider`, same as `WalletService` — see that class's doc
/// comment.
class HomeService {
  Future<({HomeSummary summary, double balance})> fetchHomeSummary() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/home');
      final json = response.data as Map<String, dynamic>;

      return (
        balance: double.parse(json['balance'] as String),
        summary: HomeSummary(
          userName: json['user_name'] as String,
          tasksCompletedToday: json['tasks_completed_today'] as int,
          dailyTaskLimit: json['daily_task_limit'] as int,
          isPremium: json['is_premium'] as bool,
          weeklyLeaders: (json['weekly_leaders'] as List)
              .cast<Map<String, dynamic>>()
              .map(_leaderboardEntryFromJson)
              .toList(),
          weekProgress: (json['week_progress'] as List)
              .cast<Map<String, dynamic>>()
              .map(_dailyProgressFromJson)
              .toList(),
        ),
      );
    });
  }

  LeaderboardEntry _leaderboardEntryFromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      name: json['name'] as String,
      amount: double.parse(json['amount'] as String),
      category: json['category'] == 'top_referrer'
          ? LeaderboardCategory.topReferrer
          : LeaderboardCategory.topAdWatcher,
    );
  }

  DailyProgress _dailyProgressFromJson(Map<String, dynamic> json) {
    return DailyProgress(
      date: DateTime.parse(json['date'] as String),
      completed: json['completed'] as int,
      limit: json['limit'] as int,
    );
  }
}
