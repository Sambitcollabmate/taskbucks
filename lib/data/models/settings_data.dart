/// Fake data backing the Settings screen (PROJECT.md 6.1/Phase 4) — a
/// separate shape from [UserProfile] since Settings owns its own editable
/// fields (email, password, UPI, two-step), matching this codebase's
/// per-screen fake-service convention rather than coupling to Profile's
/// read-only summary.
class SettingsData {
  final String name;
  final String email;
  final String upiId;
  final bool isUpiDefault;
  final String bankAccountMasked;
  final bool twoStepEnabled;
  final String? imagePath;

  const SettingsData({
    required this.name,
    required this.email,
    required this.upiId,
    required this.isUpiDefault,
    required this.bankAccountMasked,
    required this.twoStepEnabled,
    this.imagePath,
  });

  SettingsData copyWith({
    String? name,
    String? email,
    String? upiId,
    bool? isUpiDefault,
    String? bankAccountMasked,
    bool? twoStepEnabled,
    // Wrapped in a sentinel so passing `imagePath: null` explicitly clears
    // it, while omitting the argument leaves the current value unchanged.
    Object? imagePath = _unset,
  }) {
    return SettingsData(
      name: name ?? this.name,
      email: email ?? this.email,
      upiId: upiId ?? this.upiId,
      isUpiDefault: isUpiDefault ?? this.isUpiDefault,
      bankAccountMasked: bankAccountMasked ?? this.bankAccountMasked,
      twoStepEnabled: twoStepEnabled ?? this.twoStepEnabled,
      imagePath: imagePath == _unset ? this.imagePath : imagePath as String?,
    );
  }
}

const _unset = Object();
