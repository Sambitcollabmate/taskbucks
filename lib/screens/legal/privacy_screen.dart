import 'package:flutter/material.dart';

import '../../shared/widgets/legal_screen.dart';
import '../../shared/widgets/pending_legal_card.dart';

final _lastUpdated = DateTime(2026, 6, 1);

final _sections = [
  LegalSection.text(
    id: 'intro',
    heading: 'Introduction',
    paragraphs: [
      'This Privacy Policy explains what information EarnBucks collects, '
          'how we use it, and the choices you have. By using the app, you '
          'agree to the practices described here.',
    ],
  ),
  LegalSection.text(
    id: 'collect',
    heading: 'Information We Collect',
    paragraphs: [
      'We collect the information you give us directly — your name, '
          'mobile number, optional email, password, and payout details '
          '(UPI ID or bank account) — along with basic device and usage '
          'data needed to run the app, like task completion and ad-view '
          'events.',
    ],
  ),
  LegalSection.text(
    id: 'use',
    heading: 'How We Use Your Information',
    paragraphs: [
      'We use your information to create and secure your account, credit '
          'your task and referral earnings accurately, process your '
          'monthly payout, and communicate with you about your account or '
          'support requests.',
    ],
  ),
  LegalSection.text(
    id: 'share',
    heading: 'How We Share Your Information',
    paragraphs: [
      "We share information only where it's necessary to run the app: "
          'with Google Play Billing to process Premium subscriptions, '
          'with AdMob to serve and measure the rewarded video ads that '
          'fund task payouts, and with payment rails (UPI/bank) to send '
          "your monthly payout. We don't sell your personal information.",
    ],
  ),
  LegalSection.text(
    id: 'retention',
    heading: 'Data Retention',
    paragraphs: [
      'We keep your account and transaction information for as long as '
          'your account is active, and for a reasonable period after that '
          'to meet our legal, accounting, and fraud-prevention '
          'obligations.',
    ],
  ),
  LegalSection.text(
    id: 'rights',
    heading: 'Your Rights',
    paragraphs: [
      'You can request access to, correction of, or deletion of your '
          'personal information by contacting us (see the Contact '
          "screen). We'll respond within a reasonable time, subject to "
          "what we're legally required to retain.",
    ],
  ),
  LegalSection.text(
    id: 'security',
    heading: 'Data Security',
    paragraphs: [
      'We use industry-standard measures — including SSL encryption in '
          "transit — to protect your information. No system is "
          "completely secure, so we can't guarantee absolute security.",
    ],
  ),
  LegalSection.text(
    id: 'children',
    heading: "Children's Privacy",
    paragraphs: [
      "EarnBucks is not directed at anyone under 18. We don't knowingly "
          'collect personal information from minors.',
    ],
  ),
  LegalSection.text(
    id: 'third-party',
    heading: 'Third-Party Services',
    paragraphs: [
      'EarnBucks uses Google AdMob (rewarded video ads) and Google Play '
          'Billing (Premium subscriptions). These providers have their '
          'own privacy policies governing how they handle data collected '
          'through their services.',
    ],
  ),
  // LEGAL-REVIEW: Section 3 item 5 — whether the app qualifies as a
  // "Significant Data Fiduciary" under India's DPDP Act is unconfirmed and
  // affects this policy's content. Rendered as PendingLegalCard below; do
  // not state a status here until legal confirms it.
  LegalSection(
    id: 'sdf-status',
    heading: 'Significant Data Fiduciary Status',
    body: const PendingLegalCard(
      title: 'DPDP Act classification',
      fields: ['Significant Data Fiduciary status'],
      note: "Pending legal confirmation under India's Digital Personal "
          'Data Protection Act — do not state a status here until '
          'confirmed.',
    ),
  ),
  LegalSection.text(
    id: 'changes',
    heading: 'Changes to This Policy',
    paragraphs: [
      'We may update this Privacy Policy from time to time. We\'ll '
          'update the "Last updated" date above when we do.',
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
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalScreen(
      title: 'Privacy Policy',
      lastUpdated: _lastUpdated,
      tableOfContents: [
        for (final section in _sections)
          LegalTocEntry(id: section.id, label: section.heading),
      ],
      sections: _sections,
    );
  }
}
