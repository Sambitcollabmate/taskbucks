import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/task.dart';

/// 5-column grid of every task slot for the day. Only the "next" tile is
/// tappable — locked tiles are visually inert since users can't skip ahead
/// out of order (PROJECT.md roadmap note).
class TaskGrid extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback onTapCurrent;

  const TaskGrid({super.key, required this.tasks, required this.onTapCurrent});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _TaskTile(
          task: task,
          onTap: task.state == TaskState.next ? onTapCurrent : null,
        );
      },
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const _TaskTile({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    switch (task.state) {
      case TaskState.done:
        return Container(
          decoration: BoxDecoration(
            color: AppColors.earningsGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            children: [
              _TaskNumber(id: task.id, color: AppColors.earningsGreen),
              const Center(
                child: Icon(
                  LucideIcons.check,
                  color: AppColors.earningsGreen,
                  size: 18,
                ),
              ),
            ],
          ),
        );

      case TaskState.next:
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryGradientStart,
                    AppColors.primaryGradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  _TaskNumber(id: task.id, color: Colors.white),
                  const Center(
                    child: Icon(
                      LucideIcons.play,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case TaskState.locked:
        return CustomPaint(
          painter: _DashedBorderPainter(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          child: Stack(
            children: [
              _TaskNumber(id: task.id, color: AppColors.textSecondary),
              Center(
                child: Icon(
                  LucideIcons.lock,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  size: 15,
                ),
              ),
            ],
          ),
        );
    }
  }
}

/// Faint task number tucked in the corner of a tile — a subtle "slot 7 of
/// 25" cue that doesn't compete with the done/next/locked state icon.
class _TaskNumber extends StatelessWidget {
  final int id;
  final Color color;

  const _TaskNumber({required this.id, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 6,
      top: 4,
      child: Text(
        '$id',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color.withValues(alpha: 0.18),
        ),
      ),
    );
  }
}

/// Dashed rounded-rect border for locked tiles. Hand-rolled rather than
/// pulling in a package for one visual detail (PROJECT.md 0: boring over
/// clever, minimal deps).
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  static const _dashWidth = 4.0;
  static const _dashGap = 3.0;
  static const _radius = 14.0;

  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 1.5),
      const Radius.circular(_radius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashWidth;
        dashedPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + _dashGap;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
