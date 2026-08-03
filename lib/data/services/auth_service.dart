import '../../core/network/api_client.dart';
import '../models/auth_user.dart';

/// `POST /v1/auth/verify-otp`'s `purpose` field — only `registration` is
/// wired to an actual flow server-side today (AUTH_API.md).
enum OtpPurpose { registration, login, passwordReset }

extension on OtpPurpose {
  String get wireValue => switch (this) {
        OtpPurpose.registration => 'registration',
        OtpPurpose.login => 'login',
        OtpPurpose.passwordReset => 'password_reset',
      };
}

/// Real Laravel `v1/auth/*` calls (AUTH_API.md) — replaces the fake-service
/// convention every other `data/services/*` class still uses (PROJECT.md
/// Phase 7).
class AuthService {
  Future<OtpChallenge> register({
    required String name,
    required String mobile,
    String? email,
    required String password,
    String? referralCode,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/auth/register', data: {
        'name': name,
        'mobile': mobile,
        if (email != null && email.isNotEmpty) 'email': email,
        'password': password,
        if (referralCode != null && referralCode.isNotEmpty) 'referral_code': referralCode,
      });
      return OtpChallenge.fromJson(response.data as Map<String, dynamic>);
    });
  }

  Future<OtpChallenge> resendOtp(String referenceToken) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/auth/resend-otp', data: {
        'reference_token': referenceToken,
      });
      return OtpChallenge.fromJson(response.data as Map<String, dynamic>);
    });
  }

  Future<AuthSession> verifyOtp({
    required String referenceToken,
    required String otp,
    OtpPurpose purpose = OtpPurpose.registration,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/auth/verify-otp', data: {
        'reference_token': referenceToken,
        'otp': otp,
        'purpose': purpose.wireValue,
      });
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
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

  Future<OtpChallenge> forgotPasswordRequest(String mobile) {
    return ApiClient.call((dio) async {
      final response = await dio.post('/auth/forgot-password/request', data: {
        'mobile': mobile,
      });
      return OtpChallenge.fromJson(response.data as Map<String, dynamic>);
    });
  }

  Future<void> forgotPasswordReset({
    required String referenceToken,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) {
    return ApiClient.call((dio) async {
      await dio.post('/auth/forgot-password/reset', data: {
        'reference_token': referenceToken,
        'otp': otp,
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
