import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/home_provider.dart';
import '../../shared/widgets/balance_hero_card.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/task_progress_card.dart';
import 'widgets/upgrade_banner.dart';
import 'widgets/week_streak_card.dart';
import 'widgets/weekly_leaders_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            final summary = provider.summary;

            if (provider.isLoading && summary == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (summary == null) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  HomeTopBar(userName: summary.userName),
                  const SizedBox(height: 20),
                  BalanceHeroCard(
                    balance: summary.balance,
                    onWalletTap: () {},
                    onReferTap: () {},
                  ),
                  const SizedBox(height: 16),
                  TaskProgressCard(
                    completed: summary.tasksCompletedToday,
                    dailyLimit: summary.dailyTaskLimit,
                  ),
                  const SizedBox(height: 16),
                  WeekStreakCard(days: summary.weekProgress),
                  if (!summary.isPremium) ...[
                    const SizedBox(height: 16),
                    UpgradeBanner(onTap: () {}),
                  ],
                  const SizedBox(height: 16),
                  WeeklyLeadersCard(leaders: summary.weeklyLeaders),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
