import '../../core/network/api_client.dart';

/// Real `POST /v1/billing/verify-purchase`/`POST /v1/billing/cancel` calls
/// (api_requirements.md §11).
///
/// // TODO(Phase 7): [verifyPurchase]'s `productId`/`purchaseToken` should
/// come from a real Google Play Billing purchase flow (no Play Console app
/// listing exists yet — PROJECT.md Phase 7). Until then this is called
/// with placeholder values; the backend's own `GooglePlayBillingClient` has
/// a matching local-dev bypass that treats any token as valid in
/// `APP_ENV=local`, so this still exercises the real referral-commission
/// and tier-upgrade logic end to end.
class BillingService {
  Future<void> verifyPurchase({required String productId, required String purchaseToken}) {
    return ApiClient.call((dio) => dio.post('/billing/verify-purchase', data: {
          'product_id': productId,
          'purchase_token': purchaseToken,
        }));
  }

  Future<void> cancel() {
    return ApiClient.call((dio) => dio.post('/billing/cancel'));
  }
}
