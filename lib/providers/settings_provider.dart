import 'package:flutter/foundation.dart';

import '../data/models/settings_data.dart';
import '../data/services/settings_service.dart';

/// Holds Settings screen state — same role as [ProfileProvider]/
/// [WalletProvider]: widgets that watch this rebuild whenever
/// [notifyListeners] fires. Each section (Profile/Security/Payment) has
/// its own saving flag so one section's in-flight save doesn't disable
/// controls in the others.
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

  SettingsData? get data => _data;
  bool get isLoading => _isLoading;
  bool get isSavingProfile => _isSavingProfile;
  bool get isUpdatingPassword => _isUpdatingPassword;
  bool get isSavingUpi => _isSavingUpi;
  bool get isTogglingTwoStep => _isTogglingTwoStep;

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

    // TODO: replace with a real "update profile" API call once the
    // Laravel backend exists (PROJECT.md 4).
    await _service.updateProfile(name: name, email: email);
    _data = _data!.copyWith(name: name, email: email);

    _isSavingProfile = false;
    notifyListeners();
  }

  Future<void> updatePassword(String newPassword) async {
    _isUpdatingPassword = true;
    notifyListeners();

    // TODO: replace with a real "update password" API call once the
    // Laravel backend exists (PROJECT.md 4).
    await _service.updatePassword(newPassword: newPassword);

    _isUpdatingPassword = false;
    notifyListeners();
  }

  Future<void> saveUpiId(String upiId) async {
    if (_data == null) return;
    _isSavingUpi = true;
    notifyListeners();

    // TODO: replace with a real "update UPI ID" API call once the Laravel
    // backend exists (PROJECT.md 4).
    await _service.updateUpiId(upiId);
    _data = _data!.copyWith(upiId: upiId);

    _isSavingUpi = false;
    notifyListeners();
  }

  /// Caller is responsible for re-auth friction on the OFF path (PROJECT.md
  /// — turning off a security feature needs more friction than turning it
  /// on) before calling this; this just persists whichever direction was
  /// already confirmed.
  Future<void> setTwoStepEnabled(bool enabled) async {
    if (_data == null) return;
    _isTogglingTwoStep = true;
    notifyListeners();

    // TODO: replace with a real "update two-step setting" API call once
    // the Laravel backend exists (PROJECT.md 4).
    await _service.setTwoStepEnabled(enabled);
    _data = _data!.copyWith(twoStepEnabled: enabled);

    _isTogglingTwoStep = false;
    notifyListeners();
  }
}
