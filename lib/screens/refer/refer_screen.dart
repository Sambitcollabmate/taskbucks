import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/refer_provider.dart';
import '../../shared/widgets/notice_card.dart';
import 'widgets/refer_stats_row.dart';
import 'widgets/referral_link_card.dart';
import 'widgets/referral_row.dart';
import 'widgets/top_referrers_card.dart';
import 'widgets/weekly_bonus_card.dart';

class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReferProvider(),
      child: const _ReferScreenBody(),
    );
  }
}

class _ReferScreenBody extends StatelessWidget {
  const _ReferScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<ReferProvider>(
          builder: (context, provider, _) {
            final summary = provider.summary;

            if (provider.isLoading && summary == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (summary == null) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Text('Refer & earn', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ReferralLinkCard(referralCode: summary.referralCode),
                  const SizedBox(height: 16),
                  const NoticeCard(
                    variant: NoticeVariant.warn,
                    message:
                        'You earn ₹125 only when someone you refer completes '
                        'the ₹49 Premium purchase, not just for signing up. '
                        'It shows as pending until their payment clears.',
                  ),
                  const SizedBox(height: 16),
                  ReferStatsRow(
                    totalReferred: summary.totalReferred,
                    totalConverted: summary.totalConverted,
                    totalEarned: summary.totalEarned,
                  ),
                  const SizedBox(height: 16),
                  WeeklyBonusCard(summary: summary),
                  const SizedBox(height: 16),
                  TopReferrersCard(topReferrers: summary.topReferrers),
                  const SizedBox(height: 20),
                  Text('Recent referrals', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
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
                        for (final referral in summary.recentReferrals) ...[
                          ReferralRow(referral: referral),
                          if (referral != summary.recentReferrals.last)
                            const Divider(height: 24),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
