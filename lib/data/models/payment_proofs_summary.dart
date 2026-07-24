import 'payment_proof.dart';

class PaymentProofsSummary {
  final double lastCycleTotal;
  final int totalEarners;
  final List<PaymentProofEntry> proofs;
  final String testimonialQuote;
  final String testimonialName;

  const PaymentProofsSummary({
    required this.lastCycleTotal,
    required this.totalEarners,
    required this.proofs,
    required this.testimonialQuote,
    required this.testimonialName,
  });
}
