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

/// Real Laravel `v1/auth/*` calls (AUTH_API.md). OTP generation, delivery
/// (email), and verification are entirely server-side
/// (`App\Services\EmailOtpService`) — this service submits the 6-digit code
/// the user reads out of their email, not a widget-issued token.
class AuthService {
  /// Pre-check only, but also the moment the OTP email actually goes out —
  /// there's no separate client-side widget step to trigger it.
  Future<void> registerPrecheck({
    required String name,
    required String email,
    required String mobile,
    required String password,
    String? referralCode,
  }) {
    return ApiClient.call(
      (dio) => dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'mobile': mobile,
          'password': password,
          if (referralCode != null && referralCode.isNotEmpty)
            'referral_code': referralCode,
        },
      ),
    );
  }

  /// Registration path: server verifies [otp] against the emailed code, then
  /// creates the user and issues a Sanctum token.
  Future<AuthSession> verifyRegistration({
    required String otp,
    required String name,
    required String email,
    required String mobile,
    required String password,
    String? referralCode,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {
          'otp': otp,
          'purpose': OtpPurpose.registration.wireValue,
          'email': email,
          'name': name,
          'mobile': mobile,
          'password': password,
          if (referralCode != null && referralCode.isNotEmpty)
            'referral_code': referralCode,
        },
      );
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    });
  }

  /// Password-reset path: server verifies [otp] against the emailed code
  /// and, on success, hands back a short-lived
  /// [PasswordResetChallenge.resetToken] the client submits to
  /// [forgotPasswordReset].
  Future<PasswordResetChallenge> verifyPasswordResetOtp({
    required String otp,
    required String email,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {
          'otp': otp,
          'purpose': OtpPurpose.passwordReset.wireValue,
          'email': email,
        },
      );
      return PasswordResetChallenge.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  Future<LoginResult> login({
    required String identifier,
    required String password,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post(
        '/auth/login',
        data: {'identifier': identifier, 'password': password},
      );
      return LoginResult.fromJson(response.data as Map<String, dynamic>);
    });
  }

  /// Second step of a two-step login — exchanges [challengeToken] (from the
  /// [LoginTwoStepRequired] response) and the emailed [otp] for the real
  /// session, mirroring [verifyRegistration]'s code handoff.
  Future<AuthSession> verifyLoginTwoStep({
    required String challengeToken,
    required String otp,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post(
        '/auth/login/verify-2fa',
        data: {'challenge_token': challengeToken, 'otp': otp},
      );
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    });
  }

  /// Pre-check only, mirroring [registerPrecheck] — confirms an account
  /// exists for [email] and triggers the OTP email.
  Future<void> forgotPasswordPrecheck(String email) {
    return ApiClient.call(
      (dio) =>
          dio.post('/auth/forgot-password/request', data: {'email': email}),
    );
  }

  Future<void> forgotPasswordReset({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) {
    return ApiClient.call((dio) async {
      await dio.post(
        '/auth/forgot-password/reset',
        data: {
          'reset_token': resetToken,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
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
