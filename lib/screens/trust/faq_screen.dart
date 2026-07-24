import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import 'widgets/faq_section.dart';

const _tasksFaq = [
  FaqEntry(
    'How many tasks can I do per day?',
    'Free accounts get 25 video-ad tasks a day; Premium members get 30 — '
        'both at the same ₹/task rate. Unused tasks don\'t carry over to '
        'the next day.',
  ),
  FaqEntry(
    'When do my daily tasks reset?',
    "At midnight, every day. Whatever's left of today's cap disappears — "
        "there's no rollover.",
  ),
  FaqEntry(
    "Why didn't my task credit after I watched the ad?",
    'Credit only fires once the ad finishes playing to the end — not on '
        'tap or open. Closing or skipping early means no credit for that '
        'task.',
  ),
  FaqEntry(
    'Can I get more tasks by using multiple accounts?',
    'No — each phone number gets one account, and using multiple accounts '
        'is against our terms.',
  ),
];

const _paymentsFaq = [
  FaqEntry(
    'When do I get paid?',
    "Withdrawals are processed once a month, on the 1st, straight to your "
        "UPI ID or a verified bank account.",
  ),
  FaqEntry(
    'Can I withdraw whenever I want?',
    "Not right now — payouts are monthly only, there's no on-demand "
        'withdrawal.',
  ),
  FaqEntry(
    'Which payment methods do you support?',
    'UPI and verified bank account transfer only — no PayPal, no wallets, '
        'no other payout methods.',
  ),
  FaqEntry(
    'What if I have the wrong UPI ID saved?',
    "Payouts go to whatever's saved in Settings, so double-check it before "
        'the 1st — a typo means a delayed payout while our team helps you '
        'fix it.',
  ),
];

const _referralsFaq = [
  FaqEntry(
    'How much do I earn per referral?',
    '₹125 flat, credited only when the person you referred completes the '
        '₹49 Premium purchase — never for signing up alone.',
  ),
  FaqEntry(
    'Why is my referral still showing as "pending"?',
    "It stays pending until your referral's Premium payment clears. Once "
        "it does, the ₹125 credits automatically.",
  ),
  FaqEntry(
    'What does Premium include?',
    '30 tasks/day instead of 25, at the same ₹/task rate — never a '
        'smaller cut per task.',
  ),
  FaqEntry(
    'Can I cancel Premium anytime?',
    'Yes, from Profile → Manage subscription. Your benefits continue '
        'until the end of the paid cycle, even after you cancel.',
  ),
  FaqEntry(
    "What happens if my referral's Premium purchase is refunded?",
    "The ₹125 commission is reversed — deducted from your balance, even "
        "from a future payout if it's already been paid out.",
  ),
  FaqEntry(
    'What is the weekly referral bonus?',
    'Premium members who get 5 or more referrals converting to Premium '
        'within the same Sunday–Saturday week earn +5 bonus ad slots, '
        "active the following week. It's gated on you holding Premium "
        "yourself. Free-tier accounts still earn the ₹125 commission, "
        'just never this bonus.',
  ),
  FaqEntry(
    'Does it matter when my referral signed up, or when they went Premium?',
    "Only the week their Premium purchase lands counts toward your 5. "
        "Signup timing doesn't matter, and each week is judged on its own. "
        "If 4 convert one week and a 5th converts the next, neither week "
        'reaches 5 and no bonus fires for either.',
  ),
];

/// Trust page (PROJECT.md Phase 5) — reachable from Welcome and Profile,
/// same as `/how-it-works` and `/about`. No AdMob slot — trust/legal pages
/// don't carry ads (PROJECT.md pattern).
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('FAQ'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            const FaqSection(title: 'Tasks & earning', entries: _tasksFaq),
            const SizedBox(height: 20),
            const FaqSection(title: 'Payments', entries: _paymentsFaq),
            const SizedBox(height: 20),
            const FaqSection(title: 'Referrals & Premium', entries: _referralsFaq),
            const SizedBox(height: 28),
            GradientCtaButton(
              label: 'Contact support',
              onTap: () => context.push('/contact'),
            ),
          ],
        ),
      ),
    );
  }
}
