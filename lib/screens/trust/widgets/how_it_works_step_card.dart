import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// The 4-step core loop (PROJECT.md Phase 5), each with a gradient number
/// badge — distinct from the flat solid-color badges [HowItWorksList] (the
/// Welcome-screen teaser) uses, since this is the full trust-page version.
class HowItWorksStepCard extends StatelessWidget {
  const HowItWorksStepCard({super.key});

  static const _steps = [
    (
      title: 'Create your free account',
      body: 'Sign up with your mobile number in under a minute — no fees '
          'to join.',
    ),
    (
      title: "Open today's tasks",
      body: '25 tasks reset daily at midnight (30 on the Premium plan).',
    ),
    (
      title: 'Watch the video ad',
      body: 'Each task plays one short, non-skippable video ad — stay on '
          'screen until it finishes.',
    ),
    (
      title: 'Get paid monthly',
      body: 'All earnings are paid out once a month, on the 1st, to UPI '
          'or bank transfer.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          for (var i = 0; i < _steps.length; i++) ...[
            _StepRow(number: i + 1, title: _steps[i].title, body: _steps[i].body),
            if (i != _steps.length - 1) const SizedBox(height: 20),
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
