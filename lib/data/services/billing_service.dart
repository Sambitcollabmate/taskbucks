import '../../core/network/api_client.dart';

/// Real `POST /v1/billing/verify-purchase`/`POST /v1/billing/cancel` calls
/// (api_requirements.md §11). `verifyPurchase`'s `productId`/`purchaseToken`
/// come from a real Google Play Billing purchase — see
/// ProfileProvider.subscribeToPremium/_onPurchase and PlayBillingService.
/// Requires a real Play Console app listing + subscription product +
/// `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` on the backend to actually succeed;
/// until those exist, the backend's `GooglePlayBillingClient` only accepts
/// this in `APP_ENV=local` (its dev bypass), so a real purchase attempt
/// against production fails until that setup is done.
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
