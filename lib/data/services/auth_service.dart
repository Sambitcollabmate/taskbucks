import '../../core/network/api_client.dart';
import '../models/auth_user.dart';

/// `POST /v1/auth/verify-otp`'s `purpose` field (AUTH_API.md).
enum OtpPurpose { registration, passwordReset }

extension on OtpPurpose {
  String get wireValue => switch (this) {
        OtpPurpose.registration => 'registration',
        OtpPurpose.passwordReset => 'password_reset',
      };
}

/// Real Laravel `v1/auth/*` calls (AUTH_API.md). OTP send/verify itself now
/// happens client-side against MSG91's Login-with-OTP widget
/// (`OTPWidget.sendOTP`/`verifyOTP` in the Verify Phone / Forgot Password
/// screens) — this service only ever sees the resulting access-token, never
/// a raw OTP (MSG91_WIDGET_REVIEW.md).
class AuthService {
  /// Pre-check only — does *not* create a pending record or trigger any SMS.
  /// Called before the widget's `sendOTP` so a duplicate mobile/email or bad
  /// referral code is caught before MSG91 is asked to send anything.
  Future<void> registerPrecheck({
    required String name,
    required String mobile,
    String? email,
    required String password,
    String? referralCode,
  }) {
    return ApiClient.call((dio) => dio.post('/auth/register', data: {
          'name': name,
          'mobile': mobile,
          if (email != null && email.isNotEmpty) 'email': email,
          'password': password,
          if (referralCode != null && referralCode.isNotEmpty) 'referral_code': referralCode,
        }));
  }

  /// Registration path: server verifies [accessToken] with MSG91, then
  /// creates the user and issues a Sanctum token.
  Future<AuthSession> verifyRegistration({
    required String accessToken,
    required String name,
    required String mobile,
    String? email,
    required String password,
    String? referralCode,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/auth/verify-otp', data: {
        'access_token': accessToken,
        'purpose': OtpPurpose.registration.wireValue,
        'mobile': mobile,
        'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        'password': password,
        if (referralCode != null && referralCode.isNotEmpty) 'referral_code': referralCode,
      });
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    });
  }

  /// Password-reset path: server verifies [accessToken] with MSG91 and, on
  /// success, hands back a short-lived [PasswordResetChallenge.resetToken]
  /// the client submits to [forgotPasswordReset].
  Future<PasswordResetChallenge> verifyPasswordResetOtp({
    required String accessToken,
    required String mobile,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/auth/verify-otp', data: {
        'access_token': accessToken,
        'purpose': OtpPurpose.passwordReset.wireValue,
        'mobile': mobile,
      });
      return PasswordResetChallenge.fromJson(response.data as Map<String, dynamic>);
    });
  }

  Future<AuthSession> login({required String identifier, required String password}) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/auth/login', data: {
        'identifier': identifier,
        'password': password,
      });
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    });
  }

  /// Pre-check only, mirroring [registerPrecheck] — confirms an account
  /// exists for [mobile] before the Forgot Password screen triggers the
  /// widget's `sendOTP`.
  Future<void> forgotPasswordPrecheck(String mobile) {
    return ApiClient.call((dio) => dio.post('/auth/forgot-password/request', data: {
          'mobile': mobile,
        }));
  }

  Future<void> forgotPasswordReset({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) {
    return ApiClient.call((dio) async {
      await dio.post('/auth/forgot-password/reset', data: {
        'reset_token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
    });
  }

  Future<void> logout() {
    return ApiClient.call((dio) => dio.post('/auth/logout'));
  }

  Future<AuthUser> me() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/auth/me');
      return AuthUser.fromJson(response.data as Map<String, dynamic>);
    });
  }
}
