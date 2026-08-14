/// Free grants 25 tasks/day; Premium (₹49/month) grants 30 tasks/day at the
/// same ₹/task rate (PROJECT.md 2).
enum UserTier { free, premium }

class UserProfile {
  final String name;
  final String phone;
  final String? email;
  final UserTier tier;
  final String? imagePath;
  final DateTime? premiumExpiresAt;

  const UserProfile({
    required this.name,
    required this.phone,
    this.email,
    required this.tier,
    this.imagePath,
    this.premiumExpiresAt,
  });
}
