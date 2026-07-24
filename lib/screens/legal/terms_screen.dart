import 'package:flutter/material.dart';

import '../../shared/widgets/legal_screen.dart';
import '../../shared/widgets/pending_legal_card.dart';

final _lastUpdated = DateTime(2026, 6, 1);

final _sections = [
  LegalSection.text(
    id: 'acceptance',
    heading: 'Acceptance of Terms',
    paragraphs: [
      'By creating an account or using EarnBucks in any way, you agree to '
          "be bound by these Terms of Service. If you don't agree, please "
          "don't use the app.",
    ],
  ),
  LegalSection.text(
    id: 'eligibility',
    heading: 'Eligibility',
    paragraphs: [
      'You must be at least 18 years old and a resident of India to use '
          'EarnBucks. Each person may hold only one account — creating '
          'multiple accounts to claim extra tasks, referral bonuses, or '
          'Premium benefits is not allowed and may result in your accounts '
          'being suspended.',
    ],
  ),
  LegalSection.text(
    id: 'account',
    heading: 'Account Registration & Security',
    paragraphs: [
      "Registration is phone-number-first: you'll verify your mobile "
          "number with a one-time password before you can use the app. "
          "You're responsible for keeping your account credentials secure "
          'and for all activity that happens under your account.',
    ],
  ),
  LegalSection.text(
    id: 'earning',
    heading: 'How Earning Works',
    paragraphs: [
      'Free accounts can complete up to 25 video-ad tasks a day; Premium '
          'accounts get 30, both at the same fixed ₹ rate per task. Your '
          "daily task count resets at midnight and unused tasks don't "
          'carry over. Credit for a task is only given once its video ad '
          'has played to completion — opening or skipping an ad early '
          "doesn't earn a reward.",
    ],
  ),
  // LEGAL-REVIEW: Section 3 item 1 — the purchase-triggered referral
  // commission structure below needs legal review against India's Prize
  // Chits and Money Circulation Schemes (Banning) Act before launch.
  LegalSection.text(
    id: 'referrals',
    heading: 'Referral Program',
    paragraphs: [
      'You earn ₹125 for each person you refer, but only once they '
          'complete the ₹49 Premium purchase — never for signing up alone. '
          'A referral shows as pending until that payment clears. If the '
          "referred purchase is later refunded or charged back, the ₹125 "
          "commission is reversed, even if it's already been included in "
          'a payout.',
      'Premium members who get 5 or more referrals converting to Premium '
          'within the same Sunday–Saturday week additionally earn +5 '
          'bonus ad-watch slots, active the following week. Only the week '
          "the referred purchase completes counts toward this, not the "
          'week of signup, and each week is evaluated independently, '
          'with no partial credit carried forward from a week that falls '
          'short of 5.',
    ],
  ),
  LegalSection.text(
    id: 'premium',
    heading: 'Premium Subscription',
    paragraphs: [
      'Premium costs ₹49/month, billed through Google Play Billing. It '
          'grants 30 tasks/day at the same ₹/task rate as the free tier — '
          'never a reduced payout per task. You can cancel anytime from '
          'Profile → Manage subscription; your Premium benefits continue '
          'until the end of the current paid cycle.',
    ],
  ),
  LegalSection.text(
    id: 'payments',
    heading: 'Payments & Withdrawals',
    paragraphs: [
      'Withdrawals are processed once a month, on the 1st, to a UPI ID or '
          "verified bank account you provide — we don't support PayPal, "
          "Payoneer, or any on-demand withdrawal. It's your responsibility "
          'to keep your payout details accurate and up to date in '
          'Settings.',
    ],
  ),
  LegalSection.text(
    id: 'conduct',
    heading: 'Prohibited Conduct',
    paragraphs: [
      'You may not use bots, emulators, click farms, or any other '
          'automated or fraudulent method to generate task or referral '
          'activity; create more than one account; or attempt to '
          "interfere with the app's ad-crediting or payout systems. We may "
          'suspend or terminate accounts that violate this section, and '
          'may withhold or reverse any earnings obtained through '
          'prohibited conduct.',
    ],
  ),
  LegalSection.text(
    id: 'ip',
    heading: 'Intellectual Property',
    paragraphs: [
      'The EarnBucks app, its branding, and its content are owned by us '
          'and our licensors. You may not copy, modify, or redistribute '
          'any part of the app without our written permission.',
    ],
  ),
  LegalSection.text(
    id: 'liability',
    heading: 'Limitation of Liability',
    paragraphs: [
      "EarnBucks is provided on an \"as is\" basis. To the maximum extent "
          "permitted by law, we aren't liable for indirect, incidental, or "
          'consequential damages arising from your use of the app, '
          'including losses related to task availability, ad delivery, or '
          'payout timing.',
    ],
  ),
  LegalSection.text(
    id: 'termination',
    heading: 'Termination',
    paragraphs: [
      'You may stop using EarnBucks and close your account at any time. '
          'We may suspend or terminate your account for violating these '
          'Terms, including the Prohibited Conduct section above.',
    ],
  ),
  LegalSection.text(
    id: 'law',
    heading: 'Governing Law',
    paragraphs: [
      'These Terms are governed by the laws of India, and any dispute '
          'arising from them is subject to the exclusive jurisdiction of '
          'the competent courts in India.',
    ],
  ),
  LegalSection.text(
    id: 'changes',
    heading: 'Changes to These Terms',
    paragraphs: [
      'We may update these Terms from time to time. Continuing to use '
          'EarnBucks after a change takes effect means you accept the '
          'updated Terms.',
    ],
  ),
  // LEGAL-REVIEW: Section 3 item 4 — Grievance Officer name/contact is not
  // yet designated. Rendered as PendingLegalCard below; do not fill this
  // in with an invented name or contact detail.
  LegalSection(
    id: 'grievance',
    heading: 'Grievance Officer',
    body: const PendingLegalCard(
      title: 'Grievance Officer',
      fields: ['Name', 'Contact email', 'Contact phone'],
      note: "Pending legal designation, required under India's IT Rules — "
          'do not invent a name or contact detail here.',
    ),
  ),
];

/// Legal page (PROJECT.md Phase 5, 6.2) built on the shared `LegalScreen`
/// template. Reachable from Welcome's footer and Profile's Support
/// section, same public-route pattern as the trust screens. No AdMob slot.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalScreen(
      title: 'Terms of Service',
      lastUpdated: _lastUpdated,
      tableOfContents: [
        for (final section in _sections)
          LegalTocEntry(id: section.id, label: section.heading),
      ],
      sections: _sections,
    );
  }
}
