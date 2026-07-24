import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/dashed_border_box.dart';

/// The "this is fake data" warning for Payment Proofs — dashed *red* border
/// (escalated from About's `LegalPendingCard`, which uses warning/orange,
/// since fabricated payment proof on a real-money app is a materially
/// worse problem than a pending legal field — see the `// LEGAL-REVIEW:`
/// comment on `PaymentProofsService`). Deliberately loud: this stays at the
/// very top of the screen and must not be removed just because the rest of
/// the screen looks finished — it only comes out once the data underneath
/// it is real.
class SampleDataBanner extends StatelessWidget {
  const SampleDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return DashedBorderBox(
      color: AppColors.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.triangleAlert, size: 18, color: AppColors.danger),
              const SizedBox(width: 8),
              Text(
                'Sample data — not live',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.danger),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Every amount, name, and date on this screen is illustrative, '
            'not a real payout. This banner stays until this screen is '
            'wired to real transaction records.',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.danger,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
