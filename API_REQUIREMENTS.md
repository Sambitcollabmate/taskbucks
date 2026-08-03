# EarnBucks — Backend API Requirements

For the Laravel backend team. Auth is already built and working — listed here
only for reference/conventions. Everything else (Tasks, Wallet, Withdrawals,
Referrals, Notifications, Profile/Settings, Support, Trust) does not exist yet
and is what this doc specifies.

## Build order — module by module, not all at once

Build and hand off in this order. Each phase only depends on what came
before it, so frontend integration and backend review can happen
incrementally instead of one big-bang delivery.

1. **Profile & Settings** (§1) — no dependencies, foundational for everything
   that displays user identity/preferences.
2. **Wallet & Transactions** (§4, §5) — the ledger. Needs to exist before
   anything can credit or debit a balance.
3. **Tasks & Bonus Ads** (§3) — credits into the ledger from phase 2. Blocked
   on the AdMob SSV key decision (open item 1) before reward-crediting can be
   trusted; the `GET /v1/tasks` read side can still be built first.
4. **Premium / Billing** (§11) — needed before Referrals' weekly bonus logic
   (phase 5) can correctly check `is_premium`, and before the 25→30 daily
   cap actually differs by tier.
5. **Referrals** (§7) — depends on phases 2–4 (ledger, task-reward crediting,
   and premium tier all need to exist for commission/bonus rules to fire
   correctly).
6. **Withdrawals** (§6) — depends on phase 2's balance. Blocked on the payout
   gateway decision (open item 4) for the actual transfer; the queue/request
   endpoint can be built without it.
7. **Home Dashboard** (§2) — aggregates phases 3 and 5 (tasks + leaderboard),
   build after those exist.
8. **Notifications** (§8) — can start any time after phase 2, but is most
   useful once phases 3/5/6 exist to generate real notification events.
9. **Support** (§9) — independent, no blockers; can be built any time.
10. **Trust / Legal content** (§10) — `payment-proofs` specifically depends
    on phase 2's real transaction data existing (it's legally required to be
    non-fabricated), so build it last.

**Instructions for whoever is building this (even though this whole doc was
handed to you at once): do not build all modules in one pass.** Work through
the phases above in order, one at a time:

1. Build only the current phase's endpoints (routes, controllers, models/
   migrations, request validation, tests).
2. Confirm it works — run the relevant feature tests (mirror the existing
   `AuthFlowSmokeTest.php` pattern) and/or a manual Postman check.
3. **Commit that module on its own** (e.g. `feat: add wallet & transactions
   API (phase 2)`) — don't bundle multiple phases into one commit.
4. Report back what was built/tested for that phase before starting the next
   one.

