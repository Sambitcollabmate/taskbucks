/// One row in the Payment Proofs list — masked so no real user's full
/// identity is shown, same masking convention as `Referral.maskedUsername`.
class PaymentProofEntry {
  final double amount;
  final String maskedUsername;
  final String method;
  final DateTime date;

  const PaymentProofEntry({
    required this.amount,
    required this.maskedUsername,
    required this.method,
    required this.date,
  });
}
