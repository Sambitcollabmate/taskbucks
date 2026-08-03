import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
import '../../providers/profile_provider.dart';
import '../../shared/widgets/notice_card.dart';
import 'widgets/premium_checklist_card.dart';
import 'widgets/premium_price_card.dart';

String _formatDate(DateTime date) => DateFormat('d MMM yyyy').format(date);

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ProfileProvider is a shared app-wide instance (main.dart) — see
    // ProfileScreen's doc comment. Subscribing/cancelling here updates the
    // same instance the Profile tab watches, so it no longer goes stale.
    return const _UpgradeScreenBody();
  }
}

class _UpgradeScreenBody extends StatelessWidget {
  const _UpgradeScreenBody();

  Future<void> _onSubscribe(BuildContext context, ProfileProvider provider) async {
    try {
      await provider.subscribeToPremium();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You're now Premium!")),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _onCancel(BuildContext context, ProfileProvider provider) async {
    try {
      await provider.cancelPremium();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription cancelled — benefits continue until the cycle ends.'),
          ),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
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
                  'Unlock 5 extra tasks every day.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                const PremiumPriceCard(),
                const SizedBox(height: 16),
                if (isPremium) ...[
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
                        Expanded(
                          child: Text(
                            profile.premiumCancelPending
                                ? "Cancellation scheduled. Benefits continue until "
                                    '${profile.premiumExpiresAt != null ? _formatDate(profile.premiumExpiresAt!) : 'the end of this cycle'}.'
                                : "You're on Premium.",
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!profile.premiumCancelPending) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: provider.isProcessingBilling
                            ? null
                            : () => _onCancel(context, provider),
                        child: provider.isProcessingBilling
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Cancel subscription'),
                      ),
                    ),
                  ],
                ] else
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
                          onTap: provider.isProcessingBilling
                              ? null
                              : () => _onSubscribe(context, provider),
                          borderRadius: BorderRadius.circular(14),
                          child: Center(
                            child: provider.isProcessingBilling
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Text(
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
                      'purchase credits their ₹125 referral commission, '
                      'it\'s never credited on signup alone. See Refund '
                      'Policy for subscription cancellation terms.',
                ),
                const SizedBox(height: 12),
                const NoticeCard(
                  message:
                      'Premium also unlocks the weekly referral bonus: get '
                      '5+ referrals converting to Premium in the same week '
                      'and earn +5 bonus ad slots the week after.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
