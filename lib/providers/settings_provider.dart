import 'package:flutter/foundation.dart';

import '../data/models/notification_type.dart';
import '../data/models/settings_data.dart';
import '../data/services/settings_service.dart';

/// Holds Settings screen state — same role as [ProfileProvider]/
/// [WalletProvider]: widgets that watch this rebuild whenever
/// [notifyListeners] fires. Each section (Profile/Security/Payment) has
/// its own saving flag so one section's in-flight save doesn't disable
/// controls in the others.
///
/// Every mutator here lets a failed API call's [ApiException] propagate to
/// the caller (rather than swallowing it) so the screen can show the
/// server's actual validation message — only the loading flag is guaranteed
/// to reset via `finally`.
class SettingsProvider extends ChangeNotifier {
  final SettingsService _service;

  SettingsProvider({SettingsService? service}) : _service = service ?? SettingsService() {
    load();
  }

  SettingsData? _data;
  bool _isLoading = false;
  bool _isSavingProfile = false;
  bool _isUpdatingPassword = false;
  bool _isSavingUpi = false;
  bool _isTogglingTwoStep = false;
  bool _isSavingImage = false;
  NotificationCategory? _togglingPushCategory;

  SettingsData? get data => _data;
  bool get isLoading => _isLoading;
  bool get isSavingProfile => _isSavingProfile;
  bool get isUpdatingPassword => _isUpdatingPassword;
  bool get isSavingUpi => _isSavingUpi;
  bool get isTogglingTwoStep => _isTogglingTwoStep;
  bool get isSavingImage => _isSavingImage;
  NotificationCategory? get togglingPushCategory => _togglingPushCategory;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _data = await _service.fetchSettings();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProfile({required String name, required String email}) async {
    if (_data == null) return;
    _isSavingProfile = true;
    notifyListeners();

    try {
      // PATCH /v1/profile's response doesn't echo `email` back (only
      // name/mobile/tier/avatar_url) — apply it locally since no exception
      // means the server accepted it.
      final result = await _service.updateProfile(name: name, email: email);
      _data = _data!.copyWith(name: result.name, email: email, imagePath: result.avatarUrl);
    } finally {
      _isSavingProfile = false;
      notifyListeners();
    }
  }

  /// `path == null` means "remove" — there's no `DELETE /v1/profile/avatar`
  /// endpoint yet (api_requirements.md only specifies upload), so removal
  /// stays local-only for now rather than silently no-op-ing against the
  /// server.
  Future<void> updateProfileImage(String? path) async {
    if (_data == null) return;
    _isSavingImage = true;
    notifyListeners();

    try {
      if (path == null) {
        _data = _data!.copyWith(imagePath: null);
        return;
      }
      final avatarUrl = await _service.updateProfileImage(path);
      _data = _data!.copyWith(imagePath: avatarUrl);
    } finally {
      _isSavingImage = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isUpdatingPassword = true;
    notifyListeners();

    try {
      await _service.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } finally {
      _isUpdatingPassword = false;
      notifyListeners();
    }
  }

  Future<void> saveUpiId(String upiId) async {
    if (_data == null) return;
    _isSavingUpi = true;
    notifyListeners();

    try {
      await _service.updateUpiId(upiId);
      _data = _data!.copyWith(upiId: upiId);
    } finally {
      _isSavingUpi = false;
      notifyListeners();
    }
  }

  /// Caller is responsible for re-auth friction on the OFF path (PROJECT.md
  /// — turning off a security feature needs more friction than turning it
  /// on) before calling this; this just persists whichever direction was
  /// already confirmed.
  Future<void> setTwoStepEnabled(bool enabled) async {
    if (_data == null) return;
    _isTogglingTwoStep = true;
    notifyListeners();

    try {
      await _service.setTwoStepEnabled(enabled);
      _data = _data!.copyWith(twoStepEnabled: enabled);
    } finally {
      _isTogglingTwoStep = false;
      notifyListeners();
    }
  }

  /// Per-category push preference (PROJECT.md Notifications doc, Section
  /// 1.1) — a user who wants task-completion/security alerts but not
  /// promotional pushes can say so, rather than one all-or-nothing switch.
  Future<void> setPushCategoryEnabled(NotificationCategory category, bool enabled) async {
    if (_data == null) return;
    _togglingPushCategory = category;
    notifyListeners();

    try {
      await _service.setPushCategoryEnabled(category, enabled);
      switch (category) {
        case NotificationCategory.earnings:
          _data = _data!.copyWith(earningsPushEnabled: enabled);
          break;
        case NotificationCategory.account:
          _data = _data!.copyWith(accountPushEnabled: enabled);
          break;
        case NotificationCategory.promotions:
          _data = _data!.copyWith(promotionsPushEnabled: enabled);
          break;
      }
    } finally {
      _togglingPushCategory = null;
      notifyListeners();
    }
  }
}