Skip phases that are explicitly blocked on an open decision (see "Open
items" at the bottom) until that decision is made — build the next
unblocked phase instead and circle back.

## Conventions (inferred from the existing Auth module — keep consistent)

- Base path: `/api/v1/...`
- Auth: Laravel Sanctum bearer token — `Authorization: Bearer {token}`
- Response body: raw JSON per resource, **no** `{data: ...}` envelope (matches
  current `AuthController` responses)
- Field naming: `snake_case`
- Validation errors: Laravel default — `422` with
  `{"message": "...", "errors": {"field": ["..."]}}`
- Currency: integer/decimal rupees (₹), no cents/paise conversion needed —
  confirm smallest unit with backend (paise recommended to avoid float issues)
- All amounts, dates returned as strings the app already expects: ISO 8601
  timestamps

---

## 0. Auth (already implemented — no action needed)

`POST /v1/auth/register`, `resend-otp`, `verify-otp`, `login`,
`forgot-password/request`, `forgot-password/reset`, `logout`, `GET me`.

`User` fields already on the model: `id, name, mobile, email, referral_code,
referred_by, mobile_verified_at, tier (free|premium)`.

---

## 1. Profile & Settings

### `GET /v1/profile`
Returns the authenticated user's profile.
**Response:** `name, mobile, tier (free|premium), avatar_url`

### `PATCH /v1/profile`
**Params:** `name?, email?`

### `POST /v1/profile/avatar`
**Params:** `image` (multipart file upload)
**Response:** `avatar_url`

### `PATCH /v1/profile/password`
**Params:** `current_password, new_password, new_password_confirmation`

### `GET /v1/settings`
**Response:** `name, email, upi_id, is_upi_default, bank_account_masked,
two_step_enabled, earnings_push_enabled, account_push_enabled,
promotions_push_enabled, avatar_url`

### `PATCH /v1/settings/upi`
**Params:** `upi_id`
Note: business rule — UPI added within the last 24h is capped at ₹5,000
withdrawable for that window. Backend must stamp `upi_added_at` on change so
`GET /v1/withdrawals` can expose it.

### `PATCH /v1/settings/two-step`
**Params:** `enabled (bool)`
**Decided (2026-07-28):** stores the flag only, **no-op on login this
phase**. Confirmed the Flutter app has no OTP-after-password screen/route
anywhere — `login_screen.dart` goes straight to `/home` on success, and
`AuthProvider.login()` has no OTP state. `POST /v1/auth/login` stays
untouched. Revisit once the frontend actually builds a post-password OTP
screen to route to.

### Bank account — deferred, not building this phase
**Decided (2026-07-28):** no `PATCH /v1/settings/bank-account` endpoint this
phase. Confirmed there's no add/edit UI anywhere in the app — Settings shows
`bank_account_masked` as plain read-only text (contrast: UPI has a real
editable `UpiIdField` right next to it), and Withdraw only lets the user
*select* bank as a method without ever entering an account number. Ship
`PATCH /v1/settings/upi` only this phase; drop/hide `bank` as a selectable
withdrawal method (see §6) until a later release adds the input flow.

### `PATCH /v1/settings/push-preferences`
**Params:** `earnings_push_enabled?, account_push_enabled?,
promotions_push_enabled? (bools, any subset)`

### PAN/TDS (flagged, not yet confirmed by legal/finance)
No endpoint yet — hold off until threshold/requirement is confirmed
(PROJECT.md §3).

---

## 2. Home Dashboard

### `GET /v1/home`
**Response:**
```json
{
  "user_name": "string",
  "tasks_completed_today": 0,
  "daily_task_limit": 25,
  "is_premium": false,
  "week_progress": [
    { "date": "2026-07-27", "completed": 25, "limit": 25 }
  ],
  "weekly_leaders": [
    { "rank": 1, "name": "string", "amount": "1250.00", "category": "top_referrer|top_ad_watcher" }
  ]
}
```
`daily_task_limit` is 25 (free) / 30 (premium). `week_progress` covers the
current Sun–Sat cycle for the streak calendar.

---

## 3. Tasks & Bonus Ads

### `GET /v1/tasks`
Today's task queue, sequential unlock.
**Response:**
```json
{
  "tasks": [
    { "id": 1, "state": "done|next|locked", "rate": "100.00" }
  ],
  "reset_at": "2026-07-29T00:00:00+05:30",
  "bonus_slots": [
    { "id": 1, "state": "available|watched", "rate": "100.00" }
  ]
}
```
`bonus_slots` only present in weeks the user earned the +5 weekly referral
bonus (see §5); empty most weeks.

### `POST /v1/tasks/{id}/complete`
**Critical:** must NOT trust the client. Reward (₹100/task, same for free and
premium) is only credited after verifying the AdMob **Server-Side
Verification (SSV)** callback for that ad impression — a client-only
`onUserEarnedReward()` call must never be sufficient (flagged in
`tasks_provider.dart`/PROJECT.md as a legal/anti-fraud requirement).
**Params:** `ad_transaction_id` or whatever identifier ties this call to the
AdMob SSV callback the backend receives separately, plus a client-generated
`idempotency_key` (UUID).
⚠️ **Gap:** must be idempotent — a retried request (flaky network, double
tap) must not double-credit ₹100. Dedupe on `idempotency_key` and/or
`ad_transaction_id` so a repeat call returns the original result instead of
crediting again.
**Response:** updated `tasks` array + `wallet_balance`.

### `POST /v1/ads/ssv-callback`
Server-side callback endpoint AdMob calls directly (not from the app) to
verify a rewarded-ad completion, using `ADMOB_SERVER_SIDE_VERIFICATION_KEY`.
Needed before `/v1/tasks/{id}/complete` can be trusted.

### `POST /v1/bonus-slots/{id}/complete`
Same reward/credit rules as tasks, for the +5 weekly bonus ad slots —
including the same `idempotency_key` requirement above.

---

## 4. Wallet

### `GET /v1/wallet`
**Response:**
```json
{
  "breakdown": {
    "task_ad_earnings": "2500.00",
    "referral_commissions": "375.00",
    "bonus_rewards": "500.00"
  },
  "payment_method": { "upi_id": "user@upi", "is_default": true },
  "recent_activity": [ /* last 5 Transaction objects, see §5 */ ]
}
```
Balance shown here is "earned" balance — it should NOT be reduced by a queued
withdrawal until the actual monthly payout cycle runs (see §6).

---

## 5. Transactions

### `GET /v1/transactions`
Full history. **Params (query):** `page?, per_page?, type? (credit|debit),
category? (task|ad|referral|withdrawal|streak_bonus|premium_renewal|other)`
**Response (paginated):**
```json
{
  "data": [
    { "id": 1, "title": "string", "date": "2026-07-27T10:00:00+05:30",
      "amount": "100.00", "type": "credit", "category": "task" }
  ],
  "meta": { "current_page": 1, "last_page": 3, "total": 45 }
}
```
(Frontend currently filters/paginates client-side over fake data — real
backend should support server-side pagination since this list grows
unbounded.)

---

## 6. Withdrawals

### `GET /v1/withdrawals`
**Response:** `upi_id, upi_added_at, bank_account_masked, available_balance,
next_payout_date` (always the 1st of next month, or today if today is the
1st)

### `POST /v1/withdrawals`
**Params:** `amount, method (upi)` — **`bank` dropped for now** (2026-07-28
decision, see §1): no add/edit UI exists for bank accounts in the app, so
there's no way for a user to supply one yet. Re-add `bank` once that input
flow is built.
**Business rules to enforce server-side:**
- Withdrawals only ever *process* on the 1st of the month — this call queues
  a request, doesn't transfer funds immediately.
- If `upi_added_at` is within the last 24h, cap this request at ₹5,000.
- No PayPal/Payoneer — UPI only for now.
**Response:** the queued withdrawal record + updated `available_balance`
(reflecting the hold, since a real balance shouldn't show as available once
queued, but shouldn't be "paid" until the 1st actually runs).

---

## 7. Referrals

### `GET /v1/refer`
**Response:**
```json
{
  "referral_code": "ABC123XYZ456",
  "total_referred": 12,
  "total_converted": 8,
  "total_earned": "1000.00",
  "is_premium": false,
  "conversions_this_week": 3,
  "bonus_ad_slots_available": 5,
  "recent_referrals": [
    { "id": 1, "masked_username": "j***n", "date": "2026-07-20",
      "status": "converted|pending", "amount": "125.00" }
  ],
  "top_referrers": [
    { "rank": 1, "masked_username": "a***z", "conversions": 15 }
  ]
}
```

**Business rules to enforce server-side (PROJECT.md §2, updated 2026-07-23):**
- Referral commission is a flat **₹125**, credited **only** when the referred
  user completes the ₹49 Premium purchase — never on signup alone.
- Commission is reversible/charged-back if the referred user refunds their
  Premium purchase.
- **Weekly referral bonus**, tracked on a Sunday–Saturday cycle:
  - Referrer must themselves hold an active Premium subscription during that
    week to qualify at all. Free-tier referrers still earn the ₹125/conversion
    commission normally, but never the bonus slots.
  - If ≥5 referred users complete their Premium purchase within the same
    Sun–Sat week, referrer gets a flat **+5 bonus ad-watch slots** (₹100
    each, same as normal tasks). Does not tier above 5 — 7 or 10 conversions
    in a week still only grants +5 slots; the ₹125/conversion commission
    itself is uncapped.
  - Conversions don't roll over/combine across week boundaries to hit the
    threshold.
  - Bonus slots are separate from — and don't replace — the daily task cap,
    and don't affect the separate top-referrer/top-ad-watcher weekly
    leaderboard bonus (amount still TBD).

---

## 8. Notifications

### `GET /v1/notifications`
⚠️ Add pagination — this list grows unbounded over a user's lifetime, same
concern as Transactions.
**Params (query):** `page?, per_page?`
**Response (paginated):**
```json
{
  "data": [
    { "id": 1, "type": "task_credited|referral_converted|withdrawal_queued|streak_bonus|new_login_detected|premium_promo",
      "title": "string", "body": "string",
      "timestamp": "2026-07-27T10:00:00+05:30", "is_read": false }
  ],
  "meta": { "current_page": 1, "last_page": 3, "total": 45 },
  "unread_count": 4
}
```
`unread_count` is needed for the notification-bell badge and should reflect
the total unread count, not just unread-on-this-page.

### `PATCH /v1/notifications/{id}/read`
Marks a single notification read.

### `PATCH /v1/notifications/read-all`
Marks all of the user's notifications read in one call (bulk action for a
"mark all as read" button).

### `POST /v1/devices`
Register an FCM device token for push delivery (FCM env vars not yet
configured — see backend reply, this needs setup before push actually works).
**Params:** `fcm_token, platform (android|ios)`

---

## 9. Support

### `GET /v1/support/tickets`
⚠️ Add pagination — same unbounded-growth concern as Transactions and
Notifications.
**Params (query):** `page?, per_page?`
**Response (paginated):**
```json
{
  "data": [
    { "id": 1, "topic": "account_access|withdrawal_issue|ad_not_credited|referral_commission_missing|something_else",
      "status": "open|in_progress|resolved", "date": "2026-07-20",
      "messages": [
        { "text": "string", "timestamp": "...", "is_from_user": true, "author_name": null }
      ]
    }
  ],
  "meta": { "current_page": 1, "last_page": 2, "total": 12 }
}
```

### `POST /v1/support/tickets`
**Params:** `topic, message`

### `POST /v1/support/tickets/{id}/reply`
**Params:** `text`

---

## 10. Trust / Legal content

### `GET /v1/about`
**Response:** `founding_year, earner_count, states_covered`

### `GET /v1/payment-proofs`
⚠️ **Legal-flagged** (PROJECT.md): this must be backed by real aggregated
transaction data, not fabricated numbers, before launch.
**Response:**
```json
{
  "last_cycle_total": "500000.00",
  "total_earners": 1200,
  "proofs": [
    { "amount": "2500.00", "masked_username": "r***t", "method": "UPI",
      "date": "2026-07-01" }
  ],
  "testimonial_quote": "string",
  "testimonial_name": "string"
}
```

### FAQ / How-it-works / Terms / Privacy / Refund
Currently static screens in the app — no endpoint needed unless you want
these CMS-editable later. Not required for launch.

---

## 11. Premium / Billing

Subscription purchase itself happens client-side via Google Play Billing —
backend just needs to receive and verify the purchase, and flip `tier`.

### `POST /v1/billing/verify-purchase`
**Params:** `purchase_token, product_id` (from Google Play Billing library)
Backend verifies with Google Play Developer API, then sets `user.tier =
premium`, applies the resulting daily cap change (25→30) and grants Premium
eligibility for the weekly referral bonus.
**Response:** updated `tier`.

### `POST /v1/billing/cancel`
Marks subscription as cancel-pending; benefits continue until the end of the
current paid cycle, then `tier` reverts to `free` (likely via a scheduled job
checking Google Play subscription status, not this call directly).

---

## Open items / needs a decision before building

1. **AdMob SSV key** (`ADMOB_SERVER_SIDE_VERIFICATION_KEY`) — blank in
   `.env.example`, needed before Tasks/Bonus-slots reward crediting can be
   trusted.
2. **MSG91 OTP** already wired for Auth, blank pending DLT registration — no
   action needed for other modules.
3. **FCM push** — not configured at all; needed for §8 to actually deliver
   pushes (device registration endpoint can still be built now).
4. **Payment gateway for withdrawals** — no service class exists yet; need to
   confirm which payout rail (Razorpay Payouts, Cashfree, etc.) before
   building §6's actual transfer logic (the queue/request endpoint can be
   built without it).
5. **PAN/TDS collection** — not yet confirmed by finance/legal; no field/
   endpoint until confirmed.
6. **Pagination style** for `GET /v1/transactions`, `GET /v1/notifications`,
   `GET /v1/support/tickets` — proposed Laravel-default `data`/`meta` shape
   above; confirm before frontend integrates.
7. ~~Two-step (2FA) login flow~~ — **resolved 2026-07-28**: no-op for now,
   see §1. Revisit once the frontend builds a post-password OTP screen.
8. ~~Bank account withdrawals~~ — **resolved 2026-07-28**: deferred, UPI only
   for this phase, see §1 and §6. Revisit once an add/edit bank UI exists.
9. **Reward idempotency** — `POST /v1/tasks/{id}/complete` and
   `POST /v1/bonus-slots/{id}/complete` need an idempotency key to prevent
   double-crediting on retried requests (see §3).
