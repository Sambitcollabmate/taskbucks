import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// The "Four commitments" card (PROJECT.md Phase 5) — transparency, no
/// pay-to-join, fair rates, real support. Same card shape as
/// `HowItWorksStepCard`/`PremiumChecklistCard` for visual consistency
/// across the trust screens.
class CommitmentsCard extends StatelessWidget {
  const CommitmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final commitments = [
      (
        icon: LucideIcons.eye,
        title: l10n.commitmentTransparencyTitle,
        body: l10n.commitmentTransparencyBody,
      ),
      (
        icon: LucideIcons.ban,
        title: l10n.commitmentNoPayToJoinTitle,
        body: l10n.commitmentNoPayToJoinBody,
      ),
      (
        icon: LucideIcons.scale,
        title: l10n.commitmentFairRatesTitle,
        body: l10n.commitmentFairRatesBody,
      ),
      (
        icon: LucideIcons.headset,
        title: l10n.commitmentRealSupportTitle,
        body: l10n.commitmentRealSupportBody,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.fourCommitments, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          for (var i = 0; i < commitments.length; i++) ...[
            _CommitmentRow(
              icon: commitments[i].icon,
              title: commitments[i].title,
              body: commitments[i].body,
            ),
            if (i != commitments.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _CommitmentRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _CommitmentRow({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
