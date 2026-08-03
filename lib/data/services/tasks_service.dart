import '../../core/network/api_client.dart';
import '../models/bonus_ad_slot.dart';
import '../models/task.dart';
import '../models/tasks_summary.dart';

class TaskCompletionResult {
  final List<Task> tasks;
  final double walletBalance;

  const TaskCompletionResult({required this.tasks, required this.walletBalance});
}

class BonusSlotCompletionResult {
  final List<BonusAdSlot> bonusSlots;
  final double walletBalance;

  const BonusSlotCompletionResult({required this.bonusSlots, required this.walletBalance});
}

/// Real `GET /v1/tasks`/`POST /v1/tasks/{id}/complete`/
/// `POST /v1/bonus-slots/{id}/complete` calls (api_requirements.md §3).
class TasksService {
  Future<TasksSummary> fetchTasks() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/tasks');
      final json = response.data as Map<String, dynamic>;
      return TasksSummary(
        tasks: (json['tasks'] as List).cast<Map<String, dynamic>>().map(_taskFromJson).toList(),
        resetAt: DateTime.parse(json['reset_at'] as String),
        bonusSlots: (json['bonus_slots'] as List)
            .cast<Map<String, dynamic>>()
            .map(_bonusSlotFromJson)
            .toList(),
      );
    });
  }

  Future<TaskCompletionResult> completeTask(
    int id, {
    required String adTransactionId,
    required String idempotencyKey,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/tasks/$id/complete', data: {
        'ad_transaction_id': adTransactionId,
        'idempotency_key': idempotencyKey,
      });
      final json = response.data as Map<String, dynamic>;
      return TaskCompletionResult(
        tasks: (json['tasks'] as List).cast<Map<String, dynamic>>().map(_taskFromJson).toList(),
        walletBalance: double.parse(json['wallet_balance'] as String),
      );
    });
  }

  Future<BonusSlotCompletionResult> completeBonusSlot(
    int id, {
    required String adTransactionId,
    required String idempotencyKey,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/bonus-slots/$id/complete', data: {
        'ad_transaction_id': adTransactionId,
        'idempotency_key': idempotencyKey,
      });
      final json = response.data as Map<String, dynamic>;
      return BonusSlotCompletionResult(
        bonusSlots: (json['bonus_slots'] as List)
            .cast<Map<String, dynamic>>()
            .map(_bonusSlotFromJson)
            .toList(),
        walletBalance: double.parse(json['wallet_balance'] as String),
      );
    });
  }

  Task _taskFromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      state: switch (json['state'] as String) {
        'done' => TaskState.done,
        'next' => TaskState.next,
        _ => TaskState.locked,
      },
      rate: double.parse(json['rate'] as String),
    );
  }

  BonusAdSlot _bonusSlotFromJson(Map<String, dynamic> json) {
    return BonusAdSlot(
      id: json['id'] as int,
      state: json['state'] == 'watched' ? BonusAdState.watched : BonusAdState.available,
      rate: double.parse(json['rate'] as String),
    );
  }
}
