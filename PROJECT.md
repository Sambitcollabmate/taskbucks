# taskbucks.in — Flutter App Build Instructions

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
- Task reward: fixed ₹ rate per completed task (rate is data-driven, not
  hardcoded — see data model in Section 4).
- Ads are AdMob Rewarded Video, non-skippable. Credit fires only on
  `onUserEarnedReward()`, never on tap/open.
- Referral commission: ₹15 flat, credited **only** when the referred user
  completes the ₹49 Premium purchase — never on signup alone. Shows as
  "pending" until payment clears. Reversed (deducted from balance, even a
  future payout) if the referred purchase is refunded/charged back.
- Withdrawals: processed once a month, on the 1st, to UPI or verified bank
  account only. No PayPal, no Payoneer, no on-demand withdrawal.
- Weekly bonus: top referrer and top ad-watcher each get a bonus gift (exact
  mechanic TBD — flag as open item, don't invent a value).
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

A separate, disconnected pre-auth stack now also exists: `/welcome` (real
screen, and the router's actual `initialLocation`), `/register` and
`/login` (placeholders, pushed from Welcome's two CTAs). There is no
redirect logic between the two stacks yet — reaching the tab bar today
means manually navigating there (e.g. editing `initialLocation` back to
`/home` for dev purposes); that wiring is the last item in Phase 3.

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
  shared/
    widgets/          (components reused across 3+ screens — see 6.3)
```

### 6.3 Shared components to build once (do not duplicate per-screen)

- `txn_row` — **built**, first used on Wallet's recent activity list. Still
  needed on Transactions and Notifications — amount color convention (green
  credit / red debit) must match exactly in all three, don't fork per-screen
  copies.
- `legal_screen` — one shared template for Terms, Privacy, Refund (plain
  text, numbered headings, no cards).
- `notice_card` (info / warn variants) — **built**, first used on Tasks'
  non-skippable-ads notice, now also used on Wallet's payout-cycle notice
  (warn variant). Still needed for Refer & Earn's trigger-disclosure and
  Withdraw's new-UPI warning.
- `phone_input` — compound +91-prefix input, reused in Register, Login,
  Forgot Password.
- `otp_row` — 6-box OTP input, reused in Verify Phone and Forgot Password.
- `main_bottom_nav` — **built**, the 5-tab bar (Home, Tasks, Wallet, Refer,
  Profile). Wired into a go_router `StatefulShellRoute.indexedStack` (see
  `core/router/app_router.dart`) so it persists across tab switches and each
  tab keeps its own state.
- `balance_hero_card` — **built**, gradient balance card reused on Home and
  Wallet. Action buttons (icon/label/onTap) are configurable per screen —
  Home uses Wallet/Refer & earn, Wallet uses Withdraw/History.
- `leader_row` — **built**, extracted from Home's weekly leaders card into
  a shared row (`leading`/`name`/optional `subtitle`/`trailing` widgets, plus
  `LeaderRow.iconBadge` and `LeaderRow.medalBadge` helpers). Reused by Home's
  `WeeklyLeadersCard` (one row per category, ₹ amount trailing) and Refer &
  Earn's `TopReferrersCard` (medal-ranked top 3, conversion-count trailing).
- `upgrade_banner` — **built**, moved from `screens/home/widgets/` into
  `shared/widgets/` now that Profile also shows it. Caller must omit it from
  the widget tree entirely for Premium users, not just visually hide it.

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
  Bonus-gift value for the #1 spot stays TBD (Section 2) — the card states
  a bonus exists without inventing an amount.
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
- Register screen (+ phone_input component)
- Verify Phone screen (+ otp_row component)
- Login screen
- Forgot Password screen (reuses phone_input + otp_row)
- Wire go_router auth redirect logic across all of the above

**Phase 4 — Money-critical utility screens**
- Withdraw screen
- Transactions screen (+ txn_row component)
- Upgrade screen (Google Play Billing integration point)
- Settings screen (consolidated Profile/Security/Payment)

**Phase 5 — Trust & legal screens (mostly static content, low complexity)**
- How It Works, About, FAQ, Contact, Payment Proofs
- Terms, Privacy, Refund (+ legal_screen shared template)

**Phase 6 — Remaining utility screens**
- Notifications screen
- Support Tickets screen

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