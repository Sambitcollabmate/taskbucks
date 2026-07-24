import 'package:flutter/material.dart';

import '../../shared/widgets/legal_screen.dart';
import 'widgets/upgrade_cross_reference.dart';

final _lastUpdated = DateTime(2026, 6, 1);

final _sections = [
  LegalSection.text(
    id: 'overview',
    heading: 'Overview',
    paragraphs: [
      "EarnBucks is a real-money earning app, not a marketplace for goods "
          "or services — there's no product purchase to return, so a "
          "traditional \"refund\" policy doesn't apply the way it would "
          'for a retail app. This page explains the one place a '
          'refund-like concept does apply: Premium subscription billing.',
    ],
  ),
  LegalSection(
    id: 'premium-cancellation',
    heading: 'Premium Subscription Cancellation',
    body: const UpgradeCrossReference(
      message: 'Premium is billed monthly through Google Play Billing at '
          "₹49/month. You can cancel anytime — your access continues "
          "until the end of the paid cycle you've already paid for, and "
          'Google Play does not prorate a refund for the remaining days '
          'in that cycle. The full cancellation steps and billing '
          'mechanics live on the Upgrade screen, so they only need to be '
          'maintained in one place.',
    ),
  ),
  LegalSection.text(
    id: 'no-refund-earnings',
    heading: 'No Refunds on Task or Referral Earnings',
    paragraphs: [
      "Task and referral earnings you've been paid are final. The one "
          'exception is referral commission reversal: if a referred '
          "user's Premium purchase is later refunded or charged back by "
          "Google, the ₹125 commission tied to that purchase is deducted "
          "from your balance, even if it's already part of a completed "
          'payout.',
    ],
  ),
  LegalSection.text(
    id: 'google-play-disputes',
    heading: 'Google Play Billing Disputes',
    paragraphs: [
      "Because Premium is billed through Google Play, we don't process "
          'the ₹49 charge or its refund directly. If you believe you '
          "were charged incorrectly, request a refund through Google "
          "Play's own refund process — Google's policies govern whether "
          'that request is approved.',
    ],
  ),
  LegalSection.text(
    id: 'contact',
    heading: 'Questions About This Policy',
    paragraphs: [
      "If anything here is unclear, reach out — see the Contact screen "
          'for our support email and expected response time.',
    ],
  ),
];

/// Legal page (PROJECT.md Phase 5, 6.2) built on the shared `LegalScreen`
/// template. Per PROJECT.md Section 2, EarnBucks has no purchased-good
/// refund concept — the only place "refund" applies is Premium
/// cancellation, which this cross-references from the Upgrade screen
/// rather than duplicating (`UpgradeCrossReference`). Reachable from
/// Welcome's footer and Profile's Support section, same public-route
/// pattern as the trust screens. No AdMob slot.
class RefundScreen extends StatelessWidget {
  const RefundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalScreen(
      title: 'Refund Policy',
      lastUpdated: _lastUpdated,
      tableOfContents: [
        for (final section in _sections)
          LegalTocEntry(id: section.id, label: section.heading),
      ],
      sections: _sections,
    );
  }
}
