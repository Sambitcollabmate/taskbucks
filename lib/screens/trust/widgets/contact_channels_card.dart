import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// "Other ways to reach us" — visually distinct from the form above (its
/// own bordered card) with real tappable `mailto:` links, not just email
/// text, plus the same tier-aware response-time promise repeated here.
class ContactChannelsCard extends StatelessWidget {
  final String responseTimeRange;

  const ContactChannelsCard({super.key, required this.responseTimeRange});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final supportEmail = 'support@${AppConfig.brandDomain}';
    final paymentsEmail = 'payments@${AppConfig.brandDomain}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.otherWaysToReachUs, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          _MailtoRow(
            icon: LucideIcons.lifeBuoy,
            label: l10n.supportChannelLabel,
            email: supportEmail,
          ),
          const SizedBox(height: 14),
          _MailtoRow(
            icon: LucideIcons.wallet,
            label: l10n.paymentsChannelLabel,
            email: paymentsEmail,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Text(
            l10n.weUsuallyReplyWithin(responseTimeRange),
            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _MailtoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String email;

  const _MailtoRow({required this.icon, required this.label, required this.email});

  Future<void> _launch(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: email);
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).noEmailAppFound(email))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launch(context),
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
