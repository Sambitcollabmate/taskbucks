import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const TaskBucksApp());
}

class TaskBucksApp extends StatelessWidget {
  const TaskBucksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskBucks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _SetupCheckScreen(),
    );
  }
}

// Temporary screen just to confirm the toolchain + theme work.
// Claude Code will replace this with the real Home screen in Phase 1.
class _SetupCheckScreen extends StatelessWidget {
  const _SetupCheckScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TaskBucks setup ✅',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Theme, fonts, and toolchain are wired up.'),
          ],
        ),
      ),
    );
  }
}