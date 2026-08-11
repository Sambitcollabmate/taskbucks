import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../data/models/user_profile.dart';
import '../data/services/billing_service.dart';
import '../data/services/play_billing_service.dart';
import '../data/services/profile_service.dart';

/// Holds Profile state — one app-wide instance (see [profileProvider] below,
/// same pattern as `balanceProvider`/`notificationsProvider`) so Profile,
/// Upgrade, and Contact all read and write the same tier/name/avatar data
/// instead of each screen holding its own stale copy. Before this, each
/// screen created its own `ProfileProvider`, so subscribing to Premium on
/// the Upgrade screen never updated the Profile tab's already-mounted copy
/// underneath it.
class ProfileProvider extends ChangeNotifier {
  final ProfileService _service;
  final BillingService _billingService;
  final PlayBillingService _playBillingService;

  // Deliberately does NOT auto-load here: `GET /v1/profile` requires
  // `auth:sanctum`, and this is now constructed once at app startup, before
  // a user is authenticated (same reasoning as `NotificationsProvider`).
  // `AuthProvider` calls [load] once a session is established and [clear]
  // on logout.
  ProfileProvider({
    ProfileService? service,
    BillingService? billingService,
    PlayBillingService? playBillingService,
  })  : _service = service ?? ProfileService(),
        _billingService = billingService ?? BillingService(),
        _playBillingService = playBillingService ?? PlayBillingService() {
    // One subscription for the app's lifetime — this provider is a single
    // app-wide instance (see [profileProvider] below), never disposed, so
    // there's no matching unsubscribe.
    _playBillingService.listen(onPurchase: _onPurchase, onError: _onPurchaseError);
  }

  UserProfile? _profile;
  bool _isLoading = false;
  bool _isProcessingBilling = false;
  Completer<void>? _pendingPurchase;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isProcessingBilling => _isProcessingBilling;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _profile = await _service.fetchProfile();

    _isLoading = false;
    notifyListeners();
  }

  /// Launches Google's real purchase sheet for the Premium subscription and
  /// waits for the result. The actual productId/purchaseToken sent to the
  /// backend (BillingService.verifyPurchase) come from [_onPurchase] once
  /// Play delivers them via [PlayBillingService.listen] — asynchronously,
  /// not as this method's own return value.
  Future<void> subscribeToPremium() async {
    if (_isProcessingBilling) return;
    _isProcessingBilling = true;
    notifyListeners();

    final completer = Completer<void>();
    _pendingPurchase = completer;

    try {
      await _playBillingService.buyPremium();
      await completer.future;
    } finally {
      _pendingPurchase = null;
      _isProcessingBilling = false;
      notifyListeners();
    }
  }

  Future<void> _onPurchase(PurchaseDetails purchase) async {
    final completer = _pendingPurchase;
    try {
      await _billingService.verifyPurchase(
        productId: purchase.productID,
        purchaseToken: purchase.verificationData.serverVerificationData,
      );
      // Only acknowledge with Google once the backend has actually
      // recorded the upgrade — acknowledging first and having the backend
      // call fail would leave the user charged with no Premium granted.
      if (purchase.pendingCompletePurchase) {
        await _playBillingService.completePurchase(purchase);
      }
      await load();
      completer?.complete();
    } catch (e) {
      if (completer != null && !completer.isCompleted) {
        completer.completeError(e);
      }
    }
  }

  void _onPurchaseError(Object error) {
    final completer = _pendingPurchase;
    if (completer != null && !completer.isCompleted) {
      completer.completeError(error);
    }
  }

  /// Called by `AuthProvider` once a session is established (cold-start
  /// restore or fresh login) — redelivers any purchase Google completed
  /// but this device never got to verify/acknowledge, via [_onPurchase].
  /// A no-op if there's nothing pending. Requires auth, since
  /// [_onPurchase]'s backend call does.
  Future<void> restorePendingPurchases() {
    return _playBillingService.restorePurchases();
  }

  Future<void> cancelPremium() async {
    if (_isProcessingBilling) return;
    _isProcessingBilling = true;
    notifyListeners();

    try {
      await _billingService.cancel();
      await load();
    } finally {
      _isProcessingBilling = false;
      notifyListeners();
    }
  }

  /// Called by `AuthProvider` on logout — clears the previous user's
  /// profile from memory rather than leaving it visible (however briefly)
  /// to whoever logs into the app next on this device.
  void clear() {
    _profile = null;
    notifyListeners();
  }
}

/// One app-wide instance (same pattern as `balanceProvider` in
/// `balance_provider.dart`) so every screen reads/writes the same profile
/// state instead of each holding its own copy.
final profileProvider = ProfileProvider();
