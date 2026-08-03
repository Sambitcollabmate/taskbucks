import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/notification_type.dart';
import '../models/settings_data.dart';

/// Real Laravel `v1/settings`/`v1/profile` calls (api_requirements.md §1) —
/// replaces the fake-service convention.
class SettingsService {
  Future<SettingsData> fetchSettings() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/settings');
      return _fromJson(response.data as Map<String, dynamic>);
    });
  }

  /// `PATCH /v1/profile` only returns `name`/`mobile`/`tier`/`avatar_url` —
  /// the caller merges the returned name/avatar into its existing
  /// [SettingsData] rather than treating this as a full settings snapshot.
  Future<({String name, String? avatarUrl})> updateProfile({
    required String name,
    required String email,
  }) {
    return ApiClient.call((dio) async {
      final response = await dio.patch('/profile', data: {
        'name': name,
        'email': email.isEmpty ? null : email,
      });
      final profile = response.data as Map<String, dynamic>;
      return (name: profile['name'] as String, avatarUrl: profile['avatar_url'] as String?);
    });
  }

  Future<String?> updateProfileImage(String imagePath) {
    return ApiClient.call((dio) async {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });
      final response = await dio.post('/profile/avatar', data: formData);
      return response.data['avatar_url'] as String?;
    });
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return ApiClient.call((dio) => dio.patch('/profile/password', data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        }));
  }

  Future<void> updateUpiId(String upiId) {
    return ApiClient.call((dio) => dio.patch('/settings/upi', data: {'upi_id': upiId}));
  }

  Future<void> setTwoStepEnabled(bool enabled) {
    return ApiClient.call(
      (dio) => dio.patch('/settings/two-step', data: {'enabled': enabled}),
    );
  }

  Future<void> setPushCategoryEnabled(NotificationCategory category, bool enabled) {
    final field = switch (category) {
      NotificationCategory.earnings => 'earnings_push_enabled',
      NotificationCategory.account => 'account_push_enabled',
      NotificationCategory.promotions => 'promotions_push_enabled',
    };
    return ApiClient.call(
      (dio) => dio.patch('/settings/push-preferences', data: {field: enabled}),
    );
  }

  SettingsData _fromJson(Map<String, dynamic> json) {
    return SettingsData(
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      upiId: json['upi_id'] as String? ?? '',
      isUpiDefault: json['is_upi_default'] as bool? ?? false,
      bankAccountMasked: json['bank_account_masked'] as String? ?? '',
      twoStepEnabled: json['two_step_enabled'] as bool? ?? false,
      earningsPushEnabled: json['earnings_push_enabled'] as bool? ?? true,
      accountPushEnabled: json['account_push_enabled'] as bool? ?? true,
      promotionsPushEnabled: json['promotions_push_enabled'] as bool? ?? false,
      imagePath: json['avatar_url'] as String?,
    );
  }
}
