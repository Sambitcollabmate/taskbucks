import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
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
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('How it works'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            const Text(
              'Four simple steps take you from signing up to getting paid — '
              'no offerwalls, no surveys, no hidden catches.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const HowItWorksStepCard(),
            const SizedBox(height: 16),
            const TrustInfoCard(
              icon: LucideIcons.gift,
              iconColor: AppColors.primary,
              title: 'Refer & earn',
              message: 'You earn ₹125 only when someone you refer completes '
                  'the ₹49 Premium purchase, not just for signing up. It '
                  'shows as pending until their payment clears.',
            ),
            const SizedBox(height: 16),
            const TrustInfoCard(
              icon: LucideIcons.crown,
              iconColor: AppColors.premiumGold,
              title: 'Go Premium',
              bullets: [
                '30 tasks/day, up from Free\'s 25',
                'Same ₹/task rate — no reduced payout per task',
                'Cancel anytime — benefits continue until the end of the '
                    'paid cycle',
              ],
            ),
            const SizedBox(height: 16),
            const TrustInfoCard(
              icon: LucideIcons.gift,
              iconColor: AppColors.earningsGreen,
              title: 'Weekly referral bonus',
              message:
                  'Premium members who get 5 or more referrals converting '
                  'to Premium in the same Sunday–Saturday week earn +5 '
                  'bonus ad slots, active the following week. The week '
                  "that counts is when your referral's purchase lands, not "
                  'when they signed up. Each week resets clean with no '
                  'partial carryover.',
            ),
            const SizedBox(height: 28),
            if (!isLoggedIn)
              GradientCtaButton(
                label: 'Create free account',
                onTap: () => context.push('/register'),
              ),
          ],
        ),
      ),
    );
  }
}
