import '../models/notification_type.dart';
import '../models/settings_data.dart';
import 'user_avatar_store.dart';

/// Fake data source for the Settings screen. Returns the same shape the
/// real Laravel endpoint will return once it exists (see PROJECT.md
/// Section 4/7). Every mutator is a stubbed round-trip — `// TODO`s in
/// [SettingsProvider] flag replacing these with real API calls.
class SettingsService {
  Future<SettingsData> fetchSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return SettingsData(
      name: 'Sambit',
      email: 'sambit@example.com',
      upiId: 'sambit@okhdfcbank',
      isUpiDefault: true,
      bankAccountMasked: '•••• 4521 (HDFC Bank)',
      twoStepEnabled: true,
      // Earnings/Account pushes are functionally important (credits,
      // security alerts) so they default ON; Promotions defaults OFF —
      // opt-in, not opt-out, for marketing pushes (PROJECT.md Notifications
      // doc, Section 1: restraint over engagement-at-any-cost).
      earningsPushEnabled: true,
      accountPushEnabled: true,
      promotionsPushEnabled: false,
      imagePath: UserAvatarStore.imagePath,
    );
  }

  Future<void> updateProfile({required String name, required String email}) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> updateProfileImage(String? imagePath) async {
    await Future.delayed(const Duration(milliseconds: 400));
    UserAvatarStore.imagePath = imagePath;
  }

  Future<void> updatePassword({required String newPassword}) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> updateUpiId(String upiId) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> setTwoStepEnabled(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> setPushCategoryEnabled(
    NotificationCategory category,
    bool enabled,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
