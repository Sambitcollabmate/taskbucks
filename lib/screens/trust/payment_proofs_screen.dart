import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/payment_proofs_provider.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import 'widgets/payout_stats_strip.dart';
import 'widgets/proof_card.dart';
import 'widgets/sample_data_banner.dart';
import 'widgets/testimonial_card.dart';

/// Trust page (PROJECT.md Phase 5) — the highest-priority trust surface in
/// the app per the doc, since it's the one screen making direct payout
/// claims. Reachable pre-login from Welcome and post-login from Profile's
/// Support section, same public-route pattern as `/how-it-works`, `/about`,
/// `/faq`, `/contact`. No AdMob slot — trust/legal pages don't carry ads
/// (PROJECT.md pattern).
///
/// Every number on this screen is fake (`PaymentProofsService`) — see the
/// `// LEGAL-REVIEW:` comment there and `SampleDataBanner` below.
class PaymentProofsScreen extends StatelessWidget {
  const PaymentProofsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentProofsProvider(),
      child: const _PaymentProofsScreenBody(),
    );
  }
}

class _PaymentProofsScreenBody extends StatelessWidget {
  const _PaymentProofsScreenBody();

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Payment Proofs'),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<PaymentProofsProvider>(
          builder: (context, provider, _) {
            final summary = provider.summary;

            if (provider.isLoading && summary == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (summary == null) {
              return const SizedBox.shrink();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                const Text(
                  'A look at what real earners have been paid — every '
                  'payout goes out on the 1st, straight to UPI or bank.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                const SampleDataBanner(),
                const SizedBox(height: 20),
                PayoutStatsStrip(
                  lastCycleTotal: summary.lastCycleTotal,
                  totalEarners: summary.totalEarners,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      for (final proof in summary.proofs) ...[
                        ProofCard(proof: proof),
                        if (proof != summary.proofs.last) const Divider(height: 24),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TestimonialCard(
                  quote: summary.testimonialQuote,
                  name: summary.testimonialName,
                ),
                const SizedBox(height: 28),
                if (!isLoggedIn)
                  GradientCtaButton(
                    label: 'Create free account',
                    onTap: () => context.push('/register'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
