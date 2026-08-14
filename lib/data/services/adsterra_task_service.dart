import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

import '../../core/network/api_client.dart';
import '../../core/services/deep_link_listener.dart';

/// Replaces AdMobService for the task-completion flow. Adsterra has no
/// signed server-to-server callback like AdMob's SSV, so instead: create a
/// session (POST /ads/adsterra/session), open its task_url in the external
/// browser (Adsterra's Social Bar + the 15s timer live there, not in-app),
/// wait for the page's deep link back once the timer finishes, then verify
/// (POST /ads/adsterra/verify) — which enforces the real, server-side
/// minimum-duration check — to get the ad_transaction_id
/// TaskController::complete/BonusSlotController::complete already know how
/// to consume, same as AdMobService.watchRewardedAd() used to return.
class AdsterraTaskService {
  Future<String> watchTask() async {
    final session = await ApiClient.call((dio) async {
      final response = await dio.post('/ads/adsterra/session');
      return response.data as Map<String, dynamic>;
    });

    final sessionToken = session['session_token'] as String;
    final taskUrl = Uri.parse(session['task_url'] as String);

    final launched = await launchUrl(taskUrl, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw StateError('Could not open the task page.');
    }

    final returned = await _awaitReturn(sessionToken);

    return ApiClient.call((dio) async {
      final response = await dio.post('/ads/adsterra/verify', data: {
        'session_token': returned,
      });
      return (response.data as Map<String, dynamic>)['ad_transaction_id'] as String;
    });
  }

  /// Waits for the `earnbucks://task-complete?session_token=...` deep link
  /// this exact session started, ignoring a mismatched token (e.g. a stale
  /// link from a previous, abandoned task attempt).
  Future<String> _awaitReturn(String sessionToken) async {
    while (true) {
      final Uri uri;
      try {
        uri = await DeepLinkListener.instance.waitForHost('task-complete');
      } on TimeoutException {
        throw StateError('Timed out waiting for you to finish the task page.');
      }

      final returnedToken = uri.queryParameters['session_token'];
      if (returnedToken == sessionToken) {
        return returnedToken!;
      }
    }
  }
}
