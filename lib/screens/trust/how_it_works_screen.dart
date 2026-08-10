import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import 'widgets/how_it_works_step_card.dart';
import 'widgets/trust_info_card.dart';

/// Trust page (PROJECT.md Phase 5) — reachable pre-login from Welcome and
/// post-login from Profile's Support section, so it's registered as a
/// public route in `core/router/app_router.dart` (bypasses the auth
/// redirect both ways) rather than living in either the pre- or post-auth
/// route set. Deliberately has no AdMob slot — trust/legal pages don't
/// carry ads (PROJECT.md pattern).
class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(l10n.howItWorksTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            Text(
              l10n.howItWorksIntro,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const HowItWorksStepCard(),
            const SizedBox(height: 24),
            Text(l10n.wantMore, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TrustInfoCard(
              icon: LucideIcons.gift,
              iconColor: AppColors.primary,
              title: l10n.referAndEarnInfoTitle,
              message: l10n.referAndEarnInfoMessage,
            ),
            const SizedBox(height: 16),
            TrustInfoCard(
              icon: LucideIcons.crown,
              iconColor: AppColors.premiumGold,
              title: l10n.goPremiumInfoTitle,
              bullets: [
                l10n.goPremiumBullet1,
                l10n.goPremiumBullet2,
                l10n.goPremiumBullet3,
              ],
            ),
            const SizedBox(height: 16),
            TrustInfoCard(
              icon: LucideIcons.gift,
              iconColor: AppColors.earningsGreen,
              title: l10n.weeklyBonusInfoTitle,
              message: l10n.weeklyBonusInfoMessage,
            ),
            const SizedBox(height: 28),
            if (!isLoggedIn)
              GradientCtaButton(
                label: l10n.createFreeAccount,
                onTap: () => context.push('/register'),
              ),
          ],
        ),
      ),
    );
  }
}
