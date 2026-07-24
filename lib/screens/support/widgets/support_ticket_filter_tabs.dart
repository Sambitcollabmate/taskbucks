import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/support_provider.dart';

/// Filter tab row for the Support Tickets screen — same pill style as
/// Transactions'/Notifications' filter tabs, each labeled with its own
/// count per the design doc ("Open ({{count}}) · Closed ({{count}})").
class SupportTicketFilterTabs extends StatelessWidget {
  final SupportTicketFilter selected;
  final int openCount;
  final int closedCount;
  final ValueChanged<SupportTicketFilter> onSelected;

  const SupportTicketFilterTabs({
    super.key,
    required this.selected,
    required this.openCount,
    required this.closedCount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterPill(
            label: 'Open ($openCount)',
            isActive: selected == SupportTicketFilter.open,
            onTap: () => onSelected(SupportTicketFilter.open),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterPill(
            label: 'Closed ($closedCount)',
            isActive: selected == SupportTicketFilter.closed,
            onTap: () => onSelected(SupportTicketFilter.closed),
          ),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterPill({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
