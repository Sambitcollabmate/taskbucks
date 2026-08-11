import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

/// Real Google Play Billing purchase flow for the Premium subscription
/// (api_requirements.md §11). `premiumProductId` must exist as an active
/// subscription in Play Console with this exact ID — nothing to purchase
/// otherwise (see [buyPremium]'s "not available yet" error).
///
/// Play delivers purchase results asynchronously via [purchaseStream], not
/// as [buyPremium]'s return value — a purchase can complete after the app
/// briefly loses foreground (e.g. while the user is in Google's payment
/// sheet) — so callers subscribe to the stream once via [listen] rather
/// than awaiting [buyPremium] directly.
class PlayBillingService {
  static const String premiumProductId = 'premium_monthly';

  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  void listen({
    required void Function(PurchaseDetails purchase) onPurchase,
    required void Function(Object error) onError,
  }) {
    _subscription = _iap.purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        switch (purchase.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            onPurchase(purchase);
          case PurchaseStatus.error:
            onError(StateError(purchase.error?.message ?? 'Purchase failed.'));
          case PurchaseStatus.canceled:
            onError(StateError('Purchase cancelled.'));
          case PurchaseStatus.pending:
            break;
        }
      }
    }, onError: onError);
  }

  void dispose() {
    _subscription?.cancel();
  }

  /// Launches Google's purchase sheet for [premiumProductId]. Returns once
  /// the sheet is launched, not once the purchase completes — the result
  /// arrives later via the [listen] callbacks.
  Future<void> buyPremium() async {
    if (!await _iap.isAvailable()) {
      throw StateError('Google Play Billing is not available on this device.');
    }

    final response = await _iap.queryProductDetails({premiumProductId});
    if (response.error != null) {
      throw StateError('Could not load subscription details: ${response.error!.message}');
    }
    if (response.productDetails.isEmpty) {
      throw StateError('Premium subscription is not available yet.');
    }

    final purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Acknowledges the purchase with Google — required within 3 days or
  /// Play auto-refunds it. Must only be called after the backend has
  /// confirmed the purchase (BillingService.verifyPurchase), not before.
  Future<void> completePurchase(PurchaseDetails purchase) {
    return _iap.completePurchase(purchase);
  }

  /// Safety net for a purchase that completed with Google but never
  /// finished being verified/acknowledged on this device — e.g. the app
  /// was killed right after the purchase sheet closed, before
  /// [ProfileProvider._onPurchase] could call the backend. Redelivers any
  /// such purchase via [listen]'s stream, which handles it exactly like a
  /// fresh purchase.
  Future<void> restorePurchases() {
    return _iap.restorePurchases();
  }
}
