import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/transactions_provider.dart';

const _labels = {
  TransactionFilter.all: 'All',
  TransactionFilter.tasks: 'Tasks',
  TransactionFilter.referrals: 'Referrals',
  TransactionFilter.withdrawals: 'Withdrawals',
};

/// Filter tab row for the Transactions screen (PROJECT.md Phase 4) — the
/// active tab is a filled [AppColors.primary] pill, inactive tabs stay
/// neutral outlined pills.
class TransactionFilterTabs extends StatelessWidget {
  final TransactionFilter selected;
  final ValueChanged<TransactionFilter> onSelected;

  const TransactionFilterTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in TransactionFilter.values) ...[
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
