import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/uuid.dart';

/// Loads and shows a real rewarded video ad, then confirms the reward via
/// AdMob's real Server-Side Verification (SSV) — never the client-side
/// `onUserEarnedReward` signal alone (api_requirements.md §3), since a
/// modified client could fire that without ever showing an ad.
///
/// AdMob never hands the client its own `transaction_id`, so a fresh UUID
/// is set as `customData` on the ad request before showing it; once
/// AdMob's callback (AdMobController::callback) lands — asynchronously,
/// not synchronously with the ad closing — GET /ads/verification-status
/// (polled below) finds the resulting row by that same UUID and returns
/// the real `ad_transaction_id` for /tasks/{id}/complete to consume.
class AdMobService {
  Future<String> watchRewardedAd() async {
    final correlationId = generateUuidV4();
    final ad = await _load();
    await ad.setServerSideOptions(ServerSideVerificationOptions(customData: correlationId));
    return _showAndAwaitReward(ad, correlationId);
  }

  Future<RewardedAd> _load() {
    final completer = Completer<RewardedAd>();
    RewardedAd.load(
      adUnitId: AppConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: completer.complete,
        onAdFailedToLoad: (error) {
          completer.completeError(StateError('Ad failed to load: ${error.message}'));
        },
      ),
    );
    return completer.future;
  }

  Future<String> _showAndAwaitReward(RewardedAd ad, String correlationId) {
    final completer = Completer<String>();
    var earnedReward = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (completer.isCompleted) return;
        if (earnedReward) {
          _awaitVerification(correlationId).then(completer.complete).catchError(completer.completeError);
        } else {
          completer.completeError(StateError('Ad dismissed before reward was earned.'));
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (!completer.isCompleted) {
          completer.completeError(StateError('Ad failed to show: ${error.message}'));
        }
      },
    );

    ad.show(onUserEarnedReward: (ad, reward) => earnedReward = true);

    return completer.future;
  }

  /// AdMob's SSV callback lands asynchronously — typically within a couple
  /// of seconds of the ad closing, but never synchronously with it — so
  /// this polls rather than assuming a single check will find it.
  Future<String> _awaitVerification(String correlationId) async {
    const pollInterval = Duration(seconds: 2);
    final deadline = DateTime.now().add(const Duration(seconds: 20));

    while (DateTime.now().isBefore(deadline)) {
      final status = await ApiClient.call((dio) async {
        final response = await dio.get(
          '/ads/verification-status',
          queryParameters: {'correlation_id': correlationId},
        );
        return response.data as Map<String, dynamic>;
      });

      if (status['status'] == 'verified') {
        return status['ad_transaction_id'] as String;
      }

      await Future.delayed(pollInterval);
    }

    throw StateError(
      'Still verifying your ad with AdMob — please try again in a moment.',
    );
  }
}
