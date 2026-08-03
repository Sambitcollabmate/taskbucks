import 'package:flutter/foundation.dart';

import '../data/models/user_profile.dart';
import '../data/services/billing_service.dart';
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

  // Deliberately does NOT auto-load here: `GET /v1/profile` requires
  // `auth:sanctum`, and this is now constructed once at app startup, before
  // a user is authenticated (same reasoning as `NotificationsProvider`).
  // `AuthProvider` calls [load] once a session is established and [clear]
  // on logout.
  ProfileProvider({ProfileService? service, BillingService? billingService})
      : _service = service ?? ProfileService(),
        _billingService = billingService ?? BillingService();

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

  /// // TODO(Phase 7): real Google Play Billing purchase flow — see
  /// [BillingService.verifyPurchase]'s doc comment for why placeholder
  /// values are used here.
  Future<void> subscribeToPremium() async {
    if (_isProcessingBilling) return;
    _isProcessingBilling = true;
    notifyListeners();

    try {
      await _billingService.verifyPurchase(
        productId: 'premium_monthly',
        purchaseToken: 'dev-placeholder-token',
      );
      await load();
    } finally {
      _isProcessingBilling = false;
      notifyListeners();
    }
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
