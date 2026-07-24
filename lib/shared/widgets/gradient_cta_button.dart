import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Full-width gradient-filled CTA button — the same primary-gradient pill
/// used for Welcome's "Create free account", How It Works' closing CTA, and
/// About's "See payment proofs" (PROJECT.md 6.3). Extracted here once a 3rd
/// screen needed it rather than duplicating the DecoratedBox/InkWell
/// boilerplate again.
class GradientCtaButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const GradientCtaButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
