import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/balance_provider.dart';
import '../../providers/tasks_provider.dart';
import '../../shared/widgets/notice_card.dart';
import '../../shared/widgets/notification_permission_sheet.dart';
import 'widgets/bonus_ads_section.dart';
import 'widgets/featured_task_card.dart';
import 'widgets/reset_countdown.dart';
import 'widgets/task_grid.dart';
import 'widgets/task_stats_row.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TasksProvider(
        balanceProvider: context.read<BalanceProvider>(),
      ),
      child: const _TasksScreenBody(),
    );
  }
}

class _TasksScreenBody extends StatelessWidget {
  const _TasksScreenBody();

  // Completing a task is the deliberate, explained moment (PROJECT.md
  // Notifications doc, Section 1.1) the app asks for the POST_NOTIFICATIONS
  // permission — never an unexplained system dialog on launch. No-ops
  // after the first time, regardless of how the user answered.
  Future<void> _onCompleteTask(BuildContext context, TasksProvider provider) async {
    try {
      await provider.completeCurrentTask();
      if (context.mounted) maybeShowNotificationPermissionSheet(context);
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _onWatchBonusSlot(BuildContext context, TasksProvider provider, int id) async {
    try {
      await provider.completeBonusSlot(id);
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<TasksProvider>(
          builder: (context, provider, _) {
            final summary = provider.summary;

            if (provider.isLoading && summary == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (summary == null) {
              return const SizedBox.shrink();
            }

            final currentTask = summary.currentTask;

            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tasks', style: Theme.of(context).textTheme.headlineSmall),
                      ResetCountdown(resetAt: summary.resetAt),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TaskStatsRow(
                    completed: summary.completedCount,
                    dailyLimit: summary.tasks.length,
                    earnedToday: summary.earnedToday,
                  ),
                  const SizedBox(height: 16),
                  const NoticeCard(
                    message:
                        'Each task plays one short video ad. The ad cannot '
                        'be skipped or minimized — stay on screen until it '
                        'finishes to get credited.',
                  ),
                  if (currentTask != null) ...[
                    const SizedBox(height: 16),
                    FeaturedTaskCard(
                      task: currentTask,
                      onWatchNow: () => _onCompleteTask(context, provider),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text("Today's tasks", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TaskGrid(
                    tasks: summary.tasks,
                    onTapCurrent: () => _onCompleteTask(context, provider),
                  ),
                  const SizedBox(height: 20),
                  BonusAdsSection(
                    slots: summary.bonusSlots,
                    onWatch: (id) => _onWatchBonusSlot(context, provider, id),
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
