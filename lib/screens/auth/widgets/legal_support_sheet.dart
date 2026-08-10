import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Bottom sheet opened by Welcome's "Legal & support" link — same
/// `showModalBottomSheet` pattern Settings' `ProfileAvatarPicker` already
/// uses. Replaces the two stacked footer link rows that used to live in
/// the sticky CTA bar, so the bar itself stays down to just the two CTA
/// buttons plus this one ghost link.
class LegalSupportSheet extends StatelessWidget {
  const LegalSupportSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = [
      (icon: LucideIcons.info, label: l10n.aboutUs, path: '/about'),
      (icon: LucideIcons.messageCircleQuestion, label: l10n.faq, path: '/faq'),
      (icon: LucideIcons.mail, label: l10n.contact, path: '/contact'),
      (icon: LucideIcons.fileText, label: l10n.termsOfService, path: '/terms'),
      (icon: LucideIcons.shieldCheck, label: l10n.privacyPolicy, path: '/privacy'),
      (icon: LucideIcons.receiptText, label: l10n.refundPolicy, path: '/refund'),
    ];
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          for (final row in rows)
            ListTile(
              leading: Icon(row.icon, color: AppColors.primary, size: 20),
              title: Text(row.label),
              onTap: () {
                Navigator.pop(context);
                context.push(row.path);
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
