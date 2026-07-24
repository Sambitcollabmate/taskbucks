# Reward & Referral Rate Update — Plan

Confirmed with client (2026-07-23). This changes locked business rules in
`PROJECT.md` Section 2. Implementation only proceeded once every open
question below was answered.

## Confirmed changes

1. **Task/ad reward**: ₹100 per completed ad task (was ₹2).
   - Task caps unchanged: 25/day free tier, 30/day Premium tier, reset at
     midnight, no carryover.
2. **Premium subscription**: unchanged. ₹49/month, 30 tasks/day at the same
   ₹/task rate, cancel anytime, benefits continue until end of paid cycle.
3. **Referral commission**: ₹125 per referred user (was ₹15).
4. **New weekly referral bonus**:
   - Week cycle: Sunday to Saturday.
   - **Eligibility, both sides must be Premium**: the referrer must
     themselves hold an active Premium subscription to qualify for the
     bonus ads at all. A free-tier referrer still earns the ₹125/referral
     commission as normal, but never the +5 bonus ads regardless of how
     many people they refer.
   - The referred users must also complete their Premium purchase; signup
     alone never counts, same as the base commission rule.
   - Referring **5 or more** users who convert to Premium **within that
     same week** earns a flat **+5 bonus ad-watch slots**.
   - **"Week" means the week the Premium purchase happens, not the week
     the person was referred/signed up.** Signup timing is irrelevant to
     the count; only the conversion date matters. Each Sun-Sat week's tally
     is independent, with no partial carryover. If only 4 of a referrer's
     users convert in one week and a 5th converts the following week,
     neither week reaches 5, so no bonus fires for either (confirmed by
     client; this was the point of ambiguity, now resolved).
   - Bonus is flat, not tiered. 5, 7, or 10 conversions in the week all
     grant the same +5 bonus slots. Referral commission itself is uncapped
     (7 conversions still pays 7 × ₹125).
   - Bonus slots activate the **following** week (not the week earned) and
     can be watched any time during that week, in any order.

## All open questions, now resolved

1. Bonus ads pay **₹100 each**, same rate as any normal task.
2. The existing "top referrer/top ad-watcher" weekly leaderboard bonus in
   Section 2 **stays, unreplaced, still TBD**. The new +5 bonus slots are
   additive/separate; they just feed into the ad-watcher side of that
   still-undecided leaderboard ranking (a referrer's bonus-ad completions
   count toward their ad-watcher total).
3. The ₹125 referral commission keeps the **exact same trigger logic** as
   the old ₹15 rule: credited only when the referred user completes the
   ₹49 Premium purchase (never on signup alone), shown as "pending" until
   cleared, reversed if the purchase is refunded/charged back.

Plan was fully confirmed and implemented on 2026-07-23.

## Implementation status

**Done:**
- `PROJECT.md` Section 2 updated with the new figures and the full weekly
  bonus mechanic.
- Every ₹2/task and ₹15/referral reference across fake data and copy
  updated to ₹100/₹125: `tasks_service.dart`, `wallet_service.dart`,
  `transactions_service.dart`, `refer_service.dart`,
  `notifications_service.dart`, `support_service.dart`, Welcome,
  `how_it_works_list.dart`, How It Works, FAQ, Terms, Refund, Upgrade, plus
  doc comments on `wallet_summary.dart`/`referral.dart`/
  `wallet_breakdown_card.dart`/`referral_row.dart`.
- `ReferSummary` gained `isPremium`/`conversionsThisWeek`/
  `bonusAdSlotsAvailable` fields plus `weeklyBonusConversionThreshold`
  (5)/`weeklyBonusAdSlots` (5) constants (`data/models/refer_summary.dart`).
- New `WeeklyBonusCard` (`screens/refer/widgets/weekly_bonus_card.dart`)
  surfaces the bonus on Refer & Earn in its 3 states (locked/progress/
  active); see the Phase 2 addendum in `PROJECT.md`.
- FAQ, How It Works, Terms, and Upgrade all got copy explaining the new
  bonus mechanic, not just the rate change.
- Bonus ad slots are now watchable on the Tasks screen (2026-07-23,
  Option A from the reviewed prototype: a separate gold mini-grid, not
  folded into the daily queue). New `BonusAdSlot`/`BonusAdState` model
  (`data/models/bonus_ad_slot.dart`), `TasksSummary.bonusSlots` plus
  `bonusSlotsWatched`/`bonusSlotsRemaining` getters (`earnedToday` now
  includes watched bonus slots), `BonusAdsSection`
  (`screens/tasks/widgets/bonus_ads_section.dart`), and
  `TasksProvider.completeBonusSlot`. `TasksService`'s fake data grants 5
  available slots, matching `ReferService`'s demo `bonusAdSlotsAvailable: 5`.

All planned work for this update is now implemented.
