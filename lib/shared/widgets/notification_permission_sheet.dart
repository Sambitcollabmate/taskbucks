import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../data/services/notification_permission_service.dart';
import 'gradient_cta_button.dart';

/// Shows the POST_NOTIFICATIONS rationale sheet the first time a user
/// completes a task, then requests the real OS permission if they agree —
/// a deliberate, explained moment (PROJECT.md Notifications doc, Section
/// 1.1) rather than an unexplained system dialog on launch. No-ops (and
/// never shows again) once [NotificationPermissionService.hasPrompted] is
/// true, whichever way the user answered.
Future<void> maybeShowNotificationPermissionSheet(
  BuildContext context, {
  NotificationPermissionService? service,
}) async {
  final permissionService = service ?? NotificationPermissionService();

  if (await permissionService.hasPrompted()) return;
  await permissionService.markPrompted();
  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.cardBackground,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => _NotificationPermissionSheet(service: permissionService),
  );
}

class _NotificationPermissionSheet extends StatelessWidget {
  final NotificationPermissionService service;

  const _NotificationPermissionSheet({required this.service});

  Future<void> _onEnable(BuildContext context) async {
    await service.request();
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.bell, size: 26, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            const Text(
              "Don't lose today's streak",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              "We'll let you know when you're close to missing today's task "
              'cap, and when a task or referral is credited — nothing more.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 22),
            GradientCtaButton(
              label: 'Turn on notifications',
              onTap: () => _onEnable(context),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Not now',
                style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
