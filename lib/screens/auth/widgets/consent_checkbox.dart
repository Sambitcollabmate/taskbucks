import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Age/terms consent row. Terms and Privacy Policy screens don't exist yet
/// (PROJECT.md 7, Phase 5) — both taps are no-ops for now.
class ConsentCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTapTerms;
  final VoidCallback onTapPrivacy;

  const ConsentCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onTapTerms,
    required this.onTapPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 10),
        // Deliberately not wrapped in an outer tap-to-toggle GestureDetector:
        // that would fight the TapGestureRecognizers below for gesture-arena
        // priority, so tapping "Terms" could also flip the checkbox. Only
        // the checkbox itself toggles; the links are independently tappable.
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: "I'm 18+ and agree to the "),
                  TextSpan(
                    text: 'Terms',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = onTapTerms,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = onTapPrivacy,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
