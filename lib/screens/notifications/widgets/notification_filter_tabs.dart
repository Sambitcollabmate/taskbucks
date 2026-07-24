import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/notifications_provider.dart';

const _labels = {
  NotificationFilter.earnings: 'Earnings',
  NotificationFilter.account: 'Account',
  NotificationFilter.promotions: 'Promotions',
};

/// Filter tab row for the Notifications screen — same pill style as
/// Transactions' `TransactionFilterTabs`, so both filtered lists in the app
/// look and behave the same way. "All" carries the total unread count.
class NotificationFilterTabs extends StatelessWidget {
  final NotificationFilter selected;
  final int unreadCount;
  final ValueChanged<NotificationFilter> onSelected;

  const NotificationFilterTabs({
    super.key,
    required this.selected,
    required this.unreadCount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterPill(
            label: unreadCount > 0 ? 'All ($unreadCount)' : 'All',
            isActive: selected == NotificationFilter.all,
            onTap: () => onSelected(NotificationFilter.all),
          ),
          const SizedBox(width: 8),
          for (final filter in [
            NotificationFilter.earnings,
            NotificationFilter.account,
            NotificationFilter.promotions,
          ]) ...[
            _FilterPill(
              label: _labels[filter]!,
              isActive: filter == selected,
              onTap: () => onSelected(filter),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
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
