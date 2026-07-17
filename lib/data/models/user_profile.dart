/// Free grants 25 tasks/day; Premium (₹49/month) grants 30 tasks/day at the
/// same ₹/task rate (PROJECT.md 2).
enum UserTier { free, premium }

class UserProfile {
  final String name;
  final String phone;
  final UserTier tier;

  const UserProfile({required this.name, required this.phone, required this.tier});
}
