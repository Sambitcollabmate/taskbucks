import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import 'widgets/faq_section.dart';

/// Trust page (PROJECT.md Phase 5) — reachable from Welcome and Profile,
/// same as `/how-it-works` and `/about`. No AdMob slot — trust/legal pages
/// don't carry ads (PROJECT.md pattern).
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tasksFaq = [
      FaqEntry(l10n.faqQ1, l10n.faqA1),
      FaqEntry(l10n.faqQ2, l10n.faqA2),
      FaqEntry(l10n.faqQ3, l10n.faqA3),
      FaqEntry(l10n.faqQ4, l10n.faqA4),
      FaqEntry(l10n.faqQ5, l10n.faqA5),
    ];
    final paymentsFaq = [
      FaqEntry(l10n.faqQ6, l10n.faqA6),
      FaqEntry(l10n.faqQ7, l10n.faqA7),
      FaqEntry(l10n.faqQ8, l10n.faqA8),
      FaqEntry(l10n.faqQ9, l10n.faqA9),
    ];
    final referralsFaq = [
      FaqEntry(l10n.faqQ10, l10n.faqA10),
      FaqEntry(l10n.faqQ11, l10n.faqA11),
      FaqEntry(l10n.faqQ12, l10n.faqA12),
      FaqEntry(l10n.faqQ13, l10n.faqA13),
      FaqEntry(l10n.faqQ14, l10n.faqA14),
      FaqEntry(l10n.faqQ15, l10n.faqA15),
      FaqEntry(l10n.faqQ16, l10n.faqA16),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(l10n.faqTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            FaqSection(title: l10n.faqSectionTasks, entries: tasksFaq),
            const SizedBox(height: 20),
            FaqSection(title: l10n.faqSectionPayments, entries: paymentsFaq),
            const SizedBox(height: 20),
            FaqSection(title: l10n.faqSectionReferrals, entries: referralsFaq),
            const SizedBox(height: 28),
            GradientCtaButton(
              label: l10n.contactSupportButton,
              onTap: () => context.push('/contact'),
            ),
          ],
        ),
      ),
    );
  }
}
