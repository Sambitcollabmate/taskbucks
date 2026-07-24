import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// 4-step mini explainer. Step 4's bonus mechanic is a separate open item
/// (weekly top referrer/ad-watcher bonus, PROJECT.md 2) — not referenced
/// here, this list only covers the core task → payout loop. [onSeeMore],
/// when provided, pushes to the full `/how-it-works` trust page (PROJECT.md
/// Phase 5) — shown as a chevron so the card stays tappable as a whole.
class HowItWorksList extends StatelessWidget {
  final VoidCallback? onSeeMore;

  const HowItWorksList({super.key, this.onSeeMore});

  static const _steps = [
    'Create your free account with just your phone number',
    'Watch short video ads, up to 25 tasks a day, ₹100 per task',
    'Refer friends and earn ₹125 when they go Premium',
    'Get paid straight to your UPI or bank account every month',
  ];

  @override
  Widget build(BuildContext context) {
    final card = Container(
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'How it works',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (onSeeMore != null)
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < _steps.length; i++) ...[
            _StepRow(number: i + 1, text: _steps[i]),
            if (i != _steps.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );

    if (onSeeMore == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onSeeMore,
        borderRadius: BorderRadius.circular(18),
        child: card,
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;

  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
