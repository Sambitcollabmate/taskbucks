import '../models/refer_summary.dart';
import '../models/referral.dart';
import '../models/top_referrer.dart';

/// Fake data source for the Refer & Earn screen. Returns the same shape the
/// real Laravel endpoint will return once it exists (see PROJECT.md
/// Section 4/7). Referral commission is a flat ₹15, credited only once the
/// referred user completes the ₹49 Premium purchase (PROJECT.md 2) — shows
/// as "pending" until then.
class ReferService {
  Future<ReferSummary> fetchReferSummary() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    return ReferSummary(
      referralCode: 'SAMBIT482',
      totalReferred: 12,
      totalConverted: 8,
      totalEarned: 120,
      recentReferrals: [
        Referral(
          id: 'r1',
          maskedUsername: 'Ay***a K.',
          date: now.subtract(const Duration(hours: 5)),
          status: ReferralStatus.converted,
          amount: 15,
        ),
        Referral(
          id: 'r2',
          maskedUsername: 'Vi***m S.',
          date: now.subtract(const Duration(days: 1)),
          status: ReferralStatus.pending,
          amount: 0,
        ),
        Referral(
          id: 'r3',
          maskedUsername: 'Pr***a R.',
          date: now.subtract(const Duration(days: 2)),
          status: ReferralStatus.converted,
          amount: 15,
        ),
        Referral(
          id: 'r4',
          maskedUsername: 'Ro***t M.',
          date: now.subtract(const Duration(days: 4)),
          status: ReferralStatus.pending,
          amount: 0,
        ),
        Referral(
          id: 'r5',
          maskedUsername: 'Su***a D.',
          date: now.subtract(const Duration(days: 6)),
          status: ReferralStatus.converted,
          amount: 15,
        ),
      ],
      topReferrers: const [
        TopReferrer(rank: 1, maskedUsername: 'Ay***a K.', conversions: 6),
        TopReferrer(rank: 2, maskedUsername: 'Su***a D.', conversions: 4),
        TopReferrer(rank: 3, maskedUsername: 'Pr***a R.', conversions: 3),
      ],
    );
  }
}
