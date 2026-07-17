import 'referral.dart';
import 'top_referrer.dart';

class ReferSummary {
  final String referralCode;
  final int totalReferred;
  final int totalConverted;
  final double totalEarned;
  final List<Referral> recentReferrals;
  final List<TopReferrer> topReferrers;

  const ReferSummary({
    required this.referralCode,
    required this.totalReferred,
    required this.totalConverted,
    required this.totalEarned,
    required this.recentReferrals,
    required this.topReferrers,
  });
}
