import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
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
        title: const Text('About'),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<AboutProvider>(
          builder: (context, provider, _) {
            final info = provider.info;

            if (provider.isLoading && info == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (info == null) {
              return const SizedBox.shrink();
            }

            final countFormat = NumberFormat.decimalPattern('en_IN');

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                Text('About EarnBucks', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                Text(
                  'We built EarnBucks in ${info.foundingYear} to make earning '
                  'from your phone simple and honest — watch short video ads, '
                  'complete daily tasks, and get paid on time, every time. '
                  'Today, over ${countFormat.format(info.earnerCount)}+ people '
                  'across ${info.statesCovered} states earn with us.',
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
                const PendingLegalCard(
                  title: 'Company details',
                  fields: ['Legal entity name', 'Registration number', 'Registered address'],
                  note: 'Pending legal confirmation — do not invent a name, '
                      'number, or address here.',
                ),
                const SizedBox(height: 28),
                GradientCtaButton(
                  label: 'See payment proofs',
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
