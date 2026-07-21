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
      bankAccountMasked: 'HDFC Bank •••• 4521',
      twoStepEnabled: true,
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
}
