import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/balance_provider.dart';

void main() {
  runApp(const TaskBucksApp());
}

class TaskBucksApp extends StatelessWidget {
  const TaskBucksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<BalanceProvider>.value(value: balanceProvider),
      ],
      child: MaterialApp.router(
        title: AppConfig.brandName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
