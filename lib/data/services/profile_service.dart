import '../../core/network/api_client.dart';
import '../models/user_profile.dart';

/// Real `GET /v1/profile` call (api_requirements.md §1).
class ProfileService {
  Future<UserProfile> fetchProfile() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/profile');
      final json = response.data as Map<String, dynamic>;
      return UserProfile(
        name: json['name'] as String,
        phone: json['mobile'] as String,
        email: json['email'] as String?,
        tier: json['tier'] == 'premium' ? UserTier.premium : UserTier.free,
        imagePath: json['avatar_url'] as String?,
        premiumExpiresAt: json['premium_expires_at'] == null
            ? null
            : DateTime.parse(json['premium_expires_at'] as String),
      );
    });
  }
}
