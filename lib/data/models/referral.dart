/// Whether a referral has converted (referred user completed the ₹49
/// Premium purchase — see PROJECT.md 2) or is still pending that purchase.
enum ReferralStatus { converted, pending }

class Referral {
  final String id;
  final String maskedUsername;
  final DateTime date;
  final ReferralStatus status;
  final double amount;

  const Referral({
    required this.id,
    required this.maskedUsername,
    required this.date,
    required this.status,
    required this.amount,
  });
}
