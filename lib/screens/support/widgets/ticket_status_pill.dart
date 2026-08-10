import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/support_ticket.dart';
import '../../../l10n/app_localizations.dart';

/// Gray open / orange in-progress / green resolved, per PROJECT.md Phase 6.
class TicketStatusPill extends StatelessWidget {
  final SupportTicketStatus status;

  const TicketStatusPill({super.key, required this.status});

  Color get _color {
    switch (status) {
      case SupportTicketStatus.open:
        return AppColors.textSecondary;
      case SupportTicketStatus.inProgress:
        return AppColors.warning;
      case SupportTicketStatus.resolved:
        return AppColors.earningsGreen;
    }
  }

  String _label(AppLocalizations l10n) {
    switch (status) {
      case SupportTicketStatus.open:
        return l10n.ticketStatusOpen;
      case SupportTicketStatus.inProgress:
        return l10n.ticketStatusReply;
      case SupportTicketStatus.resolved:
        return l10n.ticketStatusClosed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label(AppLocalizations.of(context)),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
