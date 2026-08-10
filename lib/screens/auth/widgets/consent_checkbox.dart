import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Age/terms consent row. [onTapTerms]/[onTapPrivacy] push the in-app
/// `/terms`/`/privacy` legal screens (not an external browser), so the user
/// stays inside the app during signup.
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
    final l10n = AppLocalizations.of(context);
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
                  TextSpan(text: l10n.consentPrefix),
                  TextSpan(
                    text: l10n.termsLabel,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = onTapTerms,
                  ),
                  TextSpan(text: l10n.consentAnd),
                  TextSpan(
                    text: l10n.privacyPolicyLabel,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = onTapPrivacy,
                  ),
                  TextSpan(text: l10n.consentSuffix),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
