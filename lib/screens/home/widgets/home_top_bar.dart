import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

class HomeTopBar extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationsTap;

  const HomeTopBar({
    super.key,
    required this.userName,
    required this.onNotificationsTap,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        Material(
          color: AppColors.cardBackground,
          shape: const CircleBorder(),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          child: InkWell(
            onTap: onNotificationsTap,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                LucideIcons.bell,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
