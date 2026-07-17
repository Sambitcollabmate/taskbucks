import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/transaction.dart';

/// Single transaction row — first built here for Wallet, reused as-is on
/// Transactions and Notifications (see PROJECT.md 6.3). The green
/// credit / red debit amount convention must stay identical across all
/// three; don't fork this into per-screen copies.
class TxnRow extends StatelessWidget {
  final Transaction transaction;

  const TxnRow({super.key, required this.transaction});

  IconData get _icon {
    switch (transaction.category) {
      case TransactionCategory.task:
        return LucideIcons.listChecks;
      case TransactionCategory.ad:
        return LucideIcons.playCircle;
      case TransactionCategory.referral:
        return LucideIcons.userPlus;
      case TransactionCategory.withdrawal:
        return LucideIcons.arrowUpRight;
      case TransactionCategory.other:
        return LucideIcons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    final amountColor = isCredit ? AppColors.earningsGreen : AppColors.danger;
    final amountFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('d MMM, h:mm a');

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: amountColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon, size: 16, color: amountColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateFormatter.format(transaction.date),
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Text(
          '${isCredit ? '+' : '-'}${amountFormatter.format(transaction.amount)}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: amountColor),
        ),
      ],
    );
  }
}
