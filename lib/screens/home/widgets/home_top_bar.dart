import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/notifications_provider.dart';

class HomeTopBar extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationsTap;

  const HomeTopBar({
    super.key,
    required this.userName,
    required this.onNotificationsTap,
  });

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(l10n),
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
            child: SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    LucideIcons.bell,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                  Consumer<NotificationsProvider>(
                    builder: (context, provider, _) {
                      if (!provider.hasUnread) return const SizedBox.shrink();
                      return const Positioned(
                        top: 6,
                        right: 6,
                        child: _PulsingDot(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Small red unread-notification dot with a soft expanding/fading halo,
/// same pulse pattern as `_DayIndicator` in `week_streak_card.dart`.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return SizedBox(
          width: 18,
          height: 18,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 8 + t * 12,
                height: 8 + t * 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.danger.withValues(alpha: (1 - t) * 0.45),
                ),
              ),
              child!,
            ],
          ),
        );
      },
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.danger,
          shape: BoxShape.circle,
        ),
        child: SizedBox(width: 8, height: 8),
      ),
    );
  }
}
