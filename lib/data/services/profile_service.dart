import '../models/user_profile.dart';

/// Fake data source for the Profile screen. Returns the same shape the
/// real Laravel endpoint will return once it exists (see PROJECT.md
/// Section 4/7).
class ProfileService {
  Future<UserProfile> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return const UserProfile(
      name: 'Sambit',
      phone: '+91 98765 43211',
      tier: UserTier.free,
    );
  }
}
