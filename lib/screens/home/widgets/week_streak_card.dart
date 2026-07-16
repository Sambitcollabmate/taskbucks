import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/daily_progress.dart';

const _dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// Weekly streak strip below the task progress card: one letter per day of
/// the current week, today highlighted, and a small bar beside each day
/// colored by how much of that day's task cap was completed.
class WeekStreakCard extends StatelessWidget {
  final List<DailyProgress> days;

  const WeekStreakCard({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This week', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text(
            'Your daily task streak',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < days.length; i++)
                _DayIndicator(day: days[i], letter: _dayLetters[i]),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayIndicator extends StatefulWidget {
  final DailyProgress day;
  final String letter;

  const _DayIndicator({required this.day, required this.letter});

  @override
  State<_DayIndicator> createState() => _DayIndicatorState();
}

class _DayIndicatorState extends State<_DayIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;

  // Today, while the day's cap isn't done yet, is "in progress" — not
  // missed — so it pulses instead of sitting flat red like a past miss.
  bool get _isInProgress => widget.day.isToday && !widget.day.isComplete;

  @override
  void initState() {
    super.initState();
    if (_isInProgress) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1100),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  Color get _barColor {
    final day = widget.day;
    if (day.isFuture) return AppColors.background;
    if (day.isComplete) return AppColors.earningsGreen;
    if (_isInProgress) return AppColors.primaryGradientStart;
    if (day.ratio > 0) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final isComplete = day.isComplete;
    final isHighlighted = isComplete || _isInProgress;

    Widget circle = Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isComplete
            ? AppColors.earningsGreen
            : _isInProgress
            ? AppColors.primaryGradientStart
            : AppColors.background,
      ),
      child: Text(
        widget.letter,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isHighlighted ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );

    if (_pulseController != null) {
      circle = AnimatedBuilder(
        animation: _pulseController!,
        builder: (context, child) {
          final t = _pulseController!.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 32 + t * 12,
                height: 32 + t * 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGradientStart.withValues(
                    alpha: (1 - t) * 0.35,
                  ),
                ),
              ),
              child!,
            ],
          );
        },
        child: circle,
      );
    }

    return Column(
      children: [
        SizedBox(height: 44, width: 44, child: Center(child: circle)),
        const SizedBox(height: 6),
        Container(
          width: 24,
          height: 5,
          decoration: BoxDecoration(
            color: _barColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}
