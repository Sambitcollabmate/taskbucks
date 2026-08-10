import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/contact_topic.dart';
import '../../../l10n/app_localizations.dart';

/// Topic selector for the Contact form, styled to match `AuthTextField`'s
/// box so it sits in the same form visually. See [ContactTopic] for the
/// future-routing note.
class TopicDropdown extends StatelessWidget {
  final ContactTopic value;
  final ValueChanged<ContactTopic> onChanged;

  const TopicDropdown({super.key, required this.value, required this.onChanged});

  String _label(AppLocalizations l10n, ContactTopic topic) {
    switch (topic) {
      case ContactTopic.accountAccess:
        return l10n.topicAccountAccess;
      case ContactTopic.withdrawalIssue:
        return l10n.topicWithdrawalIssue;
      case ContactTopic.adNotCredited:
        return l10n.topicAdNotCredited;
      case ContactTopic.referralCommissionMissing:
        return l10n.topicReferralCommissionMissing;
      case ContactTopic.somethingElse:
        return l10n.topicSomethingElse;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.topicLabel,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<ContactTopic>(
          initialValue: value,
          isExpanded: true,
          onChanged: (topic) {
            if (topic != null) onChanged(topic);
          },
          items: [
            for (final topic in ContactTopic.values)
              DropdownMenuItem(value: topic, child: Text(_label(l10n, topic))),
          ],
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cardBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.25)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.25)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
