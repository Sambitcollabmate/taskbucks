import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/payment_proof.dart';

/// One repeating row in the Payment Proofs list — amount in green (the
/// same credit-amount convention as `TxnRow`), masked username, method,
/// date, and a "PAID" pill. This data is illustrative only — see
/// `SampleDataBanner`.
class ProofCard extends StatelessWidget {
  final PaymentProofEntry proof;

  const ProofCard({super.key, required this.proof});

  @override
  Widget build(BuildContext context) {
    final amountFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('d MMM yyyy');
    final isUpi = proof.method == 'UPI';

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.earningsGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isUpi ? LucideIcons.smartphone : LucideIcons.landmark,
            size: 16,
            color: AppColors.earningsGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                proof.maskedUsername,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${proof.method} · ${dateFormat.format(proof.date)}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amountFormat.format(proof.amount),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.earningsGreen,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.earningsGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PAID',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: AppColors.earningsGreen,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
