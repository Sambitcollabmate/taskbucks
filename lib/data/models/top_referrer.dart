/// A single rank in Refer & Earn's "this week's top referrers" board,
/// ranked by conversion count. The weekly bonus gift for the #1 spot is
/// still TBD (PROJECT.md 2) — this model doesn't carry a bonus amount.
class TopReferrer {
  final int rank;
  final String maskedUsername;
  final int conversions;

  const TopReferrer({
    required this.rank,
    required this.maskedUsername,
    required this.conversions,
  });
}
