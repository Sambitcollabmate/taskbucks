import 'referral.dart';
import 'top_referrer.dart';

/// Threshold for the weekly referral bonus (PROJECT.md 2). Flat, not
/// tiered, so nothing beyond this constant is needed to check eligibility.
const weeklyBonusConversionThreshold = 5;

/// Flat bonus ad-watch slots granted once [weeklyBonusConversionThreshold]
/// is hit in a single Sun–Sat week (PROJECT.md 2).
const weeklyBonusAdSlots = 5;

class ReferSummary {
  final String referralCode;
  final int totalReferred;
  final int totalConverted;
  final double totalEarned;
  final List<Referral> recentReferrals;
  final List<TopReferrer> topReferrers;

  /// Whether this user currently holds Premium. The weekly referral bonus
  /// (PROJECT.md 2) gates on this regardless of referral volume; a
  /// free-tier user still earns the flat commission but never the bonus.
  final bool isPremium;

  /// How many of this user's referrals completed their Premium purchase
  /// within the current Sun–Sat week so far, counted by purchase date,
  /// not signup/referral date (PROJECT.md 2).
  final int conversionsThisWeek;

  /// Bonus ad slots active *this* week, earned by hitting the threshold
  /// last week. Zero if last week fell short: no partial credit rolls
  /// forward.
  final int bonusAdSlotsAvailable;

  const ReferSummary({
    required this.referralCode,
    required this.totalReferred,
    required this.totalConverted,
    required this.totalEarned,
    required this.recentReferrals,
    required this.topReferrers,
    required this.isPremium,
    required this.conversionsThisWeek,
    required this.bonusAdSlotsAvailable,
  });
}
