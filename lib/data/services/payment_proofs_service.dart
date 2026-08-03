import '../../core/network/api_client.dart';
import '../models/payment_proof.dart';
import '../models/payment_proofs_summary.dart';

/// Real `GET /v1/payment-proofs` call (api_requirements.md §10, PROJECT.md
/// Section 3 item 7) — deliberately public, no auth required. Every field
/// is real, aggregated transaction data; no withdrawal is ever marked
/// 'paid' yet (payout gateway still pending), so `proofs` is legitimately
/// empty today rather than backfilled with placeholder rows. The screen's
/// dashed-red `SampleDataBanner` must stay in place regardless — this
/// class no longer fabricates anything, but the underlying payout data
/// itself still doesn't exist.
class PaymentProofsService {
  Future<PaymentProofsSummary> fetchSummary() {
    return ApiClient.call((dio) async {
      final response = await dio.get('/payment-proofs');
      final json = response.data as Map<String, dynamic>;
      return PaymentProofsSummary(
        lastCycleTotal: double.parse(json['last_cycle_total'] as String),
        totalEarners: json['total_earners'] as int,
        testimonialQuote: json['testimonial_quote'] as String,
        testimonialName: json['testimonial_name'] as String,
        proofs: (json['proofs'] as List)
            .cast<Map<String, dynamic>>()
            .map(_proofFromJson)
            .toList(),
      );
    });
  }

  PaymentProofEntry _proofFromJson(Map<String, dynamic> json) {
    return PaymentProofEntry(
      amount: double.parse(json['amount'] as String),
      maskedUsername: json['masked_username'] as String,
      method: json['method'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
