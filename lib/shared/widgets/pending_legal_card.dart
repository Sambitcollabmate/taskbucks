import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import 'dashed_border_box.dart';

/// Deliberately unfinished-looking placeholder for any legal field that
/// hasn't been confirmed yet (PROJECT.md Section 3) — dashed warning-
/// colored border, each field shown as "Pending", and an explicit "do not
/// invent" line, so this can never be mistaken for a finished, populated
/// field. First used by About's company-identity block (Section 3 item 3),
/// now also Terms'/Privacy's Grievance Officer sections (item 4) and
/// Privacy's Significant Data Fiduciary status (item 5) — generalized here
/// once a 2nd screen needed the same treatment with different field names.
class PendingLegalCard extends StatelessWidget {
  final String title;
  final List<String> fields;
  final String note;

  const PendingLegalCard({
    super.key,
    required this.title,
    required this.fields,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return DashedBorderBox(
      color: AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.triangleAlert, size: 18, color: AppColors.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppColors.warning),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final field in fields) ...[
            _PendingRow(label: field),
            if (field != fields.last) const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          Text(
            note,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.warning,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingRow extends StatelessWidget {
  final String label;

  const _PendingRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Text(
          'Pending',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }
}
