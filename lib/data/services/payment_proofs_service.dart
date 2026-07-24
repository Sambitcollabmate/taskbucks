import '../models/payment_proof.dart';
import '../models/payment_proofs_summary.dart';

// LEGAL-REVIEW: PROJECT.md Section 3 item 7 — every amount/name/date below
// is fabricated. Publishing fake payment proof on a real-money earning app
// is a real Consumer Protection Act concern (misleading advertising of
// payouts), not just a trust/UI nicety — this MUST be wired to real,
// aggregated transaction records before this screen ships. The sample-data
// warning banner on the screen exists specifically to cover this gap; it
// must stay in place until this service is backed by real data, not be
// removed just because the screen visually "looks done."
class PaymentProofsService {
  Future<PaymentProofsSummary> fetchSummary() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    return PaymentProofsSummary(
      lastCycleTotal: 486250,
      totalEarners: 3140,
      testimonialQuote:
          "I was skeptical the first month, but the payout landed in my "
          "UPI right on the 1st, exactly what the app showed. I've been "
          "using it for over a year now.",
      testimonialName: 'Ayesha K., Mumbai',
      proofs: [
        PaymentProofEntry(
          amount: 1245,
          maskedUsername: 'Ay***a K.',
          method: 'UPI',
          date: DateTime(now.year, now.month == 1 ? 12 : now.month - 1, 1),
        ),
        PaymentProofEntry(
          amount: 980,
          maskedUsername: 'Vi***m S.',
          method: 'UPI',
          date: DateTime(now.year, now.month == 1 ? 12 : now.month - 1, 1),
        ),
        PaymentProofEntry(
          amount: 2110,
          maskedUsername: 'Pr***a R.',
          method: 'Bank',
          date: DateTime(now.year, now.month == 1 ? 12 : now.month - 1, 1),
        ),
        PaymentProofEntry(
          amount: 655,
          maskedUsername: 'Ro***t M.',
          method: 'UPI',
          date: DateTime(now.year, now.month == 1 ? 12 : now.month - 1, 1),
        ),
        PaymentProofEntry(
          amount: 1580,
          maskedUsername: 'Su***a D.',
          method: 'Bank',
          date: DateTime(now.year, now.month == 1 ? 12 : now.month - 1, 1),
        ),
        PaymentProofEntry(
          amount: 720,
          maskedUsername: 'Ka***k P.',
          method: 'UPI',
          date: DateTime(now.year, now.month == 1 ? 12 : now.month - 1, 1),
        ),
      ],
    );
  }
}
