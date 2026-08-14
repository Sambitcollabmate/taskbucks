/// The `user` object shape shared by AUTH_API.md's login/verify-otp/me
/// responses.
class AuthUser {
  final int id;
  final String name;
  final String mobile;
  final String email;
  final String referralCode;
  final int? referredBy;
  final DateTime? emailVerifiedAt;
  final String tier;

  const AuthUser({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.referralCode,
    required this.referredBy,
    required this.emailVerifiedAt,
    required this.tier,
  });

  bool get isPremium => tier == 'premium';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String,
      referralCode: json['referral_code'] as String,
      referredBy: json['referred_by'] as int?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      tier: json['tier'] as String,
    );
  }
}

/// `{ reset_token, expires_in_seconds }` — returned by `verify-otp` when
/// `purpose` is `password_reset`, once the emailed OTP is confirmed.
/// Short-lived proof the email was verified, required by the follow-up
/// `forgot-password/reset` call (AUTH_API.md).
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

/// `POST /auth/login`'s response is one of these two shapes — a full
/// [AuthSession] when the account has no two-step verification enabled, or
/// [LoginTwoStepRequired] (password was correct, but a second factor is
/// still owed) when it does. See AUTH_API.md's `POST /auth/login`.
sealed class LoginResult {
  const LoginResult();

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return json['two_step_required'] == true
        ? LoginTwoStepRequired.fromJson(json)
        : LoginSuccess(AuthSession.fromJson(json));
  }
}

class LoginSuccess extends LoginResult {
  final AuthSession session;

  const LoginSuccess(this.session);
}

/// `{ two_step_required: true, challenge_token, email, expires_in_seconds }`
/// — the server emails an OTP to [email] as part of this response; the
/// client exchanges the code for a real [AuthSession] via
/// `AuthService.verifyLoginTwoStep`, submitting [challengeToken].
class LoginTwoStepRequired extends LoginResult {
  final String challengeToken;
  final String email;
  final int expiresInSeconds;

  const LoginTwoStepRequired({
    required this.challengeToken,
    required this.email,
    required this.expiresInSeconds,
  });

  factory LoginTwoStepRequired.fromJson(Map<String, dynamic> json) {
    return LoginTwoStepRequired(
      challengeToken: json['challenge_token'] as String,
      email: json['email'] as String,
      expiresInSeconds: json['expires_in_seconds'] as int,
    );
  }
}
