/// Available (tappable) or already watched. Unlike `Task`/`TaskState`,
/// there's no `locked`/sequential-queue state: all of a week's bonus slots
/// are simultaneously tappable in any order (PROJECT.md 2).
enum BonusAdState { available, watched }

/// A single weekly bonus ad slot, earned by a Premium referrer hitting the
/// weekly referral threshold (PROJECT.md 2), watchable any time during the
/// week it's active, worth the same rate as a normal task.
class BonusAdSlot {
  final int id;
  final BonusAdState state;
  final double rate;

  const BonusAdSlot({required this.id, required this.state, required this.rate});
}
