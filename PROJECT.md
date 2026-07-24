# earnbucks.in — Flutter App Build Instructions

**Purpose of this file:** Hand this to Claude Code (or read from it yourself) as the
single source of truth for building the app. It resolves conflicts between the
written product docs and the visual mockups, defines the architecture, and lays
out the build order. Update this file as decisions change — don't let decisions
live only in chat history.

---

## 0. Non-negotiable context for whoever picks this up

- Solo developer (no team, no one to review PRs). Code should be simple and
  boring over clever. Prefer explicit code to magic/abstraction.
- Background: Laravel, Node, React. New to Flutter — explain Flutter-specific
  concepts (widgets, State, Provider) in terms of React/Laravel equivalents
  when relevant, don't assume Flutter idioms are already known.
- Eventual backend is Laravel (existing skill). Flutter app will consume a
  Laravel REST API. Do not build a Firebase/Supabase backend — assume Laravel.
- This is a real-money earning app operating in India. Every screen that
  touches balance, payout, or referral commission must be built to the exact
  business rules below — do not "improve" or simplify the money logic without
  asking first.
- App identity rebrand (2026-07-23): the project was scaffolded as
  "taskbucks_app"/`com.example.taskbucks_app` by `flutter create` and never
  updated to match `AppConfig.brandName` ("EarnBucks"), which is why a
  fresh Android install showed "taskbucks_app" as the app name. Renamed
  everywhere: Android `android:label`/`applicationId`/`namespace` (now
  `com.earnbucks.app`, `MainActivity.kt` moved to
  `android/app/src/main/kotlin/com/earnbucks/app/`), iOS
  `CFBundleDisplayName`/`CFBundleName`/`PRODUCT_BUNDLE_IDENTIFIER`, macOS
  `AppInfo.xcconfig`/`Runner.xcscheme`/`project.pbxproj`, Linux
  `CMakeLists.txt`/`my_application.cc`, Windows
  `CMakeLists.txt`/`main.cpp`/`Runner.rc`, web `manifest.json`/`index.html`,
  and the Dart package name itself in `pubspec.yaml` (now `earnbucks`, only
  consumer was `test/widget_test.dart`'s import). Used `com.earnbucks.app`
  rather than the domain's literal reverse (`in.earnbucks.app`), since `in`
  is a reserved keyword in Kotlin and would fail to compile as a package
  segment. Not touched: the `.iml`/`.idea` IDE workspace files (cosmetic,
  local to whoever has the project open, not part of the built app) and the
  `TaskBucksApp` Dart class name in `main.dart` (an internal identifier, not
  user-facing).

---

## 1. Source of truth when specs conflict

Two sources exist for this project and they **disagree on business model**:

1. Written product docs (24 pages, competitor research + copy + ASO) — INR,
   ads-only, fixed daily task cap, ₹49 Premium, purchase-triggered referrals,
   monthly-only payout.
2. Visual mockup screenshots (18 images) — USD, PayPal/multiple payout
   methods, offerwalls + surveys + microtasks, tiered membership, "rent a
   referral" marketplace, on-demand withdrawal.

**Resolved:** The written docs are the business-logic source of truth. The
screenshots are **style/UI reference only** — layout patterns, card shapes,
gradient balance hero, circular progress ring, bottom tab bar, spacing
rhythm. Do not build offerwalls, surveys, microtasks, USD, PayPal, or rented
referrals — those don't exist in this app. If a future prompt reintroduces
one of these features, flag the conflict before building it rather than
assuming the model changed.

---

## 2. Locked business rules (do not deviate without explicit confirmation)

- Currency: ₹ (INR) everywhere. No $ anywhere in the app.
- Free tier: 25 video-ad tasks per day, resets at midnight, unused tasks do
  not carry over.
- Premium tier: ₹49/month via Google Play Billing. Grants 30 tasks/day at the
  same ₹/task rate. Cancel anytime from Profile → Manage subscription;
  benefits continue until the end of the paid cycle.
- Task reward: **₹100 per completed task** (updated 2026-07-23, was ₹2;
  rate is still data-driven, not hardcoded, see data model in Section 4).
  Applies equally to free and Premium tiers; only the daily cap differs
  between them, never the per-task rate.
- Ads are AdMob Rewarded Video, non-skippable. Credit fires only on
  `onUserEarnedReward()`, never on tap/open.
- Referral commission: **₹125 flat** (updated 2026-07-23, was ₹15), credited
  **only** when the referred user completes the ₹49 Premium purchase, never
  on signup alone. Shows as "pending" until payment clears. Reversed
  (deducted from balance, even a future payout) if the referred purchase is
  refunded/charged back. Trigger logic is unchanged from the ₹15 rule, only
  the amount moved.
- Withdrawals: processed once a month, on the 1st, to UPI or verified bank
  account only. No PayPal, no Payoneer, no on-demand withdrawal. A UPI ID
  added within the last 24 hours is capped at ₹5,000 for that window as a
  fraud safeguard (new 2026-07-23); a transfer that fails for that reason
  may auto-retry once the 24 hours pass. The Withdraw screen only ever
  queues/requests a payout: it must never claim a transfer is instant or
  complete, since the actual transfer doesn't happen until the next 1st.
- **Weekly referral bonus** (new 2026-07-23): tracked on a Sunday-Saturday
  cycle.
  - **Gate**: the referrer must themselves hold an active Premium
    subscription to ever qualify for this bonus, regardless of referral
    volume. A free-tier referrer still earns the ₹125/conversion commission
    normally, but never the bonus ad slots below.
  - **Threshold**: if 5 or more of a Premium referrer's referred users
    complete their Premium purchase within the same Sun-Sat week, the
    referrer earns a flat **+5 bonus ad-watch slots** (each worth the same
    ₹100 as a normal task). The bonus does not tier above 5; 7 or 10
    conversions in one week still only grant +5 slots. The referral
    commission itself stays uncapped (7 conversions still pays 7 × ₹125).
  - **"Week" = the week the Premium purchase lands, not the week the
    referred user signed up or was referred.** Each week's tally is
    independent, with no partial credit, no rolling window, no carryover.
    If only 4 of a referrer's users convert in one week and a 5th converts
    the following week, neither week reaches 5 and no bonus fires for
    either.
  - Bonus slots activate the week **after** they're earned and can be
    watched any time that week, in any order. They add on top of that
    week's normal daily cap(s); they don't replace or extend any single
    day's limit.
  - This is **additive to, and separate from**, the still-undecided
    "top referrer/top ad-watcher" leaderboard bonus below. That one stays
    unreplaced and still TBD. A referrer's bonus-slot completions do count
    toward their ad-watcher total for that leaderboard, though.
- Weekly leaderboard bonus: top referrer and top ad-watcher each get a bonus
  gift (exact mechanic still TBD; flag as open item, don't invent a value;
  unaffected by the weekly referral bonus above).
- Auth: phone-number-first, OTP verification (not email-first). Register
  field order: name → mobile (+91 locked prefix) → optional email → password
  → optional referral code.

---

## 3. Open compliance items — do not silently resolve these in code

Track these as TODOs in the codebase (e.g. a `COMPLIANCE.md` or code comments
tagged `// LEGAL-REVIEW:`) rather than making an assumption and moving on:

1. Purchase-triggered referral commission structure needs legal review
   against India's Prize Chits and Money Circulation Schemes (Banning) Act.
2. PAN/TDS collection may be required in Profile once payout volume crosses
   a threshold — not yet confirmed by finance/legal.
3. Legal entity name, registration number, registered address — placeholders
   only, needed for About and Terms screens before launch.
4. Grievance Officer name/contact — required field in Terms, not yet
   designated.
5. Confirm whether the app qualifies as a "Significant Data Fiduciary" under
   India's DPDP Act (affects Privacy Policy content).
6. Profile-vs-Settings navigation duplication — decide one architecture
   (this file assumes the consolidated Settings screen approach — see
   Section 6) and make Profile's menu rows deep-link there.
7. Payment Proofs screen (`PaymentProofsService`) currently returns 100%
   fabricated amounts/names/dates. Publishing fake payout data on a real-
   money app is a Consumer Protection Act concern (misleading advertising
   of payouts), not just a trust/UI nicety. Must be wired to real,
   aggregated transaction records before launch — the screen's dashed-red
   `SampleDataBanner` exists specifically to cover this gap and must stay
   in place until this is resolved, not be removed just because the screen
   looks finished.

---

## 4. Tech stack (decided)

- Flutter (stable channel), Dart null-safety.
- State management: `provider` package. (Simple, matches your current
  experience level — do not switch to Bloc/Riverpod without a specific
  reason; don't over-engineer this.)
- Routing: `go_router`, with auth-based redirect logic and a `ShellRoute` for
  the persistent bottom tab bar around the 5 core tabs only.
- HTTP: `dio` (once a real Laravel API exists). Until then, all data comes
  from fake local "service" classes that return the same shape the real API
  will return — this lets UI work proceed without blocking on backend work.
- Fonts: `google_fonts` — Plus Jakarta Sans (headings/numerals), Inter
  (body).
- Icons: single-color inline SVG style, not emoji. Use `lucide_icons` (or an
  equivalent icon pack) rather than raw Material icons, to match the spec's
  icon requirement. Confirm icon source before Phase 2 — do not improvise.
- Currency formatting: `intl` package, `en_IN` locale, ₹ symbol, Indian digit
  grouping (e.g. ₹40.2L pattern used elsewhere in the app).
- No browser/local storage APIs — standard Flutter local state only. Any
  local persistence (e.g. "remember me") uses `shared_preferences` or
  `flutter_secure_storage` for sensitive tokens.

---

## 5. Design system (tokens — keep centralized, don't hardcode colors/fonts per widget)

- Primary: `#F0295E` (flat contexts — text, icons, borders, non-gradient
  buttons)
- Primary gradient: `primaryGradientStart` `#FF8A3D` → `primaryGradientEnd`
  `#F0295E`, used on gradient-filled surfaces (balance hero card, today's
  pulse indicator on Home's week streak)
- Earnings green: `#1FAA59`
- Premium gold: `#E8A23A` — used as an *accent* (icons, badges, price text),
  not a full-bleed fill; the Home upgrade banner pairs it with a dark
  charcoal gradient (`premiumSurfaceStart` `#2A2A35` → `premiumSurfaceEnd`
  `#13131A`) rather than a flat gold card, which read too "yellow"
- Warning/orange: `#F2994A` — mid-progress status (e.g. week streak partial
  day)
- Danger/red: `#E0523F` — reserved for an actual missed/past day, not for
  today while it's still in progress (today uses the primary gradient +
  pulse animation instead, so it doesn't read as "failed")
- Background: light neutral (`#F7F7FB`)
- Card background: white, soft shadow, 16–20px border radius
- Balance hero: gradient card (primary gradient, orange → pink), white text
- Task progress: circular ring, green when in progress, gold when the day's
  cap is complete
- Week streak (Home): 7-day strip, one letter per day; today pulses (primary
  gradient) instead of being colored red/green until its cap is met; past
  days color green (cap met) / orange (partial) / red (missed); future days
  neutral
- Bottom nav: 5 items — Home, Tasks, Wallet, Refer, Profile

All of the above live in `core/theme/` as the single place to edit look and
feel. No widget should define its own one-off color or font.

---

## 6. Architecture

### 6.1 Navigation shape (three contexts)

```
Pre-auth stack (no tab bar):
  Welcome → Register → Verify Phone → (Login, Forgot Password)

Post-auth tab bar (persistent, ShellRoute):
  Home · Tasks · Wallet · Refer & Earn · Profile

Push-only screens (reachable from tabs, no tab bar of their own):
  Upgrade, Withdraw, Transactions, Settings, Notifications,
  Support Tickets, How It Works, About, FAQ, Contact,
  Payment Proofs, Terms, Privacy, Refund
```

The post-auth tab bar is wired up (`core/router/app_router.dart`) with all
5 tabs now real screens (Home, Tasks, Wallet, Refer & Earn, Profile).

A full pre-auth stack now also exists — `/welcome` (real screen, and the
router's actual `initialLocation`), `/register`, `/login`,
`/forgot-password`, `/verify-phone` — and is connected to the post-auth
tab bar via a `redirect` callback + `AuthProvider` (`providers/
auth_provider.dart`): unauthenticated users are bounced from any
post-auth route to `/welcome`, authenticated users are bounced from any
pre-auth route to `/home`. `AuthProvider.isLoggedIn` is backed by the
session token `SessionService` persists for Login's "Remember me" (read
once on startup) and is otherwise set directly by `login()`/`logout()` —
a login without "Remember me" still counts as logged in for the current
run, it just won't survive an app restart. `GoRouter`'s
`refreshListenable: authProvider` means `login()`/`logout()` calling
`notifyListeners()` re-triggers the redirect check immediately (e.g.
Profile's log-out row calling `logout()` bounces straight to `/welcome`
without an explicit `context.go`).

Settings is a single consolidated screen (Profile, Security, Payment
details as scrollable sections with anchors) — Profile's menu rows deep-link
into specific sections rather than opening separate screens. This resolves
the Profile-vs-Settings ambiguity flagged in Section 3.

### 6.2 Folder structure

```
lib/
  main.dart
  core/
    theme/          (app_colors.dart, app_theme.dart)
    router/          (go_router config, auth redirect logic)
  data/
    models/          (one file per data shape: HomeSummary, Task, Transaction, etc.)
    services/        (fake-data-now/real-API-later service classes)
  providers/          (one ChangeNotifier per feature area)
  screens/
    home/
    tasks/
    wallet/
    refer/
    profile/
    auth/            (welcome, register, verify_phone, login, forgot_password)
    settings/
    legal/           (terms, privacy, refund — share one component)
    trust/            (how_it_works, about, faq, contact, payment_proofs)
    support/          (support_tickets)
    withdraw/
  shared/
    widgets/          (components reused across 3+ screens — see 6.3)
```

### 6.3 Shared components to build once (do not duplicate per-screen)

- `txn_row` — **built**, first used on Wallet's recent activity list, now
  also reused as-is on Transactions. Notifications turned out not to need
  it — a notification isn't a ₹ amount row, it's title/body/timestamp with
  a read/unread state, so it got its own `notification_row` instead (see
  below) rather than forcing txn_row's amount-focused layout to fit.
- `notification_row` — **built**, icon + title + body + timestamp, unread
  shown as a colored dot + tinted row background, read shown as muted/gray
  text. Icon + icon-color are keyed off `NotificationType` (`taskCredited`/
  `referralConverted`/`withdrawalQueued`/`streakBonus`) via a switch in the
  widget, same "enum drives icon in the widget, not stored on the model"
  convention `TxnRow`/`TransactionCategory` already use. Tap handling
  (mark-read + deep-link) is the caller's job via `onTap`, not baked into
  the row itself.
- `legal_screen` — **built**, shared template for Terms, Privacy, Refund
  (plain text, numbered headings, no cards). Takes `title`/`lastUpdated`/
  `tableOfContents`/`sections`; `LegalSection.text(...)` covers the common
  plain-paragraph case, but `body` is a `Widget` so a section can supply
  something else instead (a `PendingLegalCard`, or Refund's
  `UpgradeCrossReference`). Tapping a table-of-contents row scrolls to the
  matching section via `Scrollable.ensureVisible` + a per-section
  `GlobalKey`, same anchor pattern as Settings' section deep-linking.
- `pending_legal_card` — **built**, generalized from About's one-off
  `LegalPendingCard` (dashed warning border, each field shown as
  "Pending", explicit "do not invent" line) into `shared/widgets/` once
  Terms'/Privacy's Grievance Officer sections and Privacy's DPDP
  Significant-Data-Fiduciary section needed the same treatment with
  different field names/titles. `About`'s usage was updated to call this
  directly; the old `screens/trust/widgets/legal_pending_card.dart` is
  gone.
- `notice_card` (info / warn variants) — **built**, first used on Tasks'
  non-skippable-ads notice, now also used on Wallet's payout-cycle notice
  (warn variant). Still needed for Refer & Earn's trigger-disclosure and
  Withdraw's new-UPI warning.
- `phone_input` — **built**, first used on Register. A locked +91 box next
  to a free-text digits-only field (not a single text field the user could
  type a country code into); the caller reads the controller for just the
  10-digit number. Login turned out not to need it — its single identifier
  field accepts either a mobile number or an email, so a locked +91 prefix
  doesn't apply there. Still needed on Forgot Password.
- `otp_row` — **built**, first used on Verify Phone. 6 single-digit boxes,
  numeric keyboard, auto-advances focus per digit, auto-submits on the 6th
  digit (no separate Verify tap). `hasError` reddens all boxes without
  clearing them (wrong-code case); a real reset (resend) clears via
  `OtpRowState.clear()` through a `GlobalKey`. Still needed on Forgot
  Password.
- `main_bottom_nav` — **built**, the 5-tab bar (Home, Tasks, Wallet, Refer,
  Profile). Wired into a go_router `StatefulShellRoute.indexedStack` (see
  `core/router/app_router.dart`) so it persists across tab switches and each
  tab keeps its own state.
- `balance_hero_card` — **built**, gradient balance card reused on Home and
  Wallet. Action buttons (icon/label/onTap) are configurable per screen —
  Home uses Wallet/Refer & earn, Wallet uses Withdraw/History.
  - [x] Addendum (2026-07-23): the balance value itself moved to a shared
    `BalanceProvider` (`providers/balance_provider.dart`, one app-wide
    instance provided in `main.dart` alongside `authProvider`), after a
    real sync bug: `HomeSummary.balance`/`WalletSummary.balance` were two
    independently hardcoded fake numbers that drifted apart the moment
    either service's fake data changed, and completing a task on Tasks
    updated nothing on Home or Wallet at all. Both `HomeSummary` and
    `WalletSummary` had their `balance` field removed; Home/Wallet screens
    now read `context.watch<BalanceProvider>().balance` directly for
    `BalanceHeroCard` instead. `TasksProvider` takes a required
    `BalanceProvider` (passed in by `TasksScreen` via
    `context.read<BalanceProvider>()`) and calls `.credit(rate)` from both
    `completeCurrentTask` and `completeBonusSlot`, so watching an ad
    anywhere now actually raises the balance everywhere it's shown. Wallet's
    `WalletBreakdownCard` sub-breakdown (task/ad earnings vs referral
    commissions vs pending) is still separate static fake data and does not
    auto-update from this credit; full reconciliation of every figure is
    still the Phase 8 QA item this doc already flagged.
- `leader_row` — **built**, extracted from Home's weekly leaders card into
  a shared row (`leading`/`name`/optional `subtitle`/`trailing` widgets, plus
  `LeaderRow.iconBadge` and `LeaderRow.medalBadge` helpers). Reused by Home's
  `WeeklyLeadersCard` (one row per category, ₹ amount trailing) and Refer &
  Earn's `TopReferrersCard` (medal-ranked top 3, conversion-count trailing).
- `upgrade_banner` — **built**, moved from `screens/home/widgets/` into
  `shared/widgets/` now that Profile also shows it. Caller must omit it from
  the widget tree entirely for Premium users, not just visually hide it.
- `gradient_cta_button` — **built**, extracted into `shared/widgets/` once a
  3rd screen (About's "See payment proofs") needed the same full-width
  primary-gradient pill Welcome's "Create free account" and How It Works'
  closing CTA already duplicated. Now also used by FAQ's "Contact support".
  Takes just `label`/`onTap` — screens that need to conditionally hide it
  (e.g. How It Works omitting it for logged-in users) wrap it in their own
  `if`, same pattern as `upgrade_banner`.

---

## 7. Roadmap (build order)

This order front-loads the screens that establish shared components and
patterns, so later screens are mostly assembly, not new invention.

**Phase 1 — Foundation (done in earlier session)**
- Project setup, theme tokens, folder structure
- Home screen (balance hero, task progress ring, upgrade banner,
  leaderboard) — establishes the visual language for everything after

**Phase 2 — Core tabs (reuse Home's patterns directly)**
- [x] Tasks screen (task grid, featured task card, reset countdown)
- [x] `main_bottom_nav` + go_router `StatefulShellRoute` wiring the 5 tabs
  together (Wallet/Refer/Profile are stub screens until built below)
- [x] Wallet screen (balance breakdown, payment method card, recent activity)
- [x] Refer & Earn screen (referral link card, trigger-disclosure notice,
  stat chips, recent referrals list, this week's top-3 referrers card).
  Bonus-gift value for the #1 spot stays TBD (Section 2); the card states
  a bonus exists without inventing an amount.
  - [x] Addendum (2026-07-23, reward/referral rate update, see
    `REWARD_UPDATE_PLAN.md`): added `WeeklyBonusCard`
    (`screens/refer/widgets/weekly_bonus_card.dart`) surfacing the new
    weekly referral bonus (PROJECT.md 2). `ReferSummary` gained
    `isPremium`/`conversionsThisWeek`/`bonusAdSlotsAvailable` fields
    (`data/models/refer_summary.dart`, plus the `weeklyBonusConversionThreshold`
    (5) and `weeklyBonusAdSlots` (5) constants) to drive its 3 states: not
    Premium (locked, links to Upgrade), Premium with slots active this
    week (celebratory message), Premium still counting toward the
    threshold (progress bar). This is screen-scoped, not added to 6.3.
  - [x] Addendum (2026-07-23, same update): the +5 bonus ad slots are now
    watchable on the Tasks screen too, via a prototype-reviewed design
    (Option A of the reviewed prototypes: a separate gold-accented mini
    grid, not folded into the daily task queue). New `BonusAdSlot`/
    `BonusAdState` model (`data/models/bonus_ad_slot.dart`), deliberately
    not reusing `Task`/`TaskState`, since bonus slots have no `locked`
    state and are all simultaneously tappable in any order, unlike the
    daily grid's strict one-`next`-at-a-time queue. `TasksSummary` gained
    a `bonusSlots` list (defaults to empty; most weeks this section is
    simply absent) plus `bonusSlotsWatched`/`bonusSlotsRemaining` getters,
    and `earnedToday` now includes watched bonus slots' rate alongside
    completed daily tasks. New `BonusAdsSection`
    (`screens/tasks/widgets/bonus_ads_section.dart`) renders the banner and
    5-column gold grid below "Today's tasks" only when `bonusSlots` is
    non-empty; `TasksProvider.completeBonusSlot` mirrors
    `completeCurrentTask`'s local-simulation pattern (same
    `LEGAL-REVIEW`/AdMob `onUserEarnedReward()` TODO). `TasksService`'s
    fake data grants 5 available bonus slots, matching `ReferService`'s
    `bonusAdSlotsAvailable: 5` demo value on Refer & Earn.
- [x] Profile screen (account menu, support menu, tier badge, log out).
  Edit profile/Security & password/Payment details menu rows are
  placeholder no-ops until the consolidated Settings screen exists
  (Phase 4, PROJECT.md 3/6.1) — don't build separate destination screens
  for them before then.

**Phase 3 — Auth flow (needed before anything can be "logged in")**
- [x] Welcome screen (brand row, hero, dark live-stats strip — earner
  count marked `// TODO: replace with real data`, trust pills, 4-step how
  it works, sticky Create account/Log in CTAs). Wired as a separate
  pre-auth route stack (`/welcome`, `/register`, `/login`), not yet linked
  to the post-auth StatefulShellRoute — no redirect logic exists yet.
- [x] Register screen (+ phone_input component). Field order locked to
  name → phone → optional email → password → optional referral code
  (PROJECT.md 2). Send OTP button is disabled (no fake OTP fires) until
  name is non-empty and the phone number is exactly 10 digits — consent
  checkbox is present but does not currently gate the button, since that
  wasn't specified; flagging in case that's wanted. Pushes to a
  `/verify-phone` placeholder on success (real screen + `otp_row` land
  next). `AuthTextField`/`ConsentCheckbox` are screen-scoped under
  `screens/auth/widgets/`, not listed in 6.3 — only `phone_input`/`otp_row`
  were called out as the shared auth components, though Login/Forgot
  Password will likely reuse `AuthTextField` too.
- [x] Verify Phone screen (+ otp_row component). Pushed from Register with
  the 10-digit number as router `extra`, shown masked (`+91 98••••••10`).
  30-second resend countdown — visually disabled text during the count,
  becomes a tappable primary-colored "Resend OTP" link at zero. DND/
  deliverability `notice_card` (info variant) stays always visible, not
  behind a disclosure. Wrong-code/expired/lockout are stubbed as a private
  `_OtpError` enum with conditional text — nothing sets them yet since
  there's no backend; wiring lands with real OTP verification. Android SMS
  Retriever/User Consent auto-fill is a `// TODO`, left for a native-
  integration pass. On success, goes to `/home` (post-auth shell).
- [x] Login screen. Deliberately the simplest pre-auth screen — no back
  button (`automaticallyImplyLeading: false`), no stats/trust badges/
  upsell. Single identifier field validates against a 10-digit-mobile
  regex OR an email regex (no mode picker). Remember me + Forgot password?
  share one row. "Remember me" persists a real session token via
  `flutter_secure_storage` (`data/services/session_service.dart`), not just
  a pre-filled field — token is a `// TODO`-flagged fake until a real login
  API exists. `flutter_secure_storage` added to pubspec (pinned to ^10.3.1;
  ^9.x's `win32` constraint conflicted with `share_plus`). "Forgot
  password?" pushes to a `/forgot-password` placeholder (real screen next).
  On success, goes to `/home`.
- [x] Forgot Password screen (reuses phone_input + otp_row directly, no
  rebuild of either). One route, two sequential internal states — request
  (phone_input + Send OTP) and verify & reset (otp_row + new/confirm
  password + Update password) — toggled via `setState`, not a second route,
  so the AppBar's default back button always pops straight to Login
  regardless of which state is showing. New password requires 6+ chars and
  must match confirm; both are stubbed client-side since there's no backend
  yet. On successful update, `context.go('/login', extra: <message>)` —
  `LoginScreen` now takes an optional `successMessage` and shows it as a
  `SnackBar` after the first frame.
- [x] Wire go_router auth redirect logic across all of the above (see 6.1
  for the `AuthProvider`/`redirect`/`refreshListenable` details). Login and
  Verify Phone (registration's success path) both call
  `AuthProvider.login()` right before `context.go('/home')` — Verify Phone
  needs it too, not just Login, since without it a freshly-registered user
  would immediately get redirected back to `/welcome` by the new guard.
  Profile's log-out row is no longer a no-op — it calls
  `AuthProvider.logout()`, which clears the stored session token and
  relies on `refreshListenable` to bounce to `/welcome`.

**Phase 4 — Money-critical utility screens**
- [x] Withdraw screen. Built 2026-07-23, well after the rest of Phase 4;
  it had been left unchecked in this roadmap the whole time and Wallet's
  Withdraw button was still a no-op until now. Back button, "Available
  balance" line reading from the shared `BalanceProvider` (not a duplicate
  number), a `notice_card` (warn variant) stating the monthly payout cycle
  plus the actual next-1st-of-month date (`nextPayoutDate()` in
  `data/models/withdraw_summary.dart`, computed, not hardcoded: the
  upcoming 1st, or today if today already is the 1st), an amount field
  (`AuthTextField`) pre-filled with the full available balance but
  editable down to any smaller positive amount, and a `WithdrawMethodRow`
  selector (`screens/withdraw/widgets/`) between UPI (selected by default)
  and Bank transfer only, no PayPal, no Payoneer. A second conditional
  `notice_card` appears when UPI is selected and
  `WithdrawSummary.isUpiRecentlyAdded` (added under 24h ago) is true,
  covering the new ₹5,000 cap and possible auto-retry (Section 2). The
  submit button reads "Queue withdrawal for {date}", and both its label
  and the post-submit confirmation only ever say "queued"/"requested",
  never "instant" or "complete", since `WithdrawService.queueWithdrawal`
  is a fake stub (`// TODO` pointing at Phase 7's real
  `POST /withdrawals`) that doesn't actually deduct from the balance —
  a real withdrawal wouldn't clear it until the payout cycle actually
  runs. Closing helper text: "First-time withdrawals may need manual
  verification." Reached from Wallet's Withdraw button (previously a
  no-op) and Notifications' withdrawal-queued rows (previously deep-linked
  to a pre-filtered Transactions list since this screen didn't exist yet;
  now goes straight here). Routed at `/withdraw`, pushed outside the tab
  shell like Transactions/Upgrade/Settings.
- [x] Transactions screen (reuses `txn_row`, no new copy — see PROJECT.md
  6.3). Back button + AppBar title, All/Tasks/Referrals/Withdrawals filter
  pills (active = filled `AppColors.primary`, inactive = neutral outline),
  chronological list, infinite-scroll client-side pagination
  (`TransactionsProvider`, 8 per page, loads the next page automatically
  as the list nears its scroll end — no button, so a short filtered list
  never leaves dead space beneath it). Tasks filter groups both `task` and
  `ad` categories, matching how the bottom-nav Tasks tab covers both ad and
  in-app task rewards. Filtering/pagination are both client-side over the
  full fake history for now — `// TODO` in `transactions_provider.dart`
  flags moving both server-side once a real Laravel endpoint exists.
  `TransactionCategory` gained a `streakBonus` case (flame icon) with two
  fake rows, since Home's week-streak strip is now a tracked mechanic —
  the ₹ amount is illustrative fake data only, not a locked value (Section
  2's weekly-bonus amount is still TBD). Reached from Wallet's History
  button (`/transactions`, pushed outside the tab shell like the other
  push-only screens in 6.1).
- [x] Upgrade screen (Google Play Billing integration point). Back button,
  heading, dark gradient price card (`premiumSurfaceStart`/`End`, same
  tokens as `UpgradeBanner`) showing ₹49/month with a crown icon and the
  "cancel anytime — benefits continue until end of paid cycle" line, a
  "What you get" checklist (the 3 facts in Section 2's Premium-tier
  bullet: 30 tasks/day, same ₹/task rate, cancel-anytime-until-cycle-end),
  and two `notice_card` disclosures (billing/cancellation mechanics; the
  referral-linkage note — completing the purchase is what credits the
  referrer's ₹15, never signup alone). Reads subscription state from
  `ProfileProvider` (`UserProfile.tier`, same premium-check pattern as the
  Home/Profile upgrade banners) — Premium users see an active-status row
  instead of the Subscribe button, not just a disabled one. Subscribe
  button shows a "Coming soon" snackbar; real purchase flow is a
  `// TODO` pointing at Phase 7 (Google Play Billing needs a Play Console
  app listing first). No AdMob slot on this screen. Reached from Home's
  and Profile's `UpgradeBanner` and Profile's "Manage subscription" row
  (`/upgrade`, pushed outside the tab shell) — all three were no-op
  placeholders until now.
- [x] Settings screen (consolidated Profile/Security/Payment — PROJECT.md
  3 item 6, 6.1). One scrollable screen, `SingleChildScrollView` + `Column`
  (deliberately not `ListView` — a lazily-mounted sliver child's
  `GlobalKey.currentContext` is null until it scrolls into the viewport's
  cache extent, which silently broke deep-linking to the Payment section
  since it starts off-screen; a plain `Column` mounts all 3 sections
  immediately so the anchor keys always resolve), three `SettingsSectionCard`
  sections each keyed for `Scrollable.ensureVisible` deep-linking
  (`SettingsSection.profile`/`.security`/`.payment`, passed as router
  `extra`):
  - Profile: name + email fields, "Save changes".
  - Security: new password field + "Update password"; two-step
    verification `Switch` defaulting ON. Turning it ON is a single tap;
    turning it OFF opens a password-confirm `AlertDialog` first — more
    friction to disable a security feature than to enable one, per
    instruction. Both re-auth and the password/OTP check itself are
    `// TODO`s (no backend yet) — any non-empty password confirms for now.
  - Payment details: editable UPI ID field (`UpiIdField`) validated on
    every keystroke, not just on save — a typo caught only at withdrawal
    time is a much worse failure moment (this doc). Shows a "Default"
    pill and a green check / red alert icon once non-empty. Bank account
    row is display-only. `// LEGAL-REVIEW:` comment flags Section 3 item
    2 (PAN/TDS) at this section — no PAN field added until that's
    resolved by finance/legal.
  `SettingsProvider`/`SettingsService`/`SettingsData` are a separate fake
  data source from `ProfileProvider`/`UserProfile` (own name/email/UPI/
  bank/two-step shape), matching the existing per-screen fake-service
  convention rather than coupling Settings to Profile's summary shape.
  Reuses `AuthTextField` from `screens/auth/widgets/` directly (plain
  label+field widget, nothing auth-specific in its implementation) rather
  than rebuilding an identical field. Profile's four menu rows now push
  here with the matching anchor — except "Manage subscription", which
  goes to `/upgrade` instead since that's where subscription state
  actually lives, not Settings.

**Phase 5 — Trust & legal screens (mostly static content, low complexity)**
- [x] How It Works screen. Back button, intro line, `HowItWorksStepCard`
  (4-step numbered card, gradient number badges — distinct from Welcome's
  `HowItWorksList` teaser, which keeps its flat solid-color badges), two
  `TrustInfoCard`s (Refer & Earn's ₹15/purchase-triggered disclosure copied
  verbatim from Refer & Earn's `NoticeCard`; Go Premium's 3-bullet checklist
  copied verbatim from Upgrade's `PremiumChecklistCard`, so numbers never
  drift between screens). Closing "Create free account" `GradientCtaButton`
  is omitted entirely (not just hidden) for logged-in users, same pattern as
  `upgrade_banner`. No AdMob slot. Registered as a public route
  (`_publicPaths` in `app_router.dart`) since it's reachable both from
  Welcome (pre-login, `HowItWorksList`'s new `onSeeMore` chevron) and
  Profile's Support section (logged-in).
- [x] About screen. Back button, headline + intro body, 3 `AboutStatsRow`
  chips (founded year / earner count / states covered) and the intro
  paragraph both driven by a fake `AboutService`/`AboutProvider`
  (`AboutInfo.foundingYear`/`.earnerCount`/`.statesCovered`) rather than
  hardcoded numbers — founding year (2019) matches the "7 yrs paying" trust
  pill on Welcome, keep both in sync if either changes. Built "states
  covered" instead of the literal "countries" stat originally requested,
  since Section 1 locks this app to India-only/₹-only operation and a
  countries count would misrepresent it as international — flag if that
  reasoning is wrong. `CommitmentsCard` (Transparency / No pay-to-join /
  Fair rates / Real support). `PendingLegalCard` (originally a one-off
  `LegalPendingCard` here, generalized into `shared/widgets/` in the Terms/
  Privacy/Refund pass — see 6.3) — dashed warning-colored border (hand-
  rolled `CustomPainter` via `DashedBorderBox`, no dashed-border package in
  pubspec.yaml), each of legal entity name/registration number/registered
  address shown as "Pending", plus an explicit "do not invent" line;
  `// LEGAL-REVIEW:` comment above it in `about_screen.dart` referencing
  Section 3 item 3. Closing "See payment proofs" `GradientCtaButton` shows a
  "Coming soon" snackbar (Payment Proofs isn't built yet). No AdMob slot.
  Public route, reachable from Welcome's new "About us" footer link and
  Profile's Support section.
- [x] FAQ screen. Back button, three `FaqSection`s (Tasks & earning /
  Payments / Referrals & Premium) — each a plain non-tappable section label
  over an accordion card of `FaqEntry` question/answer pairs; expanding one
  question in a section collapses whichever other question in that same
  section was open (`FaqSection`'s own `_expandedIndex` state), sections are
  independent of each other. All copy is grounded in Section 2's locked
  business rules (task caps, ad-credit-on-completion-only, monthly UPI/bank
  payout, ₹15 purchase-triggered referral commission with refund reversal,
  Premium's 30 tasks/day) — no invented policies (e.g. no minimum-withdrawal
  FAQ, since no such rule exists yet). Closing "Contact support"
  `GradientCtaButton` now pushes `/contact` (updated once that screen
  existed — was a "Coming soon" snackbar before). No AdMob slot. Public
  route, reachable from Welcome's footer ("About us · FAQ · Contact") and
  Profile's Support section.
- [x] Contact screen. Back button, response-time intro line, a form (Name/
  Email/`TopicDropdown`/Message, all via `AuthTextField` — gained an
  optional `maxLines` param for the Message textarea, still living in
  `screens/auth/widgets/` and imported cross-folder same as Settings
  already does, not moved to `shared/widgets/`) and a "Send message"
  `GradientCtaButton`. No real backend, so Send validates locally (name/
  email-shape/message non-empty) and on success shows a fake "Message
  sent" snackbar and clears the form — `// TODO` in `contact_screen.dart`
  points at the real `POST /support/tickets` call for Phase 7.
  `ContactTopic` (`data/models/contact_topic.dart`) is the 5 exact topic
  options (Account access / Withdrawal issue / Ad not credited / Referral
  commission missing / Something else) with a doc-comment mapping each to
  the support queue it should route to once a backend exists — not wired,
  just structured so that mapping is a one-line addition later. Separately,
  a `ContactChannelsCard` ("Other ways to reach us") shows support@/
  payments@ as real tappable `mailto:` links via the new `url_launcher`
  dependency (added to pubspec.yaml — previously only pulled in
  transitively through `share_plus`, without the facade package itself);
  Android's manifest gained a `mailto:` `<queries>` entry so `launchUrl`
  can actually resolve an email app under Android 11+ package-visibility
  rules. No AdMob slot. Public route, reachable from Welcome's footer and
  Profile's Support section, and from FAQ's "Contact support" button.
- [x] Payment Proofs screen — the highest-priority trust surface in the app
  per the doc, since it makes direct payout claims. Back button, intro
  line, `SampleDataBanner` at the very top (dashed **red**, not warning-
  orange like About's `LegalPendingCard` — escalated because fabricated
  payment proof is a materially worse problem than a pending legal field;
  both now share the extracted `shared/widgets/dashed_border_box.dart`,
  pulled out of `LegalPendingCard` once a 2nd screen needed the same
  dashed-border treatment), `PayoutStatsStrip` (dark gradient, same
  "premium surface" language as `LiveStatsStrip`/`UpgradeBanner`; last-
  cycle total + earners paid), a repeating `ProofCard` list (green amount,
  masked username, method, date, "PAID" pill — same amount-color
  convention as `TxnRow`), a `TestimonialCard`, and a closing "Create free
  account" `GradientCtaButton` (omitted for logged-in users, same pattern
  as How It Works). No AdMob slot.
  `// LEGAL-REVIEW:` comment sits directly above the fake data in
  `PaymentProofsService` — Section 3 item 7 (new) — flagging that this is a
  Consumer Protection Act concern, not just a trust nicety, and that the
  warning banner must not be removed until real transaction data backs
  this screen. Public route, reachable from Welcome (its own prominent
  green-bordered "See real payment proofs" row under the trust pills, not
  folded into the small "About us · FAQ · Contact" footer, given its
  priority) and Profile's Support section; About's "See payment proofs"
  button, previously a "Coming soon" placeholder, now pushes here for real.
- [x] Terms, Privacy, Refund — all three built on the new shared
  `legal_screen` template (`shared/widgets/legal_screen.dart`, see 6.3):
  back button, "Last updated" date, a tappable table of contents that
  scrolls to the matching numbered section, plain-text numbered sections
  (no cards — deliberately not the marketing-page visual language, since
  this is legal copy). Screens live in `screens/legal/` per PROJECT.md
  6.2. No AdMob slot on any of the three.
  - Terms (14 sections) and Privacy (12 sections) both end with a
    Grievance Officer section rendered as `PendingLegalCard` (name/
    contact email/contact phone all "Pending") — `// LEGAL-REVIEW:`
    comments above each reference Section 3 item 4. Privacy also has a
    "Significant Data Fiduciary Status" section as a `PendingLegalCard`
    referencing Section 3 item 5 (DPDP Act classification unconfirmed).
    Terms' Referral Program section carries a `// LEGAL-REVIEW:` for
    Section 3 item 1 (Prize Chits Act review) directly above it.
  - Refund states plainly that EarnBucks is a real-money earning app, not
    a goods/services marketplace, so a traditional refund concept doesn't
    apply — the only place it does is Premium cancellation. That section
    uses the new `UpgradeCrossReference` widget
    (`screens/legal/widgets/upgrade_cross_reference.dart`) — a summary
    paragraph plus a tappable link to `/upgrade` — instead of duplicating
    Upgrade's cancellation copy, so the two pages can't drift out of sync.
  - Reachable from Profile's Support section (3 new rows) and, on Welcome,
    from the "Legal & support" sheet (Phase 6 addendum below — the two
    stacked footer link rows this section originally added were later
    collapsed into one bottom sheet).

**Phase 6 — Remaining utility screens**
- [x] Notifications screen. Header (default back button) with a "Mark all
  read" `TextButton` in the AppBar actions — disabled/grayed out once
  there's nothing unread, rather than always tappable. Body is a
  `NotificationRow` list (see 6.3) inside one card, covering all 4
  `NotificationType` cases (`data/models/notification_type.dart`) via fake
  data (`NotificationsService`/`NotificationsProvider`, same fake-now
  convention as everywhere else). Tapping a row calls
  `NotificationsProvider.markRead` then deep-links by type: task credit
  and withdrawal both push `/transactions` pre-filtered (`TransactionFilter
  .tasks`/`.withdrawals` — `TransactionsProvider`/`TransactionsScreen`
  gained an optional `initialFilter`, same `state.extra` pattern as
  Settings' `initialSection`) since a standalone Withdraw screen doesn't
  exist yet; referral and streak `context.go` to their tabs (`/refer`,
  `/home`) rather than pushing, since those are tabs, not push-only
  screens. Reachable from Profile's Notifications row, which was a no-op
  until now.
- [x] Support Tickets screen. Header (default back button), a "Raise a new
  ticket" `GradientCtaButton`, then a `SupportTicketRow` list inside one
  card (same list-in-a-card layout as Notifications) covering all 3
  `SupportTicketStatus` cases (`data/models/support_ticket.dart`) via fake
  data (`SupportService`/`SupportProvider`, same fake-now convention). Each
  row shows topic + `TicketStatusPill` (gray open / orange in-progress /
  green resolved), a truncated message snippet (`SupportTicket.snippet`,
  computed from the full `message`, not a separately stored field), and
  ticket ID + date. Tapping a row and tapping "Raise a new ticket" both
  open a `showModalBottomSheet` (`TicketDetailSheet`/`RaiseTicketSheet`)
  rather than a separate route — same pattern Settings'
  `ProfileAvatarPicker` already uses — since neither needs its own
  back-stack entry. `RaiseTicketSheet` reuses Contact's `TopicDropdown`
  directly (same 5 `ContactTopic` options, PROJECT.md Phase 5) plus an
  `AuthTextField` message field; on submit, `SupportProvider.raiseTicket`
  prepends the new Open-status ticket to the list. No AdMob slot. Reached
  from Profile's Support tickets row (`/support-tickets`, pushed outside
  the tab shell), previously a no-op.
- [x] Welcome screen footer redesign. The sticky CTA bar's two stacked
  footer link rows (About/FAQ/Contact at 13px, Terms/Privacy/Refund at
  11px below them — see the Phase 5 Contact/Terms/Privacy/Refund entries
  above) were collapsed into a single "Legal & support" ghost link that
  opens `LegalSupportSheet` (`screens/auth/widgets/legal_support_sheet.dart`)
  — a `showModalBottomSheet` listing all 6 pages, same sheet pattern
  Settings' `ProfileAvatarPicker` already uses. Frees the sticky bar down
  to just the two CTA buttons plus this one link, instead of 4 stacked
  rows. The bare `_FooterLinkRow` helper this replaced is gone from
  `welcome_screen.dart`. This was a UI-only change — nothing about "How it
  works" or the rest of the scroll content changed alongside it.

**Phase 7 — Backend integration**
- Replace fake service classes with real Laravel API calls (dio)
- Auth token handling, session persistence
- AdMob real ad unit wiring (currently placeholder)
- Google Play Billing real integration (currently placeholder)

**Phase 8 — Pre-launch pass**
- Resolve every item in Section 3 (compliance/legal placeholders)
- Confirm Google Play Billing unit economics with finance
- QA pass: every ₹ amount/rule matches Section 2 exactly, no screen
  contradicts another (e.g. Wallet balance vs Transactions must reconcile)

---

## 8. Instructions for Claude Code specifically

When asked to build a screen from this roadmap:

1. Check Section 2 (business rules) and Section 6.3 (shared components)
   before writing new logic — don't reinvent something that should be
   reused.
2. Match the design tokens in Section 5 — don't introduce new colors/fonts
   ad hoc.
3. If a request conflicts with Section 1 or Section 2 (e.g. "add PayPal" or
   "make withdrawals instant"), stop and flag the conflict rather than
   building it — these are locked decisions, not style choices.
4. Use fake service classes returning realistic data until told a real
   Laravel API endpoint exists for that feature.
5. After finishing a screen, note any new shared component it introduced so
   Section 6.3 can be updated.