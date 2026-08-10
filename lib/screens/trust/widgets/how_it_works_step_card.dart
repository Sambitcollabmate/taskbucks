import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// The 4-step core loop (PROJECT.md Phase 5), each with a gradient number
/// badge — distinct from the flat solid-color badges [HowItWorksList] (the
/// Welcome-screen teaser) uses, since this is the full trust-page version.
class HowItWorksStepCard extends StatelessWidget {
  const HowItWorksStepCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = [
      (title: l10n.stepCreateAccountTitle, body: l10n.stepCreateAccountBody),
      (title: l10n.stepOpenTasksTitle, body: l10n.stepOpenTasksBody),
      (title: l10n.stepWatchAdTitle, body: l10n.stepWatchAdBody),
      (title: l10n.stepGetPaidTitle, body: l10n.stepGetPaidBody),
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
          for (var i = 0; i < steps.length; i++) ...[
            _StepRow(number: i + 1, title: steps[i].title, body: steps[i].body),
            if (i != steps.length - 1) const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String title;
  final String body;

  const _StepRow({required this.number, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
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
