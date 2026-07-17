import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'profile_menu_row.dart';

/// Card wrapper for a group of [ProfileMenuRow]s (Account, Support), each
/// separated by a divider.
class ProfileMenuCard extends StatelessWidget {
  final List<ProfileMenuRow> rows;

  const ProfileMenuCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (final row in rows) ...[
            row,
            if (row != rows.last) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
