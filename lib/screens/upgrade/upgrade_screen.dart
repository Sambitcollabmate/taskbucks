import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
import '../../providers/profile_provider.dart';
import '../../shared/widgets/notice_card.dart';
import 'widgets/premium_checklist_card.dart';
import 'widgets/premium_price_card.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const _UpgradeScreenBody(),
    );
  }
}

class _UpgradeScreenBody extends StatelessWidget {
  const _UpgradeScreenBody();

  void _onSubscribe(BuildContext context) {
    // TODO: wire real Google Play Billing (see PROJECT.md Phase 7, requires
    // Play Console app listing)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Upgrade'),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            final profile = provider.profile;

            if (provider.isLoading && profile == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (profile == null) {
              return const SizedBox.shrink();
            }

            final isPremium = profile.tier == UserTier.premium;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                Text('Go Premium', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                const Text(
                  'More tasks a day, same payout rate.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                const PremiumPriceCard(),
                const SizedBox(height: 16),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.earningsGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.earningsGreen.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.badgeCheck,
                          size: 20,
                          color: AppColors.earningsGreen,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'You\'re on Premium. Manage or cancel from '
                            'Profile → Manage subscription.',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryGradientStart,
                            AppColors.primaryGradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _onSubscribe(context),
                          borderRadius: BorderRadius.circular(14),
                          child: const Center(
                            child: Text(
                              'Subscribe — ₹49/month',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const PremiumChecklistCard(),
                const SizedBox(height: 20),
                const NoticeCard(
                  message:
                      'Billed monthly via Google Play. Cancel anytime from '
                      'Profile → Manage subscription — Premium benefits '
                      'continue until the end of the paid cycle.',
                ),
                const SizedBox(height: 12),
                const NoticeCard(
                  message:
                      'If you were referred by someone, completing this '
                      'purchase credits their ₹15 referral commission — '
                      'it\'s never credited on signup alone.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
