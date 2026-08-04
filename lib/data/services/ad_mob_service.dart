import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/network/api_client.dart';

/// Google's shared test rewarded-ad unit — always fills, safe to interact
/// with repeatedly without risking an AdMob policy strike. Swap for the
/// real ad unit ID (from the AdMob console) only once `earnbucks-api` has a
/// public HTTPS URL Google's SSV callback can actually reach — see
/// AdMobSsvClient.php / api_requirements.md §3.
const _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

/// Loads and shows a real rewarded video ad, then — once the user has
/// actually earned the reward client-side — calls the backend's
/// local-dev-only `POST /v1/ads/dev-simulate` (AdMobController::devSimulate)
/// to produce a verified `ad_transaction_id`, standing in for the real
/// AdMob SSV callback until one is wired in. Real reward-crediting must
/// always trust a server-verified impression, never the client's
/// `onUserEarnedReward` alone (api_requirements.md §3) — this two-step
/// shape (real ad, dev-verified credit) is deliberate so the task-
/// completion flow is fully testable before the backend is publicly
/// reachable.
class AdMobService {
  Future<String> watchRewardedAd() async {
    final ad = await _load();
    return _showAndAwaitReward(ad);
  }

  Future<RewardedAd> _load() {
    final completer = Completer<RewardedAd>();
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
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

  Future<String> _showAndAwaitReward(RewardedAd ad) {
    final completer = Completer<String>();
    var earnedReward = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (completer.isCompleted) return;
        if (earnedReward) {
          _confirmWithBackend().then(completer.complete).catchError(completer.completeError);
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

  Future<String> _confirmWithBackend() {
    return ApiClient.call((dio) async {
      final response = await dio.post('/ads/dev-simulate');
      return response.data['ad_transaction_id'] as String;
    });
  }
}
