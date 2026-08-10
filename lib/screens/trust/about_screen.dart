import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/about_provider.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import '../../shared/widgets/pending_legal_card.dart';
import 'widgets/about_stats_row.dart';
import 'widgets/commitments_card.dart';

/// Trust page (PROJECT.md Phase 5) — reachable pre-login from Welcome and
/// post-login from Profile's Support section, so it's registered as a
/// public route in `core/router/app_router.dart` (bypasses the auth
/// redirect both ways), same as `/how-it-works`. No AdMob slot — trust/
/// legal pages don't carry ads (PROJECT.md pattern).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AboutProvider(),
      child: const _AboutScreenBody(),
    );
  }
}

class _AboutScreenBody extends StatelessWidget {
  const _AboutScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(AppLocalizations.of(context).aboutTitle),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<AboutProvider>(
          builder: (context, provider, _) {
            final l10n = AppLocalizations.of(context);
            final info = provider.info;

            if (provider.isLoading && info == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (info == null) {
              return const SizedBox.shrink();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                Text(
                  l10n.aboutHeadline,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.aboutBody(info.foundingYear),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                AboutStatsRow(info: info),
                const SizedBox(height: 16),
                const CommitmentsCard(),
                const SizedBox(height: 16),
                // LEGAL-REVIEW: Section 3 item 3 — legal entity name,
                // registration number, and registered address are
                // placeholders only; do not fill these in with an invented
                // value, only with what finance/legal actually confirms.
                PendingLegalCard(
                  title: l10n.companyDetailsTitle,
                  fields: [
                    l10n.legalEntityNameField,
                    l10n.registrationNumberField,
                    l10n.registeredAddressField,
                  ],
                  note: l10n.companyDetailsPendingNote,
                ),
                const SizedBox(height: 28),
                GradientCtaButton(
                  label: l10n.seePaymentProofsButton,
                  onTap: () => context.push('/payment-proofs'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
