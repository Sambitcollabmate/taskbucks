import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// One push-category preference row (Earnings/Account/Promotions) — plain
/// on/off, unlike two-step verification's toggle: this isn't a security
/// control, so there's no re-auth friction on either direction.
class PushCategoryToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final bool isSaving;
  final ValueChanged<bool> onChanged;

  const PushCategoryToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isSaving,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Switch(
                value: value,
                activeThumbColor: AppColors.primary,
                onChanged: onChanged,
              ),
      ],
    );
  }
}
