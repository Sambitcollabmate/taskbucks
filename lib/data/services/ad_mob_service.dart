import '../../core/network/api_client.dart';

/// Stand-in for the real AdMob rewarded-ad SDK integration (PROJECT.md
/// Phase 7 — "AdMob real ad unit wiring, currently placeholder"). A real
/// build shows a rewarded ad and waits for `onUserEarnedReward()`, then
/// uses the `ad_transaction_id` AdMob's SSV callback reports to the
/// backend. Until a real ad unit is registered, [simulateAdWatch] calls
/// the backend's local-dev-only `POST /v1/ads/dev-simulate`
/// (AdMobController::devSimulate, 404s outside APP_ENV=local) to produce
/// a verified `ad_transaction_id` the same way a real ad would.
///
/// // TODO(Phase 7): replace [simulateAdWatch]'s call site in
/// TasksProvider with the real AdMob rewarded-ad flow once an ad unit
/// exists — this class should stop being called from a tap and only ever
/// fire from onUserEarnedReward().
class AdMobService {
  Future<String> simulateAdWatch() {
    return ApiClient.call((dio) async {
      final response = await dio.post('/ads/dev-simulate');
      return response.data['ad_transaction_id'] as String;
    });
  }
}
