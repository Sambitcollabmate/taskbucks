/// The `user` object shape shared by AUTH_API.md's login/verify-otp/me
/// responses.
class AuthUser {
  final int id;
  final String name;
  final String mobile;
  final String? email;
  final String referralCode;
  final int? referredBy;
  final DateTime? mobileVerifiedAt;
  final String tier;

  const AuthUser({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.referralCode,
    required this.referredBy,
    required this.mobileVerifiedAt,
    required this.tier,
  });

  bool get isPremium => tier == 'premium';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String?,
      referralCode: json['referral_code'] as String,
      referredBy: json['referred_by'] as int?,
      mobileVerifiedAt: json['mobile_verified_at'] == null
          ? null
          : DateTime.parse(json['mobile_verified_at'] as String),
      tier: json['tier'] as String,
    );
  }
}

/// `{ reset_token, expires_in_seconds }` — returned by `verify-otp` when
/// `purpose` is `password_reset`, once MSG91 confirms the widget's
/// access-token. Short-lived proof the mobile was verified, required by the
/// follow-up `forgot-password/reset` call (AUTH_API.md).
class PasswordResetChallenge {
  final String resetToken;
  final int expiresInSeconds;

  const PasswordResetChallenge({
    required this.resetToken,
    required this.expiresInSeconds,
  });

  factory PasswordResetChallenge.fromJson(Map<String, dynamic> json) {
    return PasswordResetChallenge(
      resetToken: json['reset_token'] as String,
      expiresInSeconds: json['expires_in_seconds'] as int,
    );
  }
}

/// `{ token, user }` — shared by login/verify-otp responses.
class AuthSession {
  final String token;
  final AuthUser user;

  const AuthSession({required this.token, required this.user});

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token'] as String,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
