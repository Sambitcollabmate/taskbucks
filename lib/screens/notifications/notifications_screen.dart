import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/app_notification.dart';
import '../../data/models/notification_type.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../shared/widgets/notification_row.dart';

/// Push-only screen (PROJECT.md 6.1), reached from Profile's Notifications
/// row. Tapping a notification marks it read and deep-links to the
/// relevant screen per `NotificationType`: task credit goes to
/// Transactions (pre-filtered), withdrawal goes to the Withdraw screen
/// (real destination now that it's built), referral and streak go to
/// their tabs.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsProvider(),
      child: const _NotificationsScreenBody(),
    );
  }
}

class _NotificationsScreenBody extends StatelessWidget {
  const _NotificationsScreenBody();

  void _onNotificationTap(BuildContext context, AppNotification notification) {
    context.read<NotificationsProvider>().markRead(notification.id);

    switch (notification.type) {
      case NotificationType.taskCredited:
        context.push('/transactions', extra: TransactionFilter.tasks);
        break;
      case NotificationType.withdrawalQueued:
        context.push('/withdraw');
        break;
      case NotificationType.referralConverted:
        context.go('/refer');
        break;
      case NotificationType.streakBonus:
        context.go('/home');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Notifications'),
        actions: [
          Consumer<NotificationsProvider>(
            builder: (context, provider, _) {
              return TextButton(
                onPressed: provider.hasUnread ? provider.markAllRead : null,
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: provider.hasUnread
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Consumer<NotificationsProvider>(
          builder: (context, provider, _) {
            final notifications = provider.notifications;

            if (provider.isLoading && notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (notifications.isEmpty) {
              return const Center(
                child: Text(
                  'No notifications yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
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
                        for (final notification in notifications) ...[
                          NotificationRow(
                            notification: notification,
                            onTap: () => _onNotificationTap(context, notification),
                          ),
                          if (notification != notifications.last)
                            const Divider(height: 8),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
