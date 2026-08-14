import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/user_profile.dart';
import '../data/services/billing_service.dart';
import '../data/services/profile_service.dart';
import '../data/services/razorpay_checkout_service.dart';

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
  final RazorpayCheckoutService _checkoutService;

  // Deliberately does NOT auto-load here: `GET /v1/profile` requires
  // `auth:sanctum`, and this is now constructed once at app startup, before
  // a user is authenticated (same reasoning as `NotificationsProvider`).
  // `AuthProvider` calls [load] once a session is established and [clear]
  // on logout.
  ProfileProvider({
    ProfileService? service,
    BillingService? billingService,
    RazorpayCheckoutService? checkoutService,
  })  : _service = service ?? ProfileService(),
        _billingService = billingService ?? BillingService(),
        _checkoutService = checkoutService ?? RazorpayCheckoutService();

  UserProfile? _profile;
  bool _isLoading = false;
  bool _isProcessingBilling = false;

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

  /// Creates a Razorpay order, opens Checkout against it, and verifies the
  /// resulting payment with the backend — Premium is a manual monthly
  /// repurchase (BillingController::verifyPayment extends
  /// premium_expires_at by 30 days), not an auto-renewing subscription, so
  /// there's nothing to restore/re-deliver the way Play Billing's purchase
  /// stream needed — a dropped connection just means the user retries.
  Future<void> subscribeToPremium() async {
    if (_isProcessingBilling) return;
    _isProcessingBilling = true;
    notifyListeners();

    final completer = Completer<void>();

    try {
      final order = await _billingService.createOrder();
      _checkoutService.open(
        orderId: order.orderId,
        amountPaise: order.amount,
        keyId: order.keyId,
        prefillName: _profile?.name,
        prefillEmail: _profile?.email,
        prefillContact: _profile?.phone,
        onSuccess: (paymentId, signature) async {
          try {
            await _billingService.verifyPayment(
              razorpayOrderId: order.orderId,
              razorpayPaymentId: paymentId,
              razorpaySignature: signature,
            );
            await load();
            if (!completer.isCompleted) completer.complete();
          } catch (e) {
            if (!completer.isCompleted) completer.completeError(e);
          }
        },
        onError: (message) {
          if (!completer.isCompleted) completer.completeError(StateError(message));
        },
      );
      await completer.future;
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
