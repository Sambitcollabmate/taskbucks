import 'package:url_launcher/url_launcher.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/uuid.dart';
import '../../providers/balance_provider.dart';
import 'tasks_service.dart';

/// Replaces AdMobService for the task-completion flow. Adsterra has no
/// signed server-to-server callback like AdMob's SSV, so instead: create a
/// session (POST /ads/adsterra/session), open its task_url — with kind/id
/// tacked on so the return trip knows what to credit without depending on
/// any in-memory state surviving the time spent in the external browser —
/// in the external browser (Adsterra's Social Bar + the 15s timer live
/// there, not in-app).
///
/// [startTask] only opens the browser; it does not wait for the user to
/// come back. The actual credit happens in [completeFromReturn], called
/// from app_router's `/` redirect once `earnbucks://task-complete` lands —
/// see app_router.dart's doc comment for why routing, not an app_links
/// stream listener, is what reliably delivers that link back into the app.
class AdsterraTaskService {
  Future<void> startTask({required String kind, required int id}) async {
    final session = await ApiClient.call((dio) async {
      final response = await dio.post('/ads/adsterra/session');
      return response.data as Map<String, dynamic>;
    });

    final taskUrl = Uri.parse(session['task_url'] as String).replace(
      queryParameters: {'kind': kind, 'id': '$id'},
    );

    final launched = await launchUrl(taskUrl, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw StateError('Could not open the task page.');
    }
  }

  Future<void> completeFromReturn({
    required String sessionToken,
    required String kind,
    required int id,
  }) async {
    final adTransactionId = await ApiClient.call((dio) async {
      final response = await dio.post('/ads/adsterra/verify', data: {
        'session_token': sessionToken,
      });
      return (response.data as Map<String, dynamic>)['ad_transaction_id'] as String;
    });

    final tasksService = TasksService();
    final walletBalance = kind == 'bonus'
        ? (await tasksService.completeBonusSlot(
            id,
            adTransactionId: adTransactionId,
            idempotencyKey: generateUuidV4(),
          )).walletBalance
        : (await tasksService.completeTask(
            id,
            adTransactionId: adTransactionId,
            idempotencyKey: generateUuidV4(),
          )).walletBalance;

    // balanceProvider is the same app-wide singleton Home/Wallet read from
    // (see main.dart) — updated directly here since this runs from
    // app_router's redirect, decoupled from any particular TasksProvider
    // instance that might not even be mounted right now.
    balanceProvider.setBalance(walletBalance);
  }
}
