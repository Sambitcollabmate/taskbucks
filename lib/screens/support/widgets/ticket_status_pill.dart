import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/support_ticket.dart';

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
        status.label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
